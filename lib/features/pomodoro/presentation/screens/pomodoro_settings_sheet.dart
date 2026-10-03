import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_palettes.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';

/// Full settings sheet (Stillness-inspired).
///
/// Sections: Durations, Flow, Display, Atmosphere, Chime, Look, Other.
class PomodoroSettingsSheet extends ConsumerWidget {
  const PomodoroSettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const PomodoroSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pomodoroControllerProvider);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            22, 12, 22, 18 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Stillness',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        letterSpacing: 1.0)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('done',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionLabel(context, 'Durations'),
            _StepperRow(
              label: 'Focus',
              value: controller.workMinutes,
              min: 5,
              max: 90,
              suffix: 'm',
              onChange: (v) {
                controller.updateSettings(
                  workMinutes: v,
                  shortBreakMinutes: controller.shortBreakMinutes,
                  longBreakMinutes: controller.longBreakMinutes,
                  totalCycles: controller.totalCycles,
                );
                controller.reset();
              },
            ),
            _StepperRow(
              label: 'Short break',
              value: controller.shortBreakMinutes,
              min: 1,
              max: 20,
              suffix: 'm',
              onChange: (v) {
                controller.updateSettings(
                  workMinutes: controller.workMinutes,
                  shortBreakMinutes: v,
                  longBreakMinutes: controller.longBreakMinutes,
                  totalCycles: controller.totalCycles,
                );
                if (controller.currentState.phase ==
                    PomodoroPhase.shortBreak) {
                  controller.reset();
                }
              },
            ),
            _StepperRow(
              label: 'Long break',
              value: controller.longBreakMinutes,
              min: 5,
              max: 45,
              suffix: 'm',
              onChange: (v) {
                controller.updateSettings(
                  workMinutes: controller.workMinutes,
                  shortBreakMinutes: controller.shortBreakMinutes,
                  longBreakMinutes: v,
                  totalCycles: controller.totalCycles,
                );
                if (controller.currentState.phase ==
                    PomodoroPhase.longBreak) {
                  controller.reset();
                }
              },
            ),
            _StepperRow(
              label: 'Long break every',
              value: controller.totalCycles,
              min: 2,
              max: 8,
              suffix: 'sessions',
              onChange: (v) {
                controller.updateSettings(
                  workMinutes: controller.workMinutes,
                  shortBreakMinutes: controller.shortBreakMinutes,
                  longBreakMinutes: controller.longBreakMinutes,
                  totalCycles: v,
                );
              },
            ),
            const SizedBox(height: 12),
            _sectionLabel(context, 'Flow'),
            _ToggleRow(
              title: 'Auto-start breaks',
              subtitle: 'Start the break after focus completes',
              value: controller.autoStartBreaks,
              onChange: (v) => controller.updateAutoStart(breaks: v),
            ),
            _ToggleRow(
              title: 'Auto-start focus',
              subtitle: 'Start focus after a break',
              value: controller.autoStartFocus,
              onChange: (v) => controller.updateAutoStart(focus: v),
            ),
            const SizedBox(height: 12),
            _sectionLabel(context, 'Display'),
            _ToggleRow(
              title: 'Keep screen awake',
              subtitle: 'Prevent sleep while running/paused',
              value: controller.keepScreenOnEnabled,
              onChange: (v) =>
                  controller.updateKeepScreenOnEnabled(v),
            ),
            const SizedBox(height: 12),
            _sectionLabel(context, 'Atmosphere'),
            _AmbientRow(controller: controller),
            _sectionLabel(context, 'Chime'),
            _ChimeRow(controller: controller),
            const SizedBox(height: 12),
            _sectionLabel(context, 'Look'),
            _PaletteRows(controller: controller),
            const SizedBox(height: 12),
            _sectionLabel(context, 'Other'),
            _ToggleRow(
              title: 'Sound chime',
              subtitle: 'Play alarm tone on session end',
              value: controller.chimeEnabled,
              onChange: (v) => controller.updateChimeEnabled(v),
            ),
            _ToggleRow(
              title: 'Haptics',
              subtitle: 'Vibrate on completion',
              value: controller.vibrationEnabled,
              onChange: (v) => controller.updateVibrationEnabled(v),
            ),
            const SizedBox(height: 18),
            Text(
              'Tip: Tap time to reveal. Hold orb to peek cycle. '
              'Tap footer wake label to toggle keep-awake.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.32),
          fontSize: 10,
          letterSpacing: 2.2,
        ),
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final String suffix;
  final ValueChanged<int> onChange;

  const _StepperRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.82),
                  fontSize: 13)),
          Row(
            children: [
              _StepButton(
                  glyph: '−',
                  onTap: () => onChange((value - 1).clamp(min, max))),
              SizedBox(
                width: 72,
                child: Text('$value $suffix',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface, fontSize: 13)),
              ),
              _StepButton(
                  glyph: '+',
                  onTap: () => onChange((value + 1).clamp(min, max))),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final String glyph;
  final VoidCallback onTap;
  const _StepButton({required this.glyph, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15)),
        ),
        alignment: Alignment.center,
        child: Text(glyph,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChange;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.82),
                        fontSize: 13)),
                Text(subtitle,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.48),
                        fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChange,
            activeThumbColor: Theme.of(context).colorScheme.primary,
            activeTrackColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class _AmbientRow extends ConsumerWidget {
  final PomodoroController controller;
  const _AmbientRow({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild on ambient param changes via controller watch (parent).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ambient bed',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
          ),
          child: Row(
            children: [
              for (final entry in [
                (AmbientMode.off, 'Off'),
                (AmbientMode.brown, 'Brown'),
                (AmbientMode.rain, 'Rain'),
                (AmbientMode.mix, 'Mix'),
              ])
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        controller.updateAmbient(mode: entry.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: controller.ambientMode == entry.$1
                            ? Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.16)
                            : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        entry.$2.toUpperCase(),
                        style: TextStyle(
                          color: controller.ambientMode == entry.$1
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                          fontSize: 9,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (controller.ambientMode != AmbientMode.off) ...[
          Row(
            children: [
              Text('quiet',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 9)),
              Expanded(
                child: Slider(
                  value: controller.ambientVolume,
                  onChanged: (v) =>
                      controller.updateAmbient(volume: v),
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15),
                ),
              ),
              Text('full',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 9)),
            ],
          ),
          Text(
            switch (controller.ambientMode) {
              AmbientMode.brown => 'Warm low whoosh',
              AmbientMode.rain => 'Soft hiss with drop pings',
              AmbientMode.mix => 'Blend brown + rain at your ratio',
              AmbientMode.off => '',
            },
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                fontSize: 10),
          ),
        ],
        if (controller.ambientMode == AmbientMode.mix)
          Row(
            children: [
              SizedBox(
                width: 36,
                child: Text('brown',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                        fontSize: 9)),
              ),
              Expanded(
                child: Slider(
                  value: controller.ambientRainMix,
                  onChanged: (v) =>
                      controller.updateAmbient(rainMix: v),
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15),
                ),
              ),
              SizedBox(
                width: 28,
                child: Text('rain',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                        fontSize: 9)),
              ),
            ],
          ),
      ],
    );
  }
}

