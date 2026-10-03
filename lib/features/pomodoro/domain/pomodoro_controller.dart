import 'dart:async';

import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/features/pomodoro/data/pomodoro_chime_player.dart';
import 'package:pd/features/pomodoro/data/pomodoro_haptics.dart';
import 'package:pd/features/pomodoro/data/pomodoro_notifications.dart';
import 'package:pd/features/pomodoro/data/pomodoro_repository.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pomodoro phase types.
enum PomodoroPhase {
  work,
  shortBreak,
  longBreak,
  paused,
  completed,
}

/// State of the Pomodoro timer.
class PomodoroState {
  final PomodoroPhase phase;
  final int phaseIndex; // 0-based: work=0, shortBreak=1, work=2, shortBreak=3, work=4, shortBreak=5, work=6, longBreak=7
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int totalCycles;
  final int currentCycle; // 1-based: which work session (1 to totalCycles)
  final int elapsedSeconds; // seconds elapsed in current phase
  final int remainingSeconds;
  final bool isRunning;
  final DateTime? phaseStartTime;

  const PomodoroState({
    required this.phase,
    required this.phaseIndex,
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.totalCycles,
    required this.currentCycle,
    required this.elapsedSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    this.phaseStartTime,
  });

  /// Current work session number (1 to totalCycles), only valid during work phase
  int get currentWorkSession => currentCycle;

  /// Total number of phases in a full cycle set: totalCycles work + (totalCycles - 1) short breaks + 1 long break
  int get totalPhases => totalCycles * 2; // work + break alternating, last break is long

  PomodoroState copyWith({
    PomodoroPhase? phase,
    int? phaseIndex,
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? totalCycles,
    int? currentCycle,
    int? elapsedSeconds,
    int? remainingSeconds,
    bool? isRunning,
    DateTime? phaseStartTime,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      phaseIndex: phaseIndex ?? this.phaseIndex,
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      totalCycles: totalCycles ?? this.totalCycles,
      currentCycle: currentCycle ?? this.currentCycle,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      phaseStartTime: phaseStartTime ?? this.phaseStartTime,
    );
  }
}

/// Pomodoro timer controller with wall-clock based timing (Stillness-inspired).
///
/// The UI drives 60fps progress from [liveRemainingMs] using its own Ticker;
/// the controller emits state snapshots on start/pause/tick/phase-change.
class PomodoroController {
  int workMinutes;
  int shortBreakMinutes;
  int longBreakMinutes;
  int totalCycles;
  bool chimeEnabled = true;
  bool vibrationEnabled = true;

  // Stillness-inspired settings
  ChimeTone chimeTone = ChimeTone.warm;
  bool autoStartBreaks = false;
  bool autoStartFocus = false;
  bool keepScreenOnEnabled = true;
  AmbientMode ambientMode = AmbientMode.off;
  double ambientVolume = 0.5;
  double ambientRainMix = 0.5;
  Map<PomodoroPhase, String> colorJourneys = {};
  String? currentTaskId;
  String? currentTaskLabel;
  String? currentIntention;

  final PomodoroRepository _repository;
  final SharedPreferences _prefs;
  final PomodoroNotifications _notifications;
  final PomodoroChimePlayer _chimePlayer = PomodoroChimePlayer();
  Timer? _timer;
  PomodoroState _state;
  final StreamController<PomodoroState> _stateController =
      StreamController<PomodoroState>.broadcast();

  /// Stream of state updates.
  Stream<PomodoroState> get stateStream => _stateController.stream;

  /// Alias for stateStream for compatibility.
  Stream<PomodoroState> get stream => stateStream;

  /// Current state snapshot.
  PomodoroState get currentState => _state;

