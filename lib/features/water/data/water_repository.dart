import 'package:drift/drift.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/features/scoring/domain/score_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Daily water records. Millilitres are the source of truth;
/// cups are derived from the cup size. Settings live in prefs.
class WaterRepository {
  final AppDatabase _db;
  final SharedPreferences _prefs;

  WaterRepository(this._db, this._prefs);

  /// Exposed for scoring/tests that share this database.
  AppDatabase get db => _db;

  // -- Settings (prefs-backed, with frozen defaults) ------------------------

  int get goalCups =>
      _prefs.getInt(PrefKeys.waterGoalCups) ?? ScoreDefaults.waterGoalCups;
  int get cupSizeMl =>
      _prefs.getInt(PrefKeys.waterCupSizeMl) ?? ScoreDefaults.waterCupSizeMl;
  int get wakeMinutes =>
      _prefs.getInt(PrefKeys.waterWakeMinutes) ??
      ScoreDefaults.waterWakeMinutes;
  int get sleepMinutes =>
      _prefs.getInt(PrefKeys.waterSleepMinutes) ??
      ScoreDefaults.waterSleepMinutes;
  int get reminderInterval =>
      _prefs.getInt(PrefKeys.waterReminderInterval) ??
      ScoreDefaults.waterReminderIntervalMinutes;
  bool get remindersEnabled =>
      _prefs.getBool(PrefKeys.waterRemindersEnabled) ?? true;

  int get goalMl => goalCups * cupSizeMl;

  Future<void> saveSettings({
    int? goalCups,
    int? cupSizeMl,
    int? wakeMinutes,
    int? sleepMinutes,
    int? reminderInterval,
    bool? remindersEnabled,
  }) async {
    if (goalCups != null) {
      await _prefs.setInt(PrefKeys.waterGoalCups, goalCups);
    }
    if (cupSizeMl != null) {
      await _prefs.setInt(PrefKeys.waterCupSizeMl, cupSizeMl);
    }
    if (wakeMinutes != null) {
      await _prefs.setInt(PrefKeys.waterWakeMinutes, wakeMinutes);
    }
    if (sleepMinutes != null) {
      await _prefs.setInt(PrefKeys.waterSleepMinutes, sleepMinutes);
    }
    if (reminderInterval != null) {
      await _prefs.setInt(
          PrefKeys.waterReminderInterval, reminderInterval);
    }
    if (remindersEnabled != null) {
      await _prefs.setBool(
          PrefKeys.waterRemindersEnabled, remindersEnabled);
    }
    // Snapshot goal/cup into today's row so history stays meaningful.
    final today = await getOrCreateToday();
    await (_db.update(_db.waterRecords)
          ..where((t) => t.id.equals(today.id)))
        .write(WaterRecordsCompanion(
      goalCups: Value(this.goalCups),
      cupSizeMl: Value(this.cupSizeMl),
      wakeTimeMinutes: Value(wakeMinutes ?? today.wakeTimeMinutes),
      sleepTimeMinutes: Value(sleepMinutes ?? today.sleepTimeMinutes),
    ));
  }

  // -- Records ---------------------------------------------------------------

  DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<WaterRecord> getOrCreateToday([DateTime? now]) async {
    final day = _day(now ?? DateTime.now());
    final existing = await (_db.select(_db.waterRecords)
          ..where((t) => t.date.equals(day)))
        .getSingleOrNull();
    if (existing != null) return existing;
    final id = await _db.into(_db.waterRecords).insert(
          WaterRecordsCompanion.insert(
            date: day,
            goalCups: Value(goalCups),
            cupSizeMl: Value(cupSizeMl),
            wakeTimeMinutes: Value(wakeMinutes),
            sleepTimeMinutes: Value(sleepMinutes),
          ),
        );
    return (_db.select(_db.waterRecords)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Stream<WaterRecord?> watchToday([DateTime? now]) {
    final day = _day(now ?? DateTime.now());
    return (_db.select(_db.waterRecords)..where((t) => t.date.equals(day)))
        .watchSingleOrNull();
  }

  Stream<WaterRecord?> watchTodayEnsured([DateTime? now]) async* {
    await getOrCreateToday(now);
    yield* watchToday(now);
  }

  /// Adds [ml] (clamped ≥ 0 total). Returns the updated row.
  /// [on] overrides "today" (used by tests/backfill; defaults to now).
  Future<WaterRecord> addMl(int ml, [DateTime? on]) async {
    final target = await getOrCreateToday(on);
    final updated = (target.mlConsumed + ml).clamp(0, 10000);
    await (_db.update(_db.waterRecords)
          ..where((t) => t.id.equals(target.id)))
        .write(WaterRecordsCompanion(mlConsumed: Value(updated)));
    return getOrCreateToday(on);
  }

  Future<List<WaterRecord>> lastDays(int n, [DateTime? now]) async {
    final today = _day(now ?? DateTime.now());
    final start = today.subtract(Duration(days: n - 1));
    return (_db.select(_db.waterRecords)
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  static bool goalMet(WaterRecord record, int goalMl) =>
      record.mlConsumed >= goalMl;

  /// Consecutive goal-met days strictly before [today].
  /// Uses each day's snapshot goal so past settings changes don't rewrite
  /// history.
  Future<int> goalStreak(DateTime today) async {
    final day = _day(today);
    final rows = await (_db.select(_db.waterRecords)
          ..where((t) => t.date.isSmallerThanValue(day))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(366))
        .get();
    var streak = 0;
    var cursor = day.subtract(const Duration(days: 1));
    for (final r in rows) {
      if (!_sameDay(r.date, cursor)) break;
      if (r.mlConsumed < r.goalCups * r.cupSizeMl) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
