import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/features/pomodoro/data/pomodoro_haptics.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';

/// Timer controls: reset / play-pause / skip (Stillness-inspired).
/// Colors follow the app [ThemeData].
class ControlsRow extends ConsumerWidget {
  const ControlsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pomodoroControllerProvider);
    final state = controller.currentState;
    final isRunning = state.isRunning;
    final isIdle = !isRunning && state.elapsedSeconds == 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundButton(
          glyph: '↺',
          dimmed: isIdle,
          onTap: isIdle
              ? null
              : () {
                  controller.reset();
                  PomodoroHaptics.onAction();
                },
        ),
        const SizedBox(width: 28),
        _PlayButton(
          isRunning: isRunning,
          onTap: () {
            if (isRunning) {
              controller.pause();
            } else {
              controller.start();
            }
          },
        ),
        const SizedBox(width: 28),
        _RoundButton(
          glyph: '⏭',
          dimmed: false,
          onTap: () {
            controller.skip();
            PomodoroHaptics.onAction();
          },
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final String glyph;
  final bool dimmed;
  final VoidCallback? onTap;

  const _RoundButton({required this.glyph, required this.dimmed, this.onTap});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onSurface.withValues(alpha: 0.04),
        ),
        alignment: Alignment.center,
        child: Text(
          glyph,
          style: TextStyle(
            color: dimmed
                ? onSurface.withValues(alpha: 0.25)
                : onSurface.withValues(alpha: 0.65),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onTap;

  const _PlayButton({required this.isRunning, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.onSurface.withValues(alpha: 0.06),
          border:
              Border.all(color: scheme.onSurface.withValues(alpha: 0.15)),
        ),
        alignment: Alignment.center,
        child: isRunning
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: scheme.onSurface,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: scheme.onSurface,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              )
            : Text('▶',
                style: TextStyle(color: scheme.onSurface, fontSize: 14)),
      ),
    );
  }
}
