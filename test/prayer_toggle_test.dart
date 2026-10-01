import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/features/prayer/data/prayer_repository.dart';
import 'package:pd/features/prayer/presentation/screens/prayer_dashboard_screen.dart';
import 'package:pd/features/scoring/domain/score_service.dart';

import 'todo_test_utils.dart';

void main() {
  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  testWidgets('ticking Fajr marks it and scores 15 points', (tester) async {
    // Enable the (default-off) prayer module.
    await env.prefs.setBool(PrefKeys.modulePrayer, true);

    await tester.pumpWidget(env.scope(const PrayerDashboardScreen()));
    await tester.pumpAndSettle();

    // Five prayer checkboxes, no location card blocks them.
    expect(find.byType(Checkbox), findsNWidgets(5));
    expect(find.text('--:--'), findsNWidgets(5));

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    var rec = await PrayerRepository(env.db).getOrCreateToday();
    expect(rec.fajr, isTrue);
    expect(rec.fajrQada, isFalse);

    // Ada badge (default) + emoji toggles appear.
    expect(find.text('ad'), findsOneWidget);
    expect(find.text('👥'), findsOneWidget);
    expect(find.text('🕌'), findsOneWidget);

    var row = await ScoreService(env.db).todayRow();
    expect(row?.prayerScore, 15);
    // Overall: 0.4 * (15/200) * 100 = 3.
    expect(row?.totalScore, 3);

    // Flip the badge to qada: 8 points.
    await tester.tap(find.text('ad'));
    await tester.pumpAndSettle();

    rec = await PrayerRepository(env.db).getOrCreateToday();
    expect(rec.fajrQada, isTrue);
    expect(find.text('qd'), findsOneWidget);

    row = await ScoreService(env.db).todayRow();
    expect(row?.prayerScore, 8);

    await disposeTree(tester);
  });
}
