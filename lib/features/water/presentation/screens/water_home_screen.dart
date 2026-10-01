import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/widgets/progress_ring.dart';
import 'package:pd/features/water/presentation/providers/water_providers.dart';
import 'package:pd/features/water/presentation/screens/water_settings_sheet.dart';

/// Daily hydration: progress ring, quick-add, undo, 7-day history.
class WaterHomeScreen extends ConsumerWidget {
  const WaterHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayWaterProvider);
    final week = ref.watch(weekWaterProvider);
    final streak = ref.watch(waterStreakProvider);
    final repo = ref.watch(waterRepositoryProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water'),
        actions: [
          IconButton(
            tooltip: 'Water settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => WaterSettingsSheet.show(context),
          ),
        ],
      ),
      body: today.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load: $e')),
        data: (rec) {
          if (rec == null) {
            return const Center(child: Text('Preparing today…'));
          }
          final goal = repo.goalMl;
          final progress = goal <= 0 ? 0.0 : (rec.mlConsumed / goal).clamp(0.0, 1.0);
          final met = rec.mlConsumed >= goal;
          final streakDays = streak.value ?? 0;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ProgressRing(
                  progress: progress,
                  size: 200,
                  strokeWidth: 18,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${rec.mlConsumed}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ml of $goal',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (met)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(Icons.check_circle,
                              color: scheme.primary, size: 20),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  streakDays > 0
                      ? '$streakDays-day goal streak'
                      : 'Reach your goal to start a streak',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AddButton(
                    label: '+${repo.cupSizeMl}',
                    onTap: () => addWater(ref, repo.cupSizeMl),
                  ),
                  _AddButton(
                    label: '+500',
                    onTap: () => addWater(ref, 500),
                  ),
                  _AddButton(
                    label: 'Custom',
                    onTap: () => _customDialog(context, ref),
                  ),
                  _AddButton(
                    label: 'Undo',
                    icon: Icons.undo,
                    onTap: () => addWater(ref, -repo.cupSizeMl),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'LAST 7 DAYS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              week.when(
                data: (rows) => _WeekBars(
                  rows: rows,
                  goalMl: goal,
                  cupMl: repo.cupSizeMl,
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, _) =>
                    const Text('History unavailable.'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _customDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final ml = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom amount (ml)'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Millilitres',
            hintText: 'e.g. 350',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx)
                .pop(int.tryParse(controller.text.trim())),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (ml != null && ml > 0 && context.mounted) {
      await addWater(ref, ml.clamp(0, 2000));
    }
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _AddButton({
    required this.label,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onTap,
      child: icon == null
          ? Text(label)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(icon, size: 18), const SizedBox(width: 4), Text(label)],
            ),
    );
  }
}

class _WeekBars extends StatelessWidget {
  final List<WaterRecord> rows;
  final int goalMl;
  final int cupMl;

  const _WeekBars({
    required this.rows,
    required this.goalMl,
    required this.cupMl,
  });

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final byDay = {for (final r in rows) _key(r.date): r};
    final today = DateTime.now();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 6; i >= 0; i--)
          Expanded(
            child: _DayBar(
              label: days[DateTime.now()
                      .subtract(Duration(days: i))
                      .weekday -
                  1],
              record: byDay[_key(today.subtract(Duration(days: i)))],
              goalMl: goalMl,
              isToday: i == 0,
            ),
          ),
      ],
    );
  }

  String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

class _DayBar extends StatelessWidget {
  final String label;
  final WaterRecord? record;
  final int goalMl;
  final bool isToday;

  const _DayBar({
    required this.label,
    required this.record,
    required this.goalMl,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ml = record?.mlConsumed ?? 0;
    final frac = goalMl <= 0 ? 0.0 : (ml / goalMl).clamp(0.0, 1.0);
    final met = ml >= goalMl && goalMl > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ml > 0 ? '$ml' : '',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        Container(
          height: 90,
          width: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isToday ? scheme.primary : scheme.outline,
              width: isToday ? 2 : 1,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: frac,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: met ? scheme.primary : scheme.primary.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
