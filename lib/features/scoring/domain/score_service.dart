import 'package:drift/drift.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:pd/features/scoring/domain/score_constants.dart';

/// Writes section scores into [DailyScores] and maintains the weighted
/// overall score + streaks. Each phase calls its own `record*` method;
/// the scoring dashboard (Phase 7) only reads.
class ScoreService {
  final AppDatabase _db;

  ScoreService(this._db);

  DateTime _day(DateTime d) => dateOnly(d);

  Stream<DailyScore?> watchToday([DateTime? now]) {
    final day = _day(now ?? DateTime.now());
    return (_db.select(_db.dailyScores)..where((t) => t.date.equals(day)))
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.single);
  }

  Future<DailyScore?> todayRow([DateTime? now]) async {
    final day = _day(now ?? DateTime.now());
    return (_db.select(_db.dailyScores)..where((t) => t.date.equals(day)))
        .getSingleOrNull();
  }

  /// Records one completed to-do.
  /// Base [ScorePoints.todoCompleted], halved when [overdue], plus the
  /// streak bonus (consecutive prior days with completions).
  Future<void> recordTodoCompletion({
    required DateTime completedAt,
    required bool overdue,
    DateTime? now,
  }) async {
    final today = _day(now ?? DateTime.now());
    final streak = await _todoStreak(today);
    final base = overdue
        ? (ScorePoints.todoCompleted * ScorePoints.todoOverdueFactor).round()
        : ScorePoints.todoCompleted;
    final bonus = (streak * ScorePoints.todoStreakBonusPerDay)
        .clamp(0, ScorePoints.todoStreakBonusCap);
    final row = await _getOrCreate(today);
    final updated = (row.todoScore + base + bonus)
        .clamp(0, ScorePoints.todoDailyCap);
    await _writeTodoScore(row, updated, today);
  }

  /// Consecutive days strictly before [today] with todoScore > 0.
  Future<int> _todoStreak(DateTime today) async {
    final rows = await (_db.select(_db.dailyScores)
          ..where((t) => t.date.isSmallerThanValue(today))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(365))
        .get();
    var streak = 0;
    var cursor = today.subtract(const Duration(days: 1));
    for (final r in rows) {
      if (!isSameDay(r.date, cursor)) break;
      if (r.todoScore <= 0) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<DailyScore> _getOrCreate(DateTime today) async {
    final existing = await todayRow(today);
    if (existing != null) return existing;
    final id = await _db.into(_db.dailyScores).insert(
          DailyScoresCompanion.insert(date: today),
        );
    return (await (_db.select(_db.dailyScores)
              ..where((t) => t.id.equals(id)))
            .getSingle());
  }

  Future<void> _writeTodoScore(DailyScore row, int value, DateTime today) async {
    await (_db.update(_db.dailyScores)..where((t) => t.id.equals(row.id)))
        .write(DailyScoresCompanion(todoScore: Value(value)));
    await recalcToday(today);
  }

  /// Recomputes the whole prayer section for [date] from its record.
  /// Idempotent: call after every prayer/ibadah toggle. Jama'at and mosque
  /// bonuses count only when the fard itself is marked.
  Future<void> recordPrayerDay(DateTime date, {DateTime? now}) async {
    final day = _day(date);
    final today = _day(now ?? DateTime.now());
    final record = await (_db.select(_db.prayerRecords)
          ..where((t) => t.date.equals(day)))
        .getSingleOrNull();

    var points = 0;
    if (record != null) {
      for (final p in PrayerName.values) {
        if (record.prayed(p)) {
          points += ScorePoints.prayerOnTime;
          if (record.mosque(p)) points += ScorePoints.prayerMosqueBonus;
          if (record.jamaat(p)) points += ScorePoints.prayerJamaatBonus;
        }
      }
      if (record.tahajjud) points += ScorePoints.tahajjud;
      if (record.duha) points += ScorePoints.duha;
      if (record.quranWaqiah) points += ScorePoints.quranWaqiah;
      if (record.quranMulk) points += ScorePoints.quranMulk;
      points += (record.quranOtherPages * ScorePoints.quranPage)
          .clamp(0, ScorePoints.quranOtherCap);
      if (record.adhkarMorning) points += ScorePoints.adhkarEach;
      if (record.adhkarEvening) points += ScorePoints.adhkarEach;
      points += _dhikrPoints(record.salatDone, record.salatCount);
      points += _dhikrPoints(record.thahleelDone, record.thahleelCount);
      points += _dhikrPoints(record.isthighfarDone, record.isthighfarCount);

      final streak = await _prayerStreak(day);
      points += (streak * ScorePoints.prayerStreakBonusPerDay)
          .clamp(0, ScorePoints.prayerStreakBonusCap);
    }

    final row = await _getOrCreate(today);
    // Prayer points belong to their own day; only today's row is live.
    // (Past days keep history in prayer_records; section history rebuilds
    // fully in Phase 7.)
    if (isSameDay(day, today)) {
      await (_db.update(_db.dailyScores)..where((t) => t.id.equals(row.id)))
          .write(DailyScoresCompanion(
              prayerScore: Value(points.clamp(0, ScoreSectionCaps.prayer))));
      await recalcToday(today);
    }
  }

  static int _dhikrPoints(bool done, int count) {
    if (!done) return 0;
    return (ScorePoints.dhikrDoneBase +
            (count ~/ 10) * ScorePoints.dhikrPerTen)
        .clamp(0, ScorePoints.dhikrCap);
  }

  /// Consecutive days strictly before [day] with all 5 fard marked.
  Future<int> _prayerStreak(DateTime day) async {
    final rows = await (_db.select(_db.prayerRecords)
          ..where((t) => t.date.isSmallerThanValue(day))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(366))
        .get();
    var streak = 0;
    var cursor = day.subtract(const Duration(days: 1));
    for (final r in rows) {
      if (!isSameDay(r.date, cursor)) break;
      if (!(r.fajr && r.dhuhr && r.asr && r.maghrib && r.isha)) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Recomputes [DailyScores.totalScore] (weighted 0-100) and
  /// [DailyScores.streakDays] (consecutive active days).
  Future<void> recalcToday([DateTime? now]) async {
    final today = _day(now ?? DateTime.now());
    final row = await _getOrCreate(today);
    final total = normalizeTotal(
      prayer: row.prayerScore,
      todo: row.todoScore,
      screenTime: row.screenTimeScore,
      water: row.waterScore,
    );
    final streak = await _overallStreak(today);
    await (_db.update(_db.dailyScores)..where((t) => t.id.equals(row.id)))
        .write(
      DailyScoresCompanion(
        totalScore: Value(total),
        streakDays: Value(streak),
      ),
    );
  }

  /// Weighted overall score, 0-100. Pure function — unit tested.
  static int normalizeTotal({
    required int prayer,
    required int todo,
    required int screenTime,
    required int water,
  }) {
    double norm(int value, int cap) =>
        cap <= 0 ? 0 : (value.clamp(0, cap) / cap);
    final score = ScoreWeights.prayer * norm(prayer, ScoreSectionCaps.prayer) +
        ScoreWeights.todo * norm(todo, ScoreSectionCaps.todo) +
        ScoreWeights.screenTime *
            norm(screenTime, ScoreSectionCaps.screenTime) +
        ScoreWeights.water * norm(water, ScoreSectionCaps.water);
    return (score * 100).round().clamp(0, 100);
  }

  /// Consecutive days ending today/yesterday with any section score > 0.
  Future<int> _overallStreak(DateTime today) async {
    final rows = await (_db.select(_db.dailyScores)
          ..where((t) => t.date.isSmallerOrEqualValue(today))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(366))
        .get();
    if (rows.isEmpty) return 0;
    var cursor = today;
    var rowIdx = 0;
    // Allow today to be empty if yesterday was active.
    if (!_isActive(rows.first) && rows.length > 1 && isSameDay(rows[1].date, today.subtract(const Duration(days: 1)))) {
      rowIdx = 1;
      cursor = today.subtract(const Duration(days: 1));
    }
    var streak = 0;
    for (var i = rowIdx; i < rows.length; i++) {
      final r = rows[i];
      if (!isSameDay(r.date, cursor)) break;
      if (!_isActive(r)) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static bool _isActive(DailyScore r) =>
      r.todoScore > 0 ||
      r.prayerScore > 0 ||
      r.waterScore > 0 ||
      r.screenTimeScore > 0;
}
