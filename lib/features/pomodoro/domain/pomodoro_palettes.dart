import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';

/// Muted low-chroma palettes ported from Stillness (oklch approximated to sRGB).
/// 3 palettes per phase: Focus (Ember/Rose/Forest),
/// Short break (Teal/Mint/Sky), Long break (Periwinkle/Dusk/Ocean).
class PomodoroPalettes {
  const PomodoroPalettes._();

  static const focusEmber = Palette(
    id: 'ember',
    label: 'Ember',
    swatch: '#8A6B5A',
    stops: [
      ColorStop(0, 0.54, 0.05, 64),
      ColorStop(0.45, 0.49, 0.06, 46),
      ColorStop(1, 0.42, 0.07, 28),
    ],
  );
  static const focusRose = Palette(
    id: 'rose',
    label: 'Rose',
    swatch: '#8A5A64',
    stops: [
      ColorStop(0, 0.54, 0.04, 18),
      ColorStop(0.5, 0.49, 0.06, 8),
      ColorStop(1, 0.43, 0.07, 352),
    ],
  );
  static const focusForest = Palette(
    id: 'forest',
    label: 'Forest',
    swatch: '#5A7A6A',
    stops: [
      ColorStop(0, 0.52, 0.04, 150),
      ColorStop(0.5, 0.47, 0.05, 138),
      ColorStop(1, 0.41, 0.05, 125),
    ],
  );

  static const shortTeal = Palette(
    id: 'teal',
    label: 'Teal',
    swatch: '#5A7A7A',
    stops: [
      ColorStop(0, 0.49, 0.03, 178),
      ColorStop(1, 0.56, 0.03, 192),
    ],
  );
  static const shortMint = Palette(
    id: 'mint',
    label: 'Mint',
    swatch: '#5A8A7A',
    stops: [
      ColorStop(0, 0.50, 0.03, 162),
      ColorStop(1, 0.57, 0.03, 148),
    ],
  );
  static const shortSky = Palette(
    id: 'sky',
    label: 'Sky',
    swatch: '#5A7A8A',
    stops: [
      ColorStop(0, 0.50, 0.03, 225),
      ColorStop(1, 0.57, 0.03, 210),
    ],
  );

  static const longPeriwinkle = Palette(
    id: 'periwinkle',
    label: 'Periwinkle',
    swatch: '#6A6A8A',
    stops: [
      ColorStop(0, 0.47, 0.03, 218),
      ColorStop(1, 0.54, 0.025, 238),
    ],
  );
  static const longDusk = Palette(
    id: 'dusk',
    label: 'Dusk',
    swatch: '#7A6A7A',
    stops: [
      ColorStop(0, 0.45, 0.04, 290),
      ColorStop(1, 0.52, 0.035, 270),
    ],
  );
  static const longOcean = Palette(
    id: 'ocean',
    label: 'Ocean',
    swatch: '#5A6A7A',
    stops: [
      ColorStop(0, 0.43, 0.04, 215),
      ColorStop(1, 0.52, 0.035, 200),
    ],
  );
}

/// Lookup tables per phase.
class PomodoroPaletteSets {
  static const Map<PomodoroPhase, List<Palette>> all = {
    PomodoroPhase.work: [
      PomodoroPalettes.focusEmber,
      PomodoroPalettes.focusRose,
      PomodoroPalettes.focusForest,
    ],
    PomodoroPhase.shortBreak: [
      PomodoroPalettes.shortTeal,
      PomodoroPalettes.shortMint,
      PomodoroPalettes.shortSky,
    ],
    PomodoroPhase.longBreak: [
      PomodoroPalettes.longPeriwinkle,
      PomodoroPalettes.longDusk,
      PomodoroPalettes.longOcean,
    ],
    // paused/completed fall back to work palettes
    PomodoroPhase.paused: [
      PomodoroPalettes.focusEmber,
      PomodoroPalettes.focusRose,
      PomodoroPalettes.focusForest,
    ],
    PomodoroPhase.completed: [
      PomodoroPalettes.focusEmber,
      PomodoroPalettes.focusRose,
      PomodoroPalettes.focusForest,
    ],
  };

  static String defaultIdFor(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return 'ember';
      case PomodoroPhase.shortBreak:
        return 'teal';
      case PomodoroPhase.longBreak:
        return 'periwinkle';
      case PomodoroPhase.paused:
        return 'ember';
      case PomodoroPhase.completed:
        return 'ember';
    }
  }

  static Palette get(PomodoroPhase phase, String? id) {
    final list = all[phase] ?? const [];
    // P1 fix: never throw on empty/missing lists (corrupt persisted
    // journey or future enum value) — fall back to a safe default.
    if (list.isEmpty) return PomodoroPalettes.focusEmber;
    if (id != null) {
      for (final p in list) {
        if (p.id == id) return p;
      }
    }
    final defaultId = defaultIdFor(phase);
    for (final p in list) {
      if (p.id == defaultId) return p;
    }
    return list.first;
  }

  /// Linear interpolate lightness/chroma/hue via stops, then approximate
  /// oklch -> sRGB with a muted HSV-like conversion.
  static Color colorForStops(List<ColorStop> stops, double progress) {
    // P1 fix: empty stops (corrupt data) must not throw inside the painter.
    if (stops.isEmpty) return const Color(0xFFE07A5F);
    if (stops.length == 1) {
      final s = stops.first;
      return _oklchToRgb(s.l, s.c, s.h);
    }
    final p = progress.clamp(0.0, 1.0);
    for (var i = 0; i < stops.length - 1; i++) {
      final a = stops[i];
      final b = stops[i + 1];
      if (p >= a.p && p <= b.p) {
        final denom = (b.p - a.p).clamp(0.001, 1.0);
        final t = (p - a.p) / denom;
        return _oklchToRgb(
          _lerp(a.l, b.l, t),
          _lerp(a.c, b.c, t),
          _lerp(a.h, b.h, t),
        );
      }
    }
    final last = stops.last;
    return _oklchToRgb(last.l, last.c, last.h);
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// Very rough oklch -> rgb: hue wheel approximation, kept muted.
  static Color _oklchToRgb(double l, double c, double h) {
    final hue = ((h % 360) + 360) % 360;
    final sat = (c * 5).clamp(0.0, 1.0) * 0.6 + 0.15;
    final light = l.clamp(0.0, 1.0);
    final h6 = hue / 60;
    final i = h6.toInt() % 6;
    final f = h6 - h6.toInt();
    final base = light;
    late double r, g, b;
    switch (i) {
      case 0:
        r = base;
        g = base * (1 - sat * f);
        b = base * (1 - sat);
        break;
      case 1:
        r = base * (1 - sat * (1 - f));
        g = base;
        b = base * (1 - sat);
        break;
      case 2:
        r = base * (1 - sat);
        g = base;
        b = base * (1 - sat * f);
        break;
      case 3:
        r = base * (1 - sat);
        g = base * (1 - sat * (1 - f));
        b = base;
        break;
      case 4:
        r = base * (1 - sat * f);
        g = base * (1 - sat);
        b = base;
        break;
      default:
        r = base;
        g = base * (1 - sat);
        b = base * (1 - sat * (1 - f));
        break;
    }
    return Color.fromRGBO(
      (r.clamp(0.0, 1.0) * 255).round(),
      (g.clamp(0.0, 1.0) * 255).round(),
      (b.clamp(0.0, 1.0) * 255).round(),
      1.0,
    );
  }
}
