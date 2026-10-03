import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';

/// Inline duration presets (Stillness-inspired).
/// Only visible in Focus phase when not running.
/// Colors follow the app [ThemeData].
class DurationPresetsRow extends ConsumerWidget {
  const DurationPresetsRow({super.key});

  static const _presets = [
    (10, 'Quick'),
    (25, 'Classic'),
    (50, 'Deep'),
    (90, 'Flow'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pomodoroControllerProvider);
    final state = controller.currentState;
    if (state.phase != PomodoroPhase.work || state.isRunning) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final (minutes, label) in _presets)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _PresetChip(
              label: label,
              minutes: minutes,
              active: state.workMinutes == minutes,
              onTap: () {
                controller.updateSettings(
                  workMinutes: minutes,
                  shortBreakMinutes: state.shortBreakMinutes,
                  longBreakMinutes: state.longBreakMinutes,
                  totalCycles: state.totalCycles,
                );
                controller.reset();
              },
            ),
          ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final int minutes;
  final bool active;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.minutes,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: active
              ? scheme.primary.withValues(alpha: 0.16)
              : onSurface.withValues(alpha: 0.05),
          border: Border.all(
            color: active
                ? scheme.primary.withValues(alpha: 0.3)
                : onSurface.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? onSurface : onSurface.withValues(alpha: 0.7),
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              '${minutes}m',
              style: TextStyle(
                color: active
                    ? scheme.primary
                    : onSurface.withValues(alpha: 0.6),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