  PomodoroController({
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    this.totalCycles = 4,
    required PomodoroRepository repository,
    required SharedPreferences prefs,
    required NotificationService notificationService,
  }) : _repository = repository,
       _prefs = prefs,
       _notifications = PomodoroNotifications(notificationService),
       _state = PomodoroState(
    phase: PomodoroPhase.work,
    phaseIndex: 0,
    workMinutes: workMinutes,
    shortBreakMinutes: shortBreakMinutes,
    longBreakMinutes: longBreakMinutes,
    totalCycles: totalCycles,
    currentCycle: 1,
    elapsedSeconds: 0,
    remainingSeconds: workMinutes * 60,
    isRunning: false,
  ) {
    _loadSettings();
  }

  /// Creates controller from preset durations.
  factory PomodoroController.fromPreset({
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    int totalCycles = 4,
    required PomodoroRepository repository,
    required SharedPreferences prefs,
    required NotificationService notificationService,
  }) {
    return PomodoroController(
      workMinutes: workMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      totalCycles: totalCycles,
      repository: repository,
      prefs: prefs,
      notificationService: notificationService,
    );
  }

  /// Whether the screen should be kept awake (running or paused, not idle).
  bool get keepScreenOn => keepScreenOnEnabled && _state.isRunning;

  /// Live remaining milliseconds computed from wall-clock (for 60fps UI).
  /// The UI calls this every frame via its own Ticker instead of relying
  /// on 1s timer ticks.
  int liveRemainingMs() {
    if (_state.isRunning && _state.phaseStartTime != null) {
      final elapsed = DateTime.now()
          .difference(_state.phaseStartTime!)
          .inMilliseconds;
      final total = _phaseDuration(_state.phase) * 1000;
      return (total - elapsed).clamp(0, total);
    }
    return _state.remainingSeconds * 1000;
  }

  /// Live progress 0..1 computed from wall-clock.
  double liveProgress() {
    final total = _phaseDuration(_state.phase) * 1000;
    if (total <= 0) return 0;
    final rem = liveRemainingMs();
    return ((total - rem) / total).clamp(0.0, 1.0);
  }

  Future<void> _loadSettings() async {
    workMinutes = _prefs.getInt('pomodoro_work_minutes') ?? workMinutes;
    shortBreakMinutes = _prefs.getInt('pomodoro_short_break_minutes') ?? shortBreakMinutes;
    longBreakMinutes = _prefs.getInt('pomodoro_long_break_minutes') ?? longBreakMinutes;
    totalCycles = _prefs.getInt('pomodoro_total_cycles') ?? totalCycles;
    chimeEnabled = _prefs.getBool('pomodoro_chime_enabled') ?? true;
    vibrationEnabled = _prefs.getBool('pomodoro_vibration_enabled') ?? true;
    final toneName = _prefs.getString('pomodoro_chime_tone') ?? 'warm';
    chimeTone = ChimeTone.values.firstWhere(
      (t) => t.name == toneName,
      orElse: () => ChimeTone.warm,
    );
    autoStartBreaks = _prefs.getBool('pomodoro_auto_start_breaks') ?? false;
    autoStartFocus = _prefs.getBool('pomodoro_auto_start_focus') ?? false;
    keepScreenOnEnabled = _prefs.getBool('pomodoro_keep_screen_on') ?? true;
    final ambientName = _prefs.getString('pomodoro_ambient_mode') ?? 'off';
    ambientMode = AmbientMode.values.firstWhere(
      (m) => m.name == ambientName,
      orElse: () => AmbientMode.off,
    );
    ambientVolume = _prefs.getDouble('pomodoro_ambient_volume') ?? 0.5;
    ambientRainMix = _prefs.getDouble('pomodoro_ambient_rain_mix') ?? 0.5;
    final journeysRaw = _prefs.getString('pomodoro_color_journeys') ?? '';
    if (journeysRaw.isNotEmpty) {
      for (final part in journeysRaw.split(',')) {
        final kv = part.split(':');
        if (kv.length == 2) {
          try {
            final phase = PomodoroPhase.values.byName(kv[0]);
            colorJourneys[phase] = kv[1];
          } catch (_) {}
        }
      }
    }
    currentTaskId = _prefs.getString('pomodoro_current_task_id');
    if (currentTaskId?.isEmpty == true) currentTaskId = null;
    currentTaskLabel = _prefs.getString('pomodoro_current_task_label');
    if (currentTaskLabel?.isEmpty == true) currentTaskLabel = null;

    _state = _state.copyWith(
      workMinutes: workMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      totalCycles: totalCycles,
      remainingSeconds: workMinutes * 60,
    );
    _stateController.add(_state);
  }

