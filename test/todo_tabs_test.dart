import 'package:flutter_test/flutter_test.dart';
import 'package:pd/features/todo/data/todo_repository.dart';
import 'package:pd/features/todo/presentation/screens/todo_home_screen.dart';

import 'todo_test_utils.dart';

void main() {
  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  testWidgets('today tab shows only todays tasks', (tester) async {
    final repo = TodoRepository(env.db);
    final now = DateTime.now();
    await repo.create(title: 'Today task', dueDate: now);
    await repo.create(
      title: 'Future task',
      dueDate: now.add(const Duration(days: 5)),
    );

    await tester.pumpWidget(env.scope(const TodoHomeScreen()));
    await tester.pumpAndSettle();

    // All tab shows both.
    expect(find.text('Today task'), findsOneWidget);
    expect(find.text('Future task'), findsOneWidget);

    // Today tab shows only today's.
    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    expect(find.text('Today task'), findsOneWidget);
    expect(find.text('Future task'), findsNothing);

    await disposeTree(tester);
  });
}