class _ChimeRow extends StatelessWidget {
  final PomodoroController controller;
  const _ChimeRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text('Chime tone',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13)),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
          ),
          child: Row(
            children: [
              for (final entry in [
                (ChimeTone.warm, 'Warm'),
                (ChimeTone.glass, 'Glass'),
                (ChimeTone.wood, 'Wood'),
                (ChimeTone.bowl, 'Bowl'),
              ])
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.updateChimeTone(entry.$1);
                      controller.playStartTick();
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: controller.chimeTone == entry.$1
                            ? Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.16)
                            : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        entry.$2.toUpperCase(),
                        style: TextStyle(
                          color: controller.chimeTone == entry.$1
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('Alarm stream — tap to preview',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 10)),
        ),
      ],
    );
  }
}

class _PaletteRows extends StatelessWidget {
  final PomodoroController controller;
  const _PaletteRows({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in [
          (PomodoroPhase.work, 'Focus'),
          (PomodoroPhase.shortBreak, 'Short break'),
          (PomodoroPhase.longBreak, 'Long break'),
        ]) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(entry.$2,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 11)),
          ),
          Row(
            children: [
              for (final pal
                  in PomodoroPaletteSets.all[entry.$1] ?? const [])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      final current =
                          controller.colorJourneys[entry.$1];
                      controller.updateColorJourney(
                        entry.$1,
                        current == pal.id ? null : pal.id,
                      );
                    },
                    child: Container(
                      width: controller.colorJourneys[entry.$1] ==
                              pal.id
                          ? 36
                          : 32,
                      height: controller.colorJourneys[entry.$1] ==
                              pal.id
                          ? 36
                          : 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        border: controller.colorJourneys[entry.$1] ==
                                pal.id
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PomodoroPaletteSets.colorForStops(
                              pal.stops, 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
