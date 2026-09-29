import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/core/theme/theme_provider.dart';
import 'package:pd/features/prayer/presentation/screens/extra_ibadah_tab.dart';
import 'package:pd/features/prayer/presentation/screens/prayer_settings_tab.dart';
import 'package:pd/features/prayer/presentation/screens/prayers_tab.dart';

/// Muslim daily tracker: Prayers / Extra Ibadah / Settings tabs.
/// Opt-in via Settings (off by default).
class PrayerDashboardScreen extends ConsumerWidget {
  const PrayerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled =
        ref.watch(modulesProvider)[PrefKeys.modulePrayer] ?? false;
    if (!enabled) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prayer Tracker')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'The Muslim daily tracker is turned off.\nEnable it in Settings to start tracking.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.push('/settings'),
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prayer Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Prayers'),
              Tab(text: 'Extra'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PrayersTab(),
            ExtraIbadahTab(),
            PrayerSettingsTab(),
          ],
        ),
      ),
    );
  }
}
