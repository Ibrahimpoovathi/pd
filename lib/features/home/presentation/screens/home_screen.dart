import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/core/theme/theme_provider.dart';
import 'package:pd/core/widgets/progress_ring.dart';
import 'package:pd/features/scoring/presentation/providers/score_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting(DateTime now) {
    final hour = now.hour;
    if (hour < 5) return 'Good night';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final modules = ref.watch(modulesProvider);
    final scheme = Theme.of(context).colorScheme;

    final cards = <_ModuleCard>[
      _ModuleCard(
        title: 'To-Do',
        subtitle: 'Tasks, reminders & trash',
        icon: Icons.checklist_outlined,
        route: '/todo',
        enabled: true,
      ),
      _ModuleCard(
        title: 'Prayer Tracker',
        subtitle: modules[PrefKeys.modulePrayer] == true
            ? 'Daily salah & ibadah'
            : 'Turn on in Settings',
        icon: Icons.mosque_outlined,
        route: '/prayer',
        enabled: modules[PrefKeys.modulePrayer] == true,
      ),
      _ModuleCard(
        title: 'Water',
        subtitle: 'Hydration goal & reminders',
        icon: Icons.water_drop_outlined,
        route: '/water',
        enabled: modules[PrefKeys.moduleWater] ?? true,
      ),
      _ModuleCard(
        title: 'Pomodoro',
        subtitle: 'Distraction-free focus',
        icon: Icons.timer_outlined,
        route: '/pomodoro',
        enabled: modules[PrefKeys.modulePomodoro] ?? true,
      ),
      _ModuleCard(
        title: 'Screen Time',
        subtitle: 'Usage limits & focus mode',
        icon: Icons.phone_android_outlined,
        route: '/screen-time',
        enabled: modules[PrefKeys.moduleScreenTime] ?? true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PD'),
        actions: [
          IconButton(
            tooltip: 'Scores',
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () => context.push('/scores'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${_greeting(now)},',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            DateFormat('EEEE, d MMMM').format(now),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _ScoreCard(),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemCount: cards.length,
            itemBuilder: (context, i) {
              final card = cards[i];
              return Opacity(
                opacity: card.enabled ? 1 : 0.55,
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: card.enabled ? () => context.push(card.route) : null,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(card.icon, size: 28, color: scheme.primary),
                          const SizedBox(height: 8),
                          Text(
                            card.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            card.subtitle,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModuleCard {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final bool enabled;

  _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.enabled,
  });
}

class _ScoreCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(todayScoreProvider);
    final total = score.value?.totalScore ?? 0;
    final streak = score.value?.streakDays ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ProgressRing(
              progress: total / 100,
              size: 96,
              center: Text(
                '$total',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Score',
                    style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    streak > 0
                        ? '$streak-day streak. Prayer 40% · To-Do 30% · Screen Time 15% · Water 15%.'
                        : 'Complete tasks in any module to build your score. '
                            'Prayer 40% · To-Do 30% · Screen Time 15% · Water 15%.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