  Future<void> _saveSettings() async {
    await _prefs.setInt('pomodoro_work_minutes', workMinutes);
    await _prefs.setInt('pomodoro_short_break_minutes', shortBreakMinutes);
    await _prefs.setInt('pomodoro_long_break_minutes', longBreakMinutes);
    await _prefs.setInt('pomodoro_total_cycles', totalCycles);
    await _prefs.setBool('pomodoro_chime_enabled', chimeEnabled);
    await _prefs.setBool('pomodoro_vibration_enabled', vibrationEnabled);
    await _prefs.setString('pomodoro_chime_tone', chimeTone.name);
    await _prefs.setBool('pomodoro_auto_start_breaks', autoStartBreaks);
    await _prefs.setBool('pomodoro_auto_start_focus', autoStartFocus);
    await _prefs.setBool('pomodoro_keep_screen_on', keepScreenOnEnabled);
    await _prefs.setString('pomodoro_ambient_mode', ambientMode.name);
    await _prefs.setDouble('pomodoro_ambient_volume', ambientVolume);
    await _prefs.setDouble('pomodoro_ambient_rain_mix', ambientRainMix);
  }

  /// Start the timer.
  void start() {
    if (_state.isRunning) return;

    final now = DateTime.now();
    _state = _state.copyWith(
      isRunning: true,
      phaseStartTime: now.subtract(Duration(seconds: _state.elapsedSeconds)),
    );
    _stateController.add(_state);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    playStartTick();
  }

  /// Pause the timer.
  void pause() {
    if (!_state.isRunning) return;
    _timer?.cancel();
    _timer = null;
    final elapsed = DateTime.now().difference(_state.phaseStartTime!).inSeconds;
    _state = _state.copyWith(
      isRunning: false,
      elapsedSeconds: elapsed,
    );
    _stateController.add(_state);
    playStartTick();
  }

  /// Toggle play/pause.
  void toggle() {
    if (_state.isRunning) {
      pause();
    } else {
      start();
    }
  }

