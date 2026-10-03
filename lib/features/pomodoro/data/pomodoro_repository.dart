import 'package:drift/drift.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';

/// Data access for Pomodoro sessions and presets.
class PomodoroRepository {
  final AppDatabase _db;

  PomodoroRepository(this._db);

  // -- Presets ---------------------------------------------------------------

  Future<List<PomodoroPreset>> getAllPresets() {
    return _db.select(_db.pomodoroPresets).get();
  }

  Future<PomodoroPreset?> getPreset(int id) {
    return (_db.select(_db.pomodoroPresets)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<PomodoroPreset?> getPresetByName(String name) {
    return (_db.select(_db.pomodoroPresets)
          ..where((t) => t.name.equals(name)))
        .getSingleOrNull();
  }

  Future<int> createPreset({
    required String name,
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int totalCycles,
    bool isCustom = false,
  }) {
    return _db.into(_db.pomodoroPresets).insert(
          PomodoroPresetsCompanion.insert(
            name: name,
            workMinutes: workMinutes,
            shortBreakMinutes: shortBreakMinutes,
            longBreakMinutes: longBreakMinutes,
            totalCycles: Value(totalCycles),
            isCustom: Value(isCustom),
          ),
        );
  }

  Future<void> ensureDefaultPresets() async {
    final existing = await getAllPresets();
    if (existing.isNotEmpty) return;
    
    await createPreset(
      name: 'Standard',
      workMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      totalCycles: 4,
      isCustom: false,
    );
    await createPreset(
      name: 'Deep Work',
      workMinutes: 50,
      shortBreakMinutes: 10,
      longBreakMinutes: 20,
      totalCycles: 4,
      isCustom: false,
    );
    await createPreset(
      name: 'Quick',
      workMinutes: 15,
      shortBreakMinutes: 3,
      longBreakMinutes: 10,
      totalCycles: 4,
      isCustom: false,
    );
  }

  Future<void> updatePreset({
    required int id,
    required String name,
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int totalCycles,
  }) async {
    await (_db.update(_db.pomodoroPresets)..where((t) => t.id.equals(id))).write(
      PomodoroPresetsCompanion(
        name: Value(name),
        workMinutes: Value(workMinutes),
        shortBreakMinutes: Value(shortBreakMinutes),
        longBreakMinutes: Value(longBreakMinutes),
        totalCycles: Value(totalCycles),
      ),
    );
  }

  Future<void> deletePreset(int id) async {
    await (_db.delete(_db.pomodoroPresets)..where((t) => t.id.equals(id))).go();
  }

  // -- Sessions --------------------------------------------------------------

  DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<PomodoroSession> getOrCreateToday([DateTime? now]) async {
    final day = _day(now ?? DateTime.now());
    final existing = await (_db.select(_db.pomodoroSessions)
          ..where((t) => t.date.equals(day)))
        .getSingleOrNull();
    if (existing != null) return existing;
    final id = await _db.into(_db.pomodoroSessions).insert(
          PomodoroSessionsCompanion(
            date: Value(DateTime(now?.year ?? DateTime.now().year,
                now?.month ?? DateTime.now().month, now?.day ?? DateTime.now().day)),
            workMinutes: Value(25),
            shortBreakMinutes: Value(5),
            longBreakMinutes: Value(15),
            mode: Value('work'),
          ),
        );
    return (_db.select(_db.pomodoroSessions)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Stream<PomodoroSession?> watchToday([DateTime? now]) {
    final day = _day(now ?? DateTime.now());
    return (_db.select(_db.pomodoroSessions)
          ..where((t) => t.date.equals(day)))
        .watchSingleOrNull();
  }

  Stream<PomodoroSession?> watchTodayEnsured([DateTime? now]) async* {
    await getOrCreateToday(now);
    yield* watchToday(now);
  }

  Future<PomodoroSession?> recordOn(DateTime date) {
    final day = _day(date);
    return (_db.select(_db.pomodoroSessions)
          ..where((t) => t.date.equals(day)))
        .getSingleOrNull();
  }

  Future<void> updateSession({
    required int id,
    String? mode,
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? completedWorkSessions,
    int? totalFocusMinutes,
  }) async {
    await (_db.update(_db.pomodoroSessions)..where((t) => t.id.equals(id))).write(
      PomodoroSessionsCompanion(
        mode: mode != null ? Value(mode) : const Value.absent(),
        workMinutes: workMinutes != null
            ? Value(workMinutes)
            : const Value.absent(),
        shortBreakMinutes: shortBreakMinutes != null
            ? Value(shortBreakMinutes)
            : const Value.absent(),
        longBreakMinutes: longBreakMinutes != null
            ? Value(longBreakMinutes)
            : const Value.absent(),
        completedWorkSessions: completedWorkSessions != null
            ? Value(completedWorkSessions)
            : const Value.absent(),
        totalFocusMinutes: totalFocusMinutes != null
            ? Value(totalFocusMinutes)
            : const Value.absent(),
      ),
    );
  }

  // -- Statistics ------------------------------------------------------------

  Future<int> focusStreak([DateTime? now]) async {
    final day = DateTime(now?.year ?? DateTime.now().year,
        now?.month ?? DateTime.now().month, now?.day ?? DateTime.now().day);
    final rows = await (_db.select(_db.pomodoroSessions)
          ..where((t) => t.date.isSmallerThanValue(DateTime(
              now?.year ?? DateTime.now().year,
              now?.month ?? DateTime.now().month,
              now?.day ?? DateTime.now().day)))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(366))
        .get();
    var streak = 0;
    var cursor = DateTime(now?.year ?? DateTime.now().year,
        now?.month ?? DateTime.now().month, now?.day ?? DateTime.now().day)
        .subtract(const Duration(days: 1));
    for (final r in rows) {
      if (r.date.year != cursor.year ||
          r.date.month != cursor.month ||
          r.date.day != cursor.day) break;
      if ((r.totalFocusMinutes ?? 0) == 0) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<int> totalFocusMinutes([DateTime? from, DateTime? to]) async {
    final query = _db.select(_db.pomodoroSessions);
    if (from != null) {
      final day = DateTime(from.year, from.month, from.day);
      query.where((t) => t.date.isBiggerOrEqualValue(day));
    }
    if (to != null) {
      final day = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));
      query.where((t) => t.date.isSmallerThanValue(day));
    }
    final rows = await query.get();
    return rows.fold<int>(0, (sum, r) => sum + (r.totalFocusMinutes ?? 0));
  }

  Future<int> completedSessions([DateTime? from, DateTime? to]) async {
    final query = _db.select(_db.pomodoroSessions);
    if (from != null) {
      final day = DateTime(from.year, from.month, from.day);
      query.where((t) => t.date.isBiggerOrEqualValue(day));
    }
    if (to != null) {
      final day = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));
      query.where((t) => t.date.isSmallerThanValue(day));
    }
    final rows = await query.get();
    return rows.fold<int>(0, (sum, r) => sum + (r.completedWorkSessions ?? 0));
  }

  Future<List<PomodoroSession>> getSessionsBetween(DateTime start, DateTime end) async {
    final query = _db.select(_db.pomodoroSessions);
    query.where((t) => t.date.isBiggerOrEqualValue(start));
    final endExclusive = end.add(const Duration(days: 1));
    query.where((t) => t.date.isSmallerThanValue(endExclusive));
    return query.get();
  }

  /// Returns the user's Pomodoro settings (creates default if not exists).
  Future<PomodoroSettings> getSettings() async {
    // For now, return defaults. In the future, this could be stored in prefs.
    return const PomodoroSettings(
      workMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      totalCycles: 4,
    );
  }
}
