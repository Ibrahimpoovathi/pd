import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_palettes.dart';

/// Dynamic focus orb with per-status breathe cycle, glow pulse, drift,
/// progress ring and phase-change flash (Stillness-inspired).
///
/// - Breathe: running 12s/0.012, paused 19s/0.005, idle 26s/0.003
/// - Glow: running 0.40+0.08, paused 0.22+0.03, idle 0.16+0.02
/// - Drift: 2dp Lissajous (60s/73s)
/// - Flash: 1.4s white ring on [flashTick] change
class FocusOrb extends StatefulWidget {
  final double progress; // 0..1 (driven per-frame from outside)
  final PomodoroPhase phase;
  final bool isRunning;
  final Palette palette;
  final int flashTick;
  final double size;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FocusOrb({
    super.key,
    required this.progress,
    required this.phase,
    required this.isRunning,
    required this.palette,
    this.flashTick = 0,
    this.size = 300,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<FocusOrb> createState() => _FocusOrbState();
}

class _FocusOrbState extends State<FocusOrb> with TickerProviderStateMixin {
  late final AnimationController _breathe;
  late final AnimationController _driftX;
  late final AnimationController _driftY;
  bool _flashVisible = false;
  int _lastFlashTick = 0;

  @override
  void initState() {
    super.initState();
    // P0 fix: AnimationController.repeat() requires a non-null duration.
    // Initialize with the correct duration for the current status upfront.
    _breathe = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _breatheMs()),
    )..repeat();
    _driftX = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat(reverse: true);
    _driftY = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 73),
    )..repeat(reverse: true);
    _lastFlashTick = widget.flashTick;
    _syncBreatheDuration();
  }

  @override
  void didUpdateWidget(FocusOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncBreatheDuration();
    if (widget.flashTick != _lastFlashTick && widget.flashTick > 0) {
      _lastFlashTick = widget.flashTick;
      _showFlash();
    }
  }

  static int _breatheMsFor(bool isRunning, PomodoroPhase phase) {
    if (isRunning) return 12000;
    if (phase == PomodoroPhase.paused) return 19000;
    return 26000;
  }

  int _breatheMs() => _breatheMsFor(widget.isRunning, widget.phase);

  void _syncBreatheDuration() {
    final ms = _breatheMs();
    if (_breathe.duration?.inMilliseconds != ms) {
      final value = _breathe.value;
      _breathe.duration = Duration(milliseconds: ms);
      _breathe.value = value;
    }
  }

  Future<void> _showFlash() async {
    if (!mounted) return;
    setState(() => _flashVisible = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) setState(() => _flashVisible = false);
  }

  @override
  void dispose() {
    _breathe.dispose();
    _driftX.dispose();
    _driftY.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.progress.clamp(0.0, 1.0);
    final orbColor = PomodoroPaletteSets.colorForStops(widget.palette.stops, p);
    final bodySize = widget.size * 0.746;
    final ringSize = widget.size * 0.88;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathe, _driftX, _driftY]),
        builder: (context, _) {
          final breathePhase = _breathe.value;
          final amp = widget.isRunning
              ? 0.012
              : (widget.phase == PomodoroPhase.paused ? 0.005 : 0.003);
          final glowAmp = widget.isRunning
              ? 0.08
              : (widget.phase == PomodoroPhase.paused ? 0.03 : 0.02);
          final baseGlow = widget.isRunning
              ? 0.40
              : (widget.phase == PomodoroPhase.paused ? 0.22 : 0.16);

          final breathe =
              1.0 + math.sin(breathePhase * 2 * math.pi) * amp;
          final glowPulse = baseGlow +
              math.sin(breathePhase * 2 * math.pi) * glowAmp;
          final driftX = (_driftX.value * 2 - 1) * 6.0;
          final driftY = (_driftY.value * 2 - 1) * 6.0;

          final scheme = Theme.of(context).colorScheme;
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _OrbPainter(
                orbColor: orbColor,
                progress: p,
                breathe: breathe,
                glowPulse: glowPulse,
                drift: Offset(driftX, driftY),
                flashVisible: _flashVisible,
                bodySize: bodySize,
                ringSize: ringSize,
                // Theme-derived chrome so the orb reads on light + dark.
                trackColor:
                    scheme.onSurface.withValues(alpha: 0.06),
                highlightColor:
                    scheme.onSurface.withValues(alpha: 0.12),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Paints halo + glow + progress ring + orb body + specular + flash.
class _OrbPainter extends CustomPainter {
  final Color orbColor;
  final double progress;
  final double breathe;
  final double glowPulse;
  final Offset drift;
  final bool flashVisible;
  final double bodySize;
  final double ringSize;
  final Color trackColor;
  final Color highlightColor;

  _OrbPainter({
    required this.orbColor,
    required this.progress,
    required this.breathe,
    required this.glowPulse,
    required this.drift,
    required this.flashVisible,
    required this.bodySize,
    required this.ringSize,
    required this.trackColor,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final drifted = center + drift;

    // Halo
    final haloRadius = size.width / 2 * 0.88 * breathe;
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          orbColor.withValues(alpha: glowPulse * 0.38),
          const Color(0x00000000),
        ],
      ).createShader(Rect.fromCircle(center: drifted, radius: haloRadius * 1.4));
    canvas.drawCircle(drifted, haloRadius * 1.4, haloPaint);

    // Glow
    final glowRadius = size.width / 2 * 0.48 * breathe * 1.05;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          orbColor.withValues(alpha: glowPulse),
          orbColor.withValues(alpha: glowPulse * 0.42),
          const Color(0x00000000),
        ],
      ).createShader(Rect.fromCircle(center: drifted, radius: glowRadius * 1.6));
    canvas.drawCircle(drifted, glowRadius * 1.6, glowPaint);

    // Progress ring track + arc
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: ringSize / 2),
      -math.pi / 2,
      math.pi * 2,
      false,
      ringPaint,
    );
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = orbColor.withValues(alpha: 0.28 + 0.5 * progress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: ringSize / 2),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      arcPaint,
    );

    // Orb body
    final bodyRadius = bodySize / 2 * breathe;
    final bodyRect = Rect.fromCircle(center: center, radius: bodyRadius);
    final bodyPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFF2E8E0),
          Color(0xFFD8BFAE),
          Color(0xFF9A7A68),
        ],
      ).createShader(bodyRect);
    // Tint body with orb color overlay
    final tintedBody = Paint()
      ..shader = RadialGradient(
        colors: [
          orbColor.withValues(alpha: 0.95),
          orbColor.withValues(alpha: 0.70),
          orbColor.withValues(alpha: 0.44),
        ],
        center: const Alignment(0.26, -0.38),
        radius: 1.0,
      ).createShader(bodyRect);
    canvas.drawCircle(center, bodyRadius, bodyPaint);
    canvas.drawCircle(center, bodyRadius, tintedBody);

    // Specular highlight (upper-left)
    canvas.drawCircle(
      Offset(center.dx - bodyRadius * 0.28, center.dy - bodyRadius * 0.38),
      bodyRadius * 0.16,
      Paint()..color = highlightColor,
    );
    // Rim light (lower-right)
    canvas.drawCircle(
      Offset(center.dx + bodyRadius * 0.18, center.dy + bodyRadius * 0.15),
      bodyRadius * 0.07,
      Paint()..color = highlightColor.withValues(alpha: 0.66),
    );

    // Flash ring on phase change
    if (flashVisible) {
      canvas.drawCircle(
        center,
        bodyRadius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = orbColor.withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.orbColor != orbColor ||
        oldDelegate.progress != progress ||
        oldDelegate.breathe != breathe ||
        oldDelegate.glowPulse != glowPulse ||
        oldDelegate.drift != drift ||
        oldDelegate.flashVisible != flashVisible ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.highlightColor != highlightColor;
  }
}