  /// Reset to initial state.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _state = PomodoroState(
      phase: PomodoroPhase.work,
      phaseIndex: 0,
      workMinutes: workMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      totalCycles: totalCycles,
      currentCycle: 1,
      elapsedSeconds: 0,
      remainingSeconds: workMinutes * 60,
      isRunning: false,
    );
    _stateController.add(_state);
  }

  /// Skip to next phase.
  void skip() {
    _advancePhase();
  }

  /// Jump directly to a phase (Stillness: phase pills). Resets to idle.
  void setPhase(PomodoroPhase phase) {
    if (_state.isRunning) return;
    _timer?.cancel();
    _timer = null;
    final total = _phaseDuration(phase);
    _state = PomodoroState(
      phase: phase,
      phaseIndex: _state.phaseIndex,
      workMinutes: workMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      totalCycles: totalCycles,
      currentCycle: phase == PomodoroPhase.work ? 1 : _state.currentCycle,
      elapsedSeconds: 0,
      remainingSeconds: total,
      isRunning: false,
    );
    _stateController.add(_state);
  }

  void _tick(Timer timer) {
    if (!_state.isRunning) return;

    final now = DateTime.now();
    final elapsed = now.difference(_state.phaseStartTime!).inSeconds;
    final totalDuration = _phaseDuration(_state.phase);
    final remaining = (totalDuration - elapsed).clamp(0, totalDuration);

    if (remaining <= 0) {
      _advancePhase();
    } else {
      _state = _state.copyWith(
        elapsedSeconds: elapsed,
        remainingSeconds: remaining,
      );
      _stateController.add(_state);
    }
  }

  int _phaseDuration(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return workMinutes * 60;
      case PomodoroPhase.shortBreak:
        return shortBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return longBreakMinutes * 60;
      default:
        return 0;
    }
  }

  void _advancePhase() {
    _timer?.cancel();
    _timer = null;

    final completedWork = _state.phase == PomodoroPhase.work;

    PomodoroPhase nextPhase;
    int nextPhaseIndex = _state.phaseIndex + 1;
    int nextCycle = _state.currentCycle;

    if (_state.phase == PomodoroPhase.work) {
      // Completed a work session - persist to database
      _persistWorkSession();
      
      if (_state.currentCycle < totalCycles) {
        // More work sessions to go -> short break
        nextPhase = PomodoroPhase.shortBreak;
      } else {
        // All work sessions done -> long break
        nextPhase = PomodoroPhase.longBreak;
      }
    } else if (_state.phase == PomodoroPhase.shortBreak) {
      // Short break done -> next work session
      nextPhase = PomodoroPhase.work;
      nextCycle = _state.currentCycle + 1;
    } else if (_state.phase == PomodoroPhase.longBreak) {
      // Long break done -> full cycle set complete, start over
      _persistCycleSetComplete();
      nextPhase = PomodoroPhase.work;
      nextCycle = 1;
      nextPhaseIndex = 0; // Reset phase index for new cycle set
    } else {
      nextPhase = PomodoroPhase.completed;
    }

    if (nextPhase == PomodoroPhase.completed) {
      _state = _state.copyWith(
        phase: PomodoroPhase.completed,
        isRunning: false,
        elapsedSeconds: 0,
        remainingSeconds: 0,
      );
      _stateController.add(_state);
      return;
    }

    int nextRemaining = 0;

    if (nextPhase == PomodoroPhase.work) {
      nextRemaining = workMinutes * 60;
    } else if (nextPhase == PomodoroPhase.shortBreak) {
      nextRemaining = shortBreakMinutes * 60;
    } else if (nextPhase == PomodoroPhase.longBreak) {
      nextRemaining = longBreakMinutes * 60;
    }

    // Auto-start policy (Stillness): only keep running when the
    // corresponding auto-start toggle is on; otherwise go idle.
    final shouldAutoStart = nextPhase == PomodoroPhase.work
        ? autoStartFocus
        : autoStartBreaks;

    final previousPhase = _state.phase;
    _state = PomodoroState(
      phase: nextPhase,
      phaseIndex: nextPhaseIndex,
      workMinutes: workMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      totalCycles: totalCycles,
      currentCycle: nextCycle,
      elapsedSeconds: 0,
      remainingSeconds: nextRemaining,
      isRunning: shouldAutoStart,
      phaseStartTime: shouldAutoStart ? DateTime.now() : null,
    );
    _stateController.add(_state);

    if (previousPhase != nextPhase) {
      _notifyPhaseChange(nextPhase);
    }

    if (shouldAutoStart) {
      _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    }
  }

  Future<void> _persistWorkSession() async {
    try {
      final today = await _repository.getOrCreateToday();
      final newCompletedWork = (today.completedWorkSessions ?? 0) + 1;
      final newTotalFocus = (today.totalFocusMinutes ?? 0) + workMinutes;
      
      await _repository.updateSession(
        id: today.id,
        completedWorkSessions: newCompletedWork,
        totalFocusMinutes: newTotalFocus,
      );
    } catch (e) {
      // Silently fail - don't crash the timer
    }
  }

  Future<void> _persistCycleSetComplete() async {
    try {
      final today = await _repository.getOrCreateToday();
      // Cycle set completion is tracked via the work sessions and focus minutes
      // which are already updated per work session
    } catch (e) {
      // Silently fail
    }
  }

  void _notifyPhaseChange(PomodoroPhase phase) {
    final remainingSeconds = _phaseDuration(phase);

    // Play chime if enabled (Stillness: distinct session-end tone).
    if (chimeEnabled) {
      _chimePlayer.play(chimeTone, phase);
    }
    // Vibrate with phase-specific pattern if enabled.
    if (vibrationEnabled) {
      PomodoroHaptics.onPhaseComplete(phase);
    }
    // Show notification
    _notifications.showPhaseChange(
      phase: phase,
      remainingSeconds: remainingSeconds,
    );
  }


  /// Update timer settings and reset to initial state with new values.
  void updateSettings({
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    required int totalCycles,
  }) {
    _timer?.cancel();
    _timer = null;
    this.workMinutes = workMinutes;
    this.shortBreakMinutes = shortBreakMinutes;
    this.longBreakMinutes = longBreakMinutes;
    this.totalCycles = totalCycles;
    _state = PomodoroState(
      phase: PomodoroPhase.work,
      phaseIndex: 0,
      workMinutes: workMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      totalCycles: totalCycles,
      currentCycle: 1,
      elapsedSeconds: 0,
      remainingSeconds: workMinutes * 60,
      isRunning: false,
    );
    _stateController.add(_state);
    _saveSettings();
  }

  void updateChimeEnabled(bool enabled) {
    chimeEnabled = enabled;
    _saveSettings();
  }

  void updateChimeTone(ChimeTone tone) {
    chimeTone = tone;
    _saveSettings();
  }

  void updateVibrationEnabled(bool enabled) {
    vibrationEnabled = enabled;
    _saveSettings();
  }

  void updateAutoStart({bool? breaks, bool? focus}) {
    if (breaks != null) autoStartBreaks = breaks;
    if (focus != null) autoStartFocus = focus;
    _saveSettings();
  }

  void updateKeepScreenOnEnabled(bool enabled) {
    keepScreenOnEnabled = enabled;
    _saveSettings();
    _stateController.add(_state);
  }

  void updateAmbient({AmbientMode? mode, double? volume, double? rainMix}) {
    if (mode != null) ambientMode = mode;
    if (volume != null) ambientVolume = volume.clamp(0.0, 1.0);
    if (rainMix != null) ambientRainMix = rainMix.clamp(0.0, 1.0);
    _saveSettings();
  }

  void updateColorJourney(PomodoroPhase phase, String? paletteId) {
    if (paletteId == null) {
      colorJourneys.remove(phase);
    } else {
      colorJourneys = {...colorJourneys, phase: paletteId};
    }
    _prefs.setString(
      'pomodoro_color_journeys',
      colorJourneys.entries.map((e) => '${e.key.name}:${e.value}').join(','),
    );
  }

  void setCurrentTask({String? id, String? label}) {
    currentTaskId = id;
    currentTaskLabel = label?.trim().isEmpty == true ? null : label?.trim();
    _prefs.setString('pomodoro_current_task_id', currentTaskId ?? '');
    _prefs.setString('pomodoro_current_task_label', currentTaskLabel ?? '');
  }

  void clearCurrentTask() => setCurrentTask();

  void setIntention(String? text) {
    final trimmed = text?.trim().take(24) ?? '';
    currentIntention = trimmed.isEmpty ? null : trimmed;
  }

  void playStartTick() {
    if (chimeEnabled) _chimePlayer.playStart(chimeTone);
    if (vibrationEnabled) PomodoroHaptics.onAction();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _stateController.close();
    _chimePlayer.dispose();
  }
}

extension _TakeString on String {
  String take(int n) => length <= n ? this : substring(0, n);
}
