import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/features/pomodoro/data/pomodoro_repository.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:timezone/timezone.dart' as tz;

/// Pomodoro phase change notifications.
class PomodoroNotifications {
  final NotificationService _service;

  PomodoroNotifications(this._service);

  static int phaseId(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return 8001;
      case PomodoroPhase.shortBreak:
        return 8002;
      case PomodoroPhase.longBreak:
        return 8003;
      case PomodoroPhase.completed:
        return 8004;
      default:
        return 8000;
    }
  }

  /// Show phase change notification immediately.
  Future<void> showPhaseChange({
    required PomodoroPhase phase,
    required int remainingSeconds,
  }) async {
    final id = phaseId(phase);
    String title;
    String body;

    switch (phase) {
      case PomodoroPhase.work:
        title = '🎯 Focus Time';
        body = 'Time to focus for ${remainingSeconds ~/ 60} minutes';
        break;
      case PomodoroPhase.shortBreak:
        title = '☕ Short Break';
        body = 'Take a ${remainingSeconds ~/ 60} minute break';
        break;
      case PomodoroPhase.longBreak:
        title = '🌿 Long Break';
        body = 'Enjoy a ${remainingSeconds ~/ 60} minute long break';
        break;
      case PomodoroPhase.completed:
        title = '✅ Session Complete';
        body = 'Great job! You completed a full cycle';
        break;
      default:
        title = 'Pomodoro';
        body = 'Phase changed';
    }

    final now = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1));
    await _service.scheduleReminder(
      id: id,
      title: title,
      body: body,
      scheduledDate: now,
      channel: NotificationChannels.pomodoro,
      payload: 'pomodoro_phase_${phase.name}',
      exact: false, // Show immediately with inexact scheduling
    );
  }

  /// Re-arm any pending notifications (no-op for pomodoro as they're timer-driven).
  Future<void> reschedule(PomodoroRepository repo) async {
    // Pomodoro phase notifications are triggered by the running timer,
    // not pre-scheduled. This method exists for API compatibility.
  }

  Future<void> cancelAll() async {
    for (var i = 8000; i <= 8004; i++) {
      await _service.cancel(i);
    }
  }
}
