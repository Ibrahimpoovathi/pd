/// Pomodoro settings data class.
class PomodoroSettings {
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int totalCycles;

  const PomodoroSettings({
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.totalCycles,
  });

  PomodoroSettings copyWith({
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? totalCycles,
  }) {
    return PomodoroSettings(
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      totalCycles: totalCycles ?? this.totalCycles,
    );
  }
}

/// Ambient sound modes (Stillness-inspired).
enum AmbientMode { off, brown, rain, mix }

/// Chime tones for phase transitions.
enum ChimeTone { warm, glass, wood, bowl }

/// Theme variants for the Pomodoro experience.
enum ThemeVariant { warmNight, coolNight, pureDark }

/// OKLCH color stop for palette interpolation.
class ColorStop {
  final double p; // progress 0..1
  final double l; // lightness
  final double c; // chroma
  final double h; // hue

  const ColorStop(this.p, this.l, this.c, this.h);
}

/// Named palette with OKLCH stops.
class Palette {
  final String id;
  final String label;
  final String swatch;
  final List<ColorStop> stops;

  const Palette({
    required this.id,
    required this.label,
    required this.swatch,
    required this.stops,
  });
}

/// Ambient sound preset (saved mix + volume).
class AmbientPreset {
  final String id;
  final String name;
  final double rainMix;
  final double volume;

  const AmbientPreset({
    required this.id,
    required this.name,
    required this.rainMix,
    required this.volume,
  });
}

/// Parameters for the ambient sound engine.
class AmbientParams {
  final AmbientMode mode;
  final double volume; // 0.0 - 1.0
  final double rainMix; // 0.0 - 1.0 (brown <-> rain)

  const AmbientParams({
    this.mode = AmbientMode.off,
    this.volume = 0.5,
    this.rainMix = 0.5,
  });

  AmbientParams copyWith({
    AmbientMode? mode,
    double? volume,
    double? rainMix,
  }) {
    return AmbientParams(
      mode: mode ?? this.mode,
      volume: volume ?? this.volume,
      rainMix: rainMix ?? this.rainMix,
    );
  }
}

/// Task entry linked to a To-Do item (Pomodoro focus history).
class PomodoroTaskEntry {
  final String id;
  final String label;
  final int count;
  final int lastUsed; // epoch millis
  final List<int> sessions; // epoch millis list, max 100
  final bool pinned;
  final int? pinOrder;
  final double? color; // HSV hue or null

  const PomodoroTaskEntry({
    required this.id,
    required this.label,
    this.count = 0,
    required this.lastUsed,
    this.sessions = const [],
    this.pinned = false,
    this.pinOrder,
    this.color,
  });
}

/// Daily focus history entry.
class PomodoroHistoryEntry {
  final String date; // YYYY-MM-DD
  final int count;

  const PomodoroHistoryEntry({required this.date, required this.count});
}