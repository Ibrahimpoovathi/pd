import 'package:flutter/services.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:vibration/vibration.dart';

/// Haptic feedback for Pomodoro events (Stillness-inspired).
///
/// Patterns (Android VibrationEffect waveform, ms):
/// - Focus complete: [0, 22, 60, 22] — strong double-tap
/// - Break complete: [0, 18] — single tap
/// - Start/pause/skip: [0, 12] — light tick
class PomodoroHaptics {
  /// Vibrate for a completed phase.
  static Future<void> onPhaseComplete(PomodoroPhase phase) async {
    if (phase == PomodoroPhase.work) {
      // Focus session done - distinctive double-tap.
      await vibrate([0, 22, 60, 22]);
    } else {
      // Break done - single tap.
      await vibrate([0, 18]);
    }
  }

  /// Light tick for start/pause/skip/reset actions.
  static Future<void> onAction() async {
    await vibrate([0, 12]);
  }

  static Future<void> vibrate(List<int> pattern) async {
    try {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (!hasVibrator) {
        // Fall back to platform haptics.
        await HapticFeedback.lightImpact();
        return;
      }
      await Vibration.vibrate(pattern: pattern, intensities: _intensities(pattern.length));
    } catch (_) {
      // Silently ignore - haptics must never crash the timer.
      try {
        await HapticFeedback.lightImpact();
      } catch (_) {}
    }
  }

  /// Default amplitude ramp: alternate strong/pause.
  static List<int> _intensities(int length) {
    // 128 = default amplitude, 0 = pause.
    return List<int>.generate(length, (i) => i.isEven ? 0 : 200);
  }
}
