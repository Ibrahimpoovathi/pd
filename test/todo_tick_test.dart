import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/features/scoring/domain/score_service.dart';
import 'package:pd/features/todo/data/todo_repository.dart';
import 'package:pd/features/todo/presentation/screens/todo_home_screen.dart';

import 'todo_test_utils.dart';

void main() {
  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  testWidgets('ticking a task moves it to Done and scores 10 points',
      (tester) async {
    final repo = TodoRepository(env.db);
    await repo.create(title: 'Write report');
    await repo.create(title: 'Buy milk');

    await tester.pumpWidget(env.scope(const TodoHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Write report'), findsOneWidget);
    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.textContaining('Done'), findsNothing);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Done'), findsOneWidget);

    final row = await ScoreService(env.db).todayRow();
    expect(row?.todoScore, 10);

    await disposeTree(tester);
  });
}
