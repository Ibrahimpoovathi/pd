import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/features/prayer/presentation/screens/prayer_dashboard_screen.dart';

import 'todo_test_utils.dart';

void main() {
  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  testWidgets('disabled module shows enable prompt', (tester) async {
    await tester.pumpWidget(env.scope(const PrayerDashboardScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('turned off'), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);

    await disposeTree(tester);
  });
}
