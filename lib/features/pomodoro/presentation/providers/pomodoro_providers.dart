import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/features/pomodoro/data/pomodoro_ambient_engine.dart';
import 'package:pd/features/pomodoro/data/pomodoro_repository.dart';
import 'package:pd/features/todo/data/todo_repository.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';
import 'package:pd/features/scoring/presentation/providers/score_providers.dart';

final pomodoroRepositoryProvider = Provider<PomodoroRepository>(
  (ref) => PomodoroRepository(ref.watch(databaseProvider)),
);

/// PomodoroController with default preset settings.
final pomodoroControllerProvider = Provider<PomodoroController>((ref) {
  return PomodoroController.fromPreset(
    workMinutes: 25,
    shortBreakMinutes: 5,
    longBreakMinutes: 15,
    totalCycles: 4,
    repository: ref.watch(pomodoroRepositoryProvider),
    prefs: ref.watch(prefsProvider),
    notificationService: ref.watch(notificationServiceProvider),
  );
});

/// Stream of PomodoroState from the controller.
final pomodoroStateStreamProvider = StreamProvider<PomodoroState>((ref) {
  final controller = ref.watch(pomodoroControllerProvider);
  return controller.stream;
});

/// Provides the Pomodoro settings (work/break durations, cycles).
/// For now, returns defaults. In the future, this could be stored in prefs.
final pomodoroSettingsProvider = Provider<PomodoroSettings>((ref) {
  return const PomodoroSettings(
    workMinutes: 25,
    shortBreakMinutes: 5,
    longBreakMinutes: 15,
    totalCycles: 4,
  );
});

/// Consecutive days with at least one completed work session.
final pomodoroStreakProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(pomodoroRepositoryProvider);
  return repo.focusStreak();
});

/// Total focus minutes across all time.
final totalFocusMinutesProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(pomodoroRepositoryProvider);
  return repo.totalFocusMinutes();
});

/// Total completed work sessions across all time.
final completedSessionsProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(pomodoroRepositoryProvider);
  return repo.completedSessions();
});

/// Recomputed prayer-section score for an arbitrary [date].
final historyDayScoreProvider = FutureProvider.family<int, DateTime>((ref, date) async {
  return ref.watch(scoreServiceProvider).prayerScoreOn(date);
});

/// Records of one calendar month ([month] = any day within it).
final monthRecordsProvider = FutureProvider.family<List<PomodoroSession>, DateTime>((ref, month) async {
  final repo = ref.watch(pomodoroRepositoryProvider);
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1, 0);
  return repo.getSessionsBetween(start, end);
});

/// Recomputes the whole prayer section for [date] from its record.
/// Idempotent: call after every prayer/ibadah toggle.
final recordPrayerDayProvider = FutureProvider.family<void, DateTime>((ref, date) async {
  final repo = ref.watch(pomodoroRepositoryProvider);
  await repo.getOrCreateToday(date);
});

/// All pomodoro presets from the repository.
final pomodoroPresetsProvider = FutureProvider<List<PomodoroPreset>>((ref) async {
  final repo = ref.watch(pomodoroRepositoryProvider);
  return repo.getAllPresets();
});

/// Current PomodoroState (synchronous access to controller state).
final pomodoroStateProvider = Provider<PomodoroState>((ref) {
  final controller = ref.watch(pomodoroControllerProvider);
  return controller.currentState;
});

/// Shared ambient sound engine (PCM, isolate-backed).
/// Kept alive for the app lifetime; disposed never (singleton per scope).
final pomodoroAmbientEngineProvider = Provider<AmbientEngine>((ref) {
  final engine = AmbientEngine();
  ref.onDispose(() => engine.dispose());
  return engine;
});

/// Current ambient params snapshot from the controller.
final pomodoroAmbientParamsProvider = Provider<AmbientParams>((ref) {
  final controller = ref.watch(pomodoroControllerProvider);
  return AmbientParams(
    mode: controller.ambientMode,
    volume: controller.ambientVolume,
    rainMix: controller.ambientRainMix,
  );
});

/// Incomplete, non-trashed To-Dos for the Pomodoro task picker.
final pomodoroTodoPickerProvider =
    FutureProvider<List<Todo>>((ref) async {
  final db = ref.watch(databaseProvider);
  return TodoRepository(db).getTasksForPomodoroPicker();
});
