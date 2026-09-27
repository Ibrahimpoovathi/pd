import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final modules = ref.watch(modulesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _sectionHeader(context, 'Appearance'),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('System')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ButtonSegment(value: ThemeMode.light, label: Text('Light')),
            ],
            selected: {themeMode},
            onSelectionChanged: (modes) =>
                ref.read(themeModeProvider.notifier).setMode(modes.first),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Dark = GitHub Dark. Light = warm sepia, easy on the eyes.',
            ),
          ),
          _sectionHeader(context, 'Modules'),
          SwitchListTile(
            title: const Text('Muslim Daily Tracker'),
            subtitle: const Text(
              'Prayers, Quran, adhkar. Off by default — opt in here.',
            ),
            value: modules[PrefKeys.modulePrayer] ?? false,
            onChanged: (v) => ref
                .read(modulesProvider.notifier)
                .setEnabled(PrefKeys.modulePrayer, v),
          ),
          SwitchListTile(
            title: const Text('Water Tracker'),
            value: modules[PrefKeys.moduleWater] ?? true,
            onChanged: (v) => ref
                .read(modulesProvider.notifier)
                .setEnabled(PrefKeys.moduleWater, v),
          ),
          SwitchListTile(
            title: const Text('Pomodoro Timer'),
            value: modules[PrefKeys.modulePomodoro] ?? true,
            onChanged: (v) => ref
                .read(modulesProvider.notifier)
                .setEnabled(PrefKeys.modulePomodoro, v),
          ),
          SwitchListTile(
            title: const Text('Screen Time Controller'),
            value: modules[PrefKeys.moduleScreenTime] ?? true,
            onChanged: (v) => ref
                .read(modulesProvider.notifier)
                .setEnabled(PrefKeys.moduleScreenTime, v),
          ),
          _sectionHeader(context, 'Notifications'),
          ListTile(
            title: const Text('Enable notifications'),
            subtitle: const Text(
              'Required for to-do reminders, prayer times, water and pomodoro alerts.',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final granted = await ref
                  .read(notificationServiceProvider)
                  .requestPermissions();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      granted
                          ? 'Notifications enabled.'
                          : 'Notifications not granted. You can enable them in system settings.',
                    ),
                  ),
                );
              }
            },
          ),
          _sectionHeader(context, 'About'),
          const ListTile(
            title: Text('PD — Personal Development'),
            subtitle: Text('Phase 1 foundation build. Local-first, private by design.'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
