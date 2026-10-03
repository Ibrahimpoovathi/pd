import 'package:audioplayers/audioplayers.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';

/// Asset-based ambient sound engine (Stillness-inspired beds).
///
/// Plays pre-rendered 60s seamless loops via two [AudioPlayer]s:
/// - Brown player: `brown_noise.wav` (leaky-integrator bed)
/// - Rain player: `rain_noise.wav` (band-pass + drop pings)
///
/// Modes:
/// - off: both stopped
/// - brown: brown at full volume
/// - rain: rain at full volume
/// - mix: crossfade via [AmbientParams.rainMix] (0=brown, 1=rain)
///
/// Master [AmbientParams.volume] scales both players.
class AmbientEngine {
  final AudioPlayer _brown = AudioPlayer();
  final AudioPlayer _rain = AudioPlayer();

  bool _initialized = false;
  bool _running = false;
  AmbientParams _params = const AmbientParams();

  bool get isRunning => _running;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    // P1 fix: missing/mis-declared assets must not throw out of the
    // engine — ambient is optional, the timer must keep working.
    try {
      for (final player in [_brown, _rain]) {
        await player.setReleaseMode(ReleaseMode.loop);
      }
      await _brown.setSource(AssetSource('tones/brown_noise.wav'));
      await _rain.setSource(AssetSource('tones/rain_noise.wav'));
      _initialized = true;
    } catch (_) {
      _initialized = false;
      rethrow;
    }
  }

  Future<void> start(AmbientParams params) async {
    // P1 fix: never throw out of the engine (missing assets, platform
    // issues) — ambient is optional, the timer must keep working.
    try {
      await _ensureInit();
    } catch (_) {
      return;
    }
    _params = params;
    if (params.mode == AmbientMode.off) {
      await stop();
      return;
    }
    try {
      await _applyVolumes();
    } catch (_) {}
    // (Re)start both; inaudible one is at volume 0.
    try {
      await _brown.resume();
    } catch (_) {}
    try {
      await _rain.resume();
    } catch (_) {}
    _running = true;
  }

  Future<void> updateParams(AmbientParams params) async {
    _params = params;
    if (!_initialized) return;
    if (params.mode == AmbientMode.off) {
      await stop();
      return;
    }
    if (!_running) {
      await start(params);
      return;
    }
    try {
      await _applyVolumes();
    } catch (_) {}
  }

  Future<void> _applyVolumes() async {
    final v = _params.volume.clamp(0.0, 1.0);
    final mix = _params.rainMix.clamp(0.0, 1.0);
    final (brownV, rainV) = switch (_params.mode) {
      AmbientMode.off => (0.0, 0.0),
      AmbientMode.brown => (v, 0.0),
      AmbientMode.rain => (0.0, v),
      // Mix: equal-power crossfade so total loudness stays constant.
      AmbientMode.mix => (
          v * (1 - mix),
          v * mix,
        ),
    };
    // 100ms fade to avoid clicks (player-level volume ramp).
    await _brown.setVolume(brownV);
    await _rain.setVolume(rainV);
  }

  Future<void> stop() async {
    _running = false;
    try {
      await _brown.pause();
    } catch (_) {}
    try {
      await _rain.pause();
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stop();
    await _brown.dispose();
    await _rain.dispose();
  }
}
