import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/features/prayer/data/prayer_repository.dart';
import 'package:pd/features/prayer/presentation/screens/prayer_dashboard_screen.dart';

import 'todo_test_utils.dart';

void main() {
  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  testWidgets('history tab shows month grid and day detail', (tester) async {
    await env.prefs.setBool(PrefKeys.modulePrayer, true);
    final repo = PrayerRepository(env.db);
    final now = DateTime.now();
    // Seed the 1st: always visible in the current month grid (avoids
    // month-boundary flakes when today is the 1st).
    final target = DateTime(now.year, now.month, 1);
    final rec = await repo.getOrCreateToday(target);
    await repo.updateRecord(
      rec.id,
      const PrayerRecordsCompanion(
        fajr: Value(true),
        dhuhr: Value(true),
        asr: Value(true),
        maghrib: Value(true),
        isha: Value(true),
      ),
    );

    await tester.pumpWidget(env.scope(const PrayerDashboardScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    // Current month title + legend visible.
    expect(find.text(DateFormat('MMMM yyyy').format(now)), findsOneWidget);
    expect(find.text('All ada'), findsOneWidget);

    // Tap the 1st's cell -> detail sheet with score.
    await tester.tap(find.text('1').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Prayer score:'), findsOneWidget);

    await disposeTree(tester);
  });
}
