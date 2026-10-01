import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/features/prayer/data/prayer_time_calculator.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:pd/features/prayer/presentation/providers/prayer_providers.dart';
import 'package:pd/features/prayer/presentation/screens/prayer_dashboard_screen.dart';

import 'todo_test_utils.dart';

/// Time-gating: future prayers locked, past prayers markable.
/// Times are overridden (deterministic, no wall-clock dependence).
void main() {
  DayPrayerTimes timesAt(DateTime t) => DayPrayerTimes({
        for (final p in PrayerName.values) p: t,
      });

  group('gating', () {
    testWidgets('future prayers are locked with snackbar hint',
        (tester) async {
      final env = TodoTestEnv();
      await env.setUp();
      addTearDown(env.tearDown);
      await env.prefs.setBool(PrefKeys.modulePrayer, true);
      final future =
          timesAt(DateTime.now().add(const Duration(days: 1)));

      await tester.pumpWidget(
        env.scope(
          const PrayerDashboardScreen(),
          extra: [
            todayPrayerTimesProvider.overrideWith((ref) async => future),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final box =
          tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(box.onChanged, isNull);

      // Tapping the locked card explains when it starts.
      await tester.tap(find.text('Fajr'));
      await tester.pump();
      expect(find.textContaining('can be marked once'), findsOneWidget);

      await disposeTree(tester);
    });

    testWidgets('past prayers are markable', (tester) async {
      final env = TodoTestEnv();
      await env.setUp();
      addTearDown(env.tearDown);
      await env.prefs.setBool(PrefKeys.modulePrayer, true);
      final past =
          timesAt(DateTime.now().subtract(const Duration(days: 1)));

      await tester.pumpWidget(
        env.scope(
          const PrayerDashboardScreen(),
          extra: [
            todayPrayerTimesProvider.overrideWith((ref) async => past),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final box =
          tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(box.onChanged, isNotNull);

      await disposeTree(tester);
    });
  });
}
