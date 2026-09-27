import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pd/app/placeholder_screen.dart';
import 'package:pd/features/home/presentation/screens/home_screen.dart';
import 'package:pd/features/settings/presentation/screens/settings_screen.dart';

/// App navigation. Bottom tabs: Home + Settings.
/// Feature modules are pushed as full-screen routes; in Phase 1 they render
/// a placeholder until their implementation phase lands.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNav(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/todo',
      builder: (context, state) => const PlaceholderScreen(
        title: 'To-Do',
        message: 'The To-Do module lands in Phase 2.',
      ),
    ),
    GoRoute(
      path: '/prayer',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Prayer Tracker',
        message: 'The Muslim daily tracker lands in Phase 3.',
      ),
    ),
    GoRoute(
      path: '/water',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Water Tracker',
        message: 'The Water tracker lands in Phase 4.',
      ),
    ),
    GoRoute(
      path: '/pomodoro',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Pomodoro',
        message: 'The Pomodoro timer lands in Phase 5.',
      ),
    ),
    GoRoute(
      path: '/screen-time',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Screen Time',
        message: 'The Screen Time controller lands in Phase 6.',
      ),
    ),
    GoRoute(
      path: '/scores',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Scores',
        message: 'The scoring dashboard lands in Phase 7.',
      ),
    ),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNav({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
