import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/scoring/presentation/providers/score_providers.dart';
import 'package:pd/features/water/presentation/providers/water_providers.dart';

/// Goal, cup size, wake/sleep window, reminder interval + master toggle.
class WaterSettingsSheet extends ConsumerStatefulWidget {
  const WaterSettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const WaterSettingsSheet(),
    );
  }

  @override
  ConsumerState<WaterSettingsSheet> createState() =>
      _WaterSettingsSheetState();
}

class _WaterSettingsSheetState extends ConsumerState<WaterSettingsSheet> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(waterRepositoryProvider);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 8, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Water settings',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Daily goal (cups)'),
                trailing: _Stepper(
                  value: repo.goalCups,
                  min: 1,
                  max: 20,
                  onChanged: (v) => _save(goalCups: v),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Cup size (ml)'),
                trailing: DropdownButton<int>(
                  value: _cupOption(repo.cupSizeMl),
                  items: const [200, 250, 300, 350, 500]
                      .map((ml) => DropdownMenuItem(
                          value: ml, child: Text('$ml')))
                      .toList(),
                  onChanged: (v) =>
                      v == null ? null : _save(cupSizeMl: v),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Wake up'),
                trailing: TextButton(
                  onPressed: () =>
                      _pickTime(repo.wakeMinutes, (v) => _save(wakeMinutes: v)),
                  child: Text(formatMinutes(repo.wakeMinutes)),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sleep'),
                trailing: TextButton(
                  onPressed: () => _pickTime(
                      repo.sleepMinutes, (v) => _save(sleepMinutes: v)),
                  child: Text(formatMinutes(repo.sleepMinutes)),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reminder every'),
                trailing: DropdownButton<int>(
                  value: _intervalOption(repo.reminderInterval),
                  items: const [30, 60, 90, 120, 180]
                      .map((m) => DropdownMenuItem(
                          value: m, child: Text('$m min')))
                      .toList(),
                  onChanged: (v) =>
                      v == null ? null : _save(reminderInterval: v),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reminders'),
                subtitle: const Text(
                    'Only between wake and sleep times.'),
                value: repo.remindersEnabled,
                onChanged: (v) => _save(remindersEnabled: v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _cupOption(int ml) {
    const options = [200, 250, 300, 350, 500];
    return options.contains(ml) ? ml : 250;
  }

  int _intervalOption(int minutes) {
    const options = [30, 60, 90, 120, 180];
    return options.contains(minutes) ? minutes : 120;
  }

  Future<void> _save({
    int? goalCups,
    int? cupSizeMl,
    int? wakeMinutes,
    int? sleepMinutes,
    int? reminderInterval,
    bool? remindersEnabled,
  }) async {
    final repo = ref.read(waterRepositoryProvider);
    await repo.saveSettings(
      goalCups: goalCups,
      cupSizeMl: cupSizeMl,
      wakeMinutes: wakeMinutes,
      sleepMinutes: sleepMinutes,
      reminderInterval: reminderInterval,
      remindersEnabled: remindersEnabled,
    );
    ref.invalidate(todayWaterProvider);
    ref.invalidate(weekWaterProvider);
    ref.invalidate(waterStreakProvider);
    await ref
        .read(waterNotificationsProvider)
        .reschedule(ref.read(waterRepositoryProvider));
    final today = await repo.getOrCreateToday();
    await ref.read(scoreServiceProvider).recordWaterDay(today);
  }

  Future<void> _pickTime(
      int current, ValueChanged<int> onPicked) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked != null) {
      onPicked(picked.hour * 60 + picked.minute);
    }
  }
}

class _Stepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        Text('$value',
            style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}