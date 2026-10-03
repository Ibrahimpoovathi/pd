import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';

/// Phase selector pills (Stillness-inspired).
/// Disabled while timer is running.
class PhasePillsRow extends ConsumerWidget {
  const PhasePillsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pomodoroControllerProvider);
    final state = controller.currentState;
    final disabled = state.isRunning;
    const ember = Color(0xFFE07A5F);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in [
            (PomodoroPhase.work, 'Focus'),
            (PomodoroPhase.shortBreak, 'Short'),
            (PomodoroPhase.longBreak, 'Long'),
          ])
            _Pill(
              label: entry.$2,
              active: state.phase == entry.$1,
              disabled: disabled,
              activeColor: ember,
              onTap: () => controller.setPhase(entry.$1),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool active;
  final bool disabled;
  final Color activeColor;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.active,
    required this.disabled,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: active
              ? activeColor.withValues(alpha: 0.16)
              : Colors.transparent,
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: active
                ? const Color(0xFFEDE8E1)
                : Colors.white.withValues(alpha: 0.45),
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
