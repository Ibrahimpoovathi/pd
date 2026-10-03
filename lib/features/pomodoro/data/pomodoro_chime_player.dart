import 'package:audioplayers/audioplayers.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';

/// Plays chime tones for Pomodoro phase transitions (Stillness-inspired).
///
/// Uses pre-generated .wav assets played via `audioplayers`:
/// - warm/glass/wood/bowl: session-end chimes
/// - start_tick: short feedback for start/pause/skip
class PomodoroChimePlayer {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _tickPlayer = AudioPlayer();

  bool _disposed = false;

  PomodoroChimePlayer() {
    // Use alarm-like settings for session-end chimes so they are audible.
    _player.setReleaseMode(ReleaseMode.stop);
    _tickPlayer.setReleaseMode(ReleaseMode.stop);
  }

  static String _assetFor(ChimeTone tone) {
    switch (tone) {
      case ChimeTone.warm:
        return 'assets/tones/warm.wav';
      case ChimeTone.glass:
        return 'assets/tones/glass.wav';
      case ChimeTone.wood:
        return 'assets/tones/wood.wav';
      case ChimeTone.bowl:
        return 'assets/tones/bowl.wav';
    }
  }

  /// Plays the session-end chime for [phase] with the given [tone].
  Future<void> play(ChimeTone tone, PomodoroPhase phase) async {
    if (_disposed) return;
    try {
      // Stop any overlapping chime first to avoid pile-up.
      await _player.stop();
      await _player.setVolume(1.0);
      await _player.play(AssetSource(_assetFor(tone).replaceFirst('assets/', '')));
    } catch (_) {
      // Silently ignore audio errors - never crash the timer.
    }
  }

  /// Plays a short tick for start/pause actions (differentiated from end chime).
  Future<void> playStart(ChimeTone tone) async {
    if (_disposed) return;
    try {
      await _tickPlayer.stop();
      await _tickPlayer.setVolume(0.7);
      await _tickPlayer.play(AssetSource('tones/start_tick.wav'));
    } catch (_) {
      // Silently ignore.
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    await _player.dispose();
    await _tickPlayer.dispose();
  }
}
