import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';

/// Compact ambient mode cycler (Stillness-inspired).
/// Cycles: Off -> Brown -> Rain -> Mix -> Off.
/// Colors follow the app [ThemeData].
class AmbientToggleCompact extends ConsumerWidget {
  const AmbientToggleCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pomodoroControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final label = switch (controller.ambientMode) {
      AmbientMode.off => '○',
      AmbientMode.brown => '◉ brown',
      AmbientMode.rain => '◎ rain',
      AmbientMode.mix => '◈ mix',
    };
    return GestureDetector(
      onTap: () {
        final next = switch (controller.ambientMode) {
          AmbientMode.off => AmbientMode.brown,
          AmbientMode.brown => AmbientMode.rain,
          AmbientMode.rain => AmbientMode.mix,
          AmbientMode.mix => AmbientMode.off,
        };
        controller.updateAmbient(mode: next);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: scheme.onSurface.withValues(alpha: 0.06),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.5),
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
