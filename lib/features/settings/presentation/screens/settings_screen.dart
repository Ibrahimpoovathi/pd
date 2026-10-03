import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(appThemeVariantProvider);
    final modules = ref.watch(modulesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _sectionHeader(context, 'Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final v in AppThemeVariant.values)
                  ChoiceChip(
                    label: Text(_variantLabel(v)),
                    selected: variant == v,
                    onSelected: (_) => ref
                        .read(appThemeVariantProvider.notifier)
                        .setVariant(v),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Warm/Cool/Pure = Stillness-inspired dark themes. '
              'Sepia = warm light theme, easy on the eyes.',
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

  String _variantLabel(AppThemeVariant v) {
    switch (v) {
      case AppThemeVariant.warmNight:
        return 'Warm';
      case AppThemeVariant.coolNight:
        return 'Cool';
      case AppThemeVariant.pureDark:
        return 'Pure';
      case AppThemeVariant.sepiaLight:
        return 'Sepia';
    }
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
