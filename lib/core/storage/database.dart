import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// To-Do module
// ---------------------------------------------------------------------------

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  // Date + time stored separately so "date" grouping and reminders are easy.
  DateTimeColumn get dueDate => dateTime().nullable()();
  // Minutes since midnight, null = no specific time.
  IntColumn get dueTimeMinutes => integer().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  // Day-before reminder bookkeeping (10:00 AM and 6:00 PM).
  BoolColumn get reminder10amSent => boolean().withDefault(const Constant(false))();
  BoolColumn get reminder6pmSent => boolean().withDefault(const Constant(false))();
}

class TodoTrash extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get todoId => integer()();
  TextColumn get title => text()();
  DateTimeColumn get originalDueDate => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().clientDefault(() => DateTime.now())();
}

// ---------------------------------------------------------------------------
// Muslim (prayer) tracker module
// ---------------------------------------------------------------------------

class PrayerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Date-only value (midnight local time).
  DateTimeColumn get date => dateTime()();

  // The five fard prayers.
  BoolColumn get fajr => boolean().withDefault(const Constant(false))();
  BoolColumn get dhuhr => boolean().withDefault(const Constant(false))();
  BoolColumn get asr => boolean().withDefault(const Constant(false))();
  BoolColumn get maghrib => boolean().withDefault(const Constant(false))();
  BoolColumn get isha => boolean().withDefault(const Constant(false))();

  // Prayed as jama'at?
  BoolColumn get fajrJamaat => boolean().withDefault(const Constant(false))();
  BoolColumn get dhuhrJamaat => boolean().withDefault(const Constant(false))();
  BoolColumn get asrJamaat => boolean().withDefault(const Constant(false))();
  BoolColumn get maghribJamaat => boolean().withDefault(const Constant(false))();
  BoolColumn get ishaJamaat => boolean().withDefault(const Constant(false))();

  // Prayed in mosque?
  BoolColumn get fajrMosque => boolean().withDefault(const Constant(false))();
  BoolColumn get dhuhrMosque => boolean().withDefault(const Constant(false))();
  BoolColumn get asrMosque => boolean().withDefault(const Constant(false))();
  BoolColumn get maghribMosque => boolean().withDefault(const Constant(false))();
  BoolColumn get ishaMosque => boolean().withDefault(const Constant(false))();

  // Extra ibadah.
  BoolColumn get tahajjud => boolean().withDefault(const Constant(false))();
  BoolColumn get duha => boolean().withDefault(const Constant(false))();
  BoolColumn get quranWaqiah => boolean().withDefault(const Constant(false))();
  BoolColumn get quranMulk => boolean().withDefault(const Constant(false))();
  IntColumn get quranOtherPages => integer().withDefault(const Constant(0))();
  BoolColumn get adhkarMorning => boolean().withDefault(const Constant(false))();
  BoolColumn get adhkarEvening => boolean().withDefault(const Constant(false))();

  // Checkbox + optional counter for each dhikr.
  BoolColumn get salatDone => boolean().withDefault(const Constant(false))();
  IntColumn get salatCount => integer().withDefault(const Constant(0))();
  BoolColumn get thahleelDone => boolean().withDefault(const Constant(false))();
  IntColumn get thahleelCount => integer().withDefault(const Constant(0))();
  BoolColumn get isthighfarDone => boolean().withDefault(const Constant(false))();
  IntColumn get isthighfarCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

class PrayerSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get calculationMethod =>
      text().withDefault(const Constant('MuslimWorldLeague'))();
  TextColumn get madhab => text().withDefault(const Constant('Shafi'))();
  // Per-prayer minute offsets as JSON, e.g. {"Fajr": 2, "Isha": -3}.
  TextColumn get manualOffsetsJson => text().withDefault(const Constant('{}'))();
  BoolColumn get useManual => boolean().withDefault(const Constant(false))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(false))();
}

// ---------------------------------------------------------------------------
// Water tracker module
// ---------------------------------------------------------------------------

class WaterRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Date-only value (midnight local time).
  DateTimeColumn get date => dateTime()();
  IntColumn get cupsConsumed => integer().withDefault(const Constant(0))();
  IntColumn get cupSizeMl => integer().withDefault(const Constant(250))();
  IntColumn get goalCups => integer().withDefault(const Constant(8))();
  // Snapshot of wake/sleep used for reminder scheduling that day.
  IntColumn get wakeTimeMinutes => integer().withDefault(const Constant(420))();
  IntColumn get sleepTimeMinutes => integer().withDefault(const Constant(1380))();
}

// ---------------------------------------------------------------------------
// Pomodoro module
// ---------------------------------------------------------------------------

class PomodoroSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mode => text()();
  IntColumn get workMinutes => integer()();
  IntColumn get shortBreakMinutes => integer()();
  IntColumn get longBreakMinutes => integer()();
  // Completed work blocks within this session run.
  IntColumn get completedWorkSessions => integer().withDefault(const Constant(0))();
  IntColumn get totalFocusMinutes => integer().withDefault(const Constant(0))();
  // Date-only value (midnight local time).
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class PomodoroPresets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get workMinutes => integer()();
  IntColumn get shortBreakMinutes => integer()();
  IntColumn get longBreakMinutes => integer()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

// ---------------------------------------------------------------------------
// Screen time module
// ---------------------------------------------------------------------------

class ScreenTimeRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Date-only value (midnight local time).
  DateTimeColumn get date => dateTime()();
  IntColumn get totalMinutes => integer().withDefault(const Constant(0))();
  IntColumn get productiveMinutes => integer().withDefault(const Constant(0))();
  IntColumn get distractionMinutes => integer().withDefault(const Constant(0))();
  IntColumn get dailyLimitMinutes => integer().withDefault(const Constant(180))();
  // Per-app usage as JSON: {"com.example.app": {"minutes": 42, "category": "distraction"}}
  TextColumn get appUsageJson => text().withDefault(const Constant('{}'))();
}

class ScreenTimeApps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text()();
  TextColumn get appName => text()();
  // productive | distraction | neutral. Manual choice always wins.
  TextColumn get category => text().withDefault(const Constant('neutral'))();
  BoolColumn get categoryManual => boolean().withDefault(const Constant(false))();
  IntColumn get dailyLimitMinutes => integer().nullable()();
  BoolColumn get isBlocked => boolean().withDefault(const Constant(false))();
}

// ---------------------------------------------------------------------------
// Scoring
// ---------------------------------------------------------------------------

class DailyScores extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Date-only value (midnight local time).
  DateTimeColumn get date => dateTime()();
  IntColumn get todoScore => integer().withDefault(const Constant(0))();
  IntColumn get prayerScore => integer().withDefault(const Constant(0))();
  IntColumn get waterScore => integer().withDefault(const Constant(0))();
  IntColumn get screenTimeScore => integer().withDefault(const Constant(0))();
  // Focus XP from completed pomodoro sessions (displayed separately,
  // excluded from the overall weighted score).
  IntColumn get pomodoroPoints => integer().withDefault(const Constant(0))();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [
    Todos,
    TodoTrash,
    PrayerRecords,
    PrayerSettings,
    WaterRecords,
    PomodoroSessions,
    PomodoroPresets,
    ScreenTimeRecords,
    ScreenTimeApps,
    DailyScores,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pd.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
