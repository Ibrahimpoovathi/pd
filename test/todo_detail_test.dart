import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pd/features/todo/presentation/screens/todo_detail_screen.dart';

import 'todo_test_utils.dart';

void main() {
  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  testWidgets('creating an undated to-do schedules no reminders',
      (tester) async {
    final testRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/new',
          builder: (context, state) => const TodoDetailScreen(),
        ),
      ],
    );
    addTearDown(testRouter.dispose);
    // Providers must sit above the router.
    await tester.pumpWidget(
      _ScopedRouter(env: env, router: testRouter),
    );
    testRouter.push('/new');
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Dated task');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // No due date -> no reminders scheduled.
    expect(env.fake.scheduled, isEmpty);

    // One-shot read (never .watch().first in widget tests: a second live
    // subscription wedges the next pumpWidget under FakeAsync).
    final rows = await env.db.select(env.db.todos).get();
    expect(rows.map((t) => t.title), ['Dated task']);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}

class _ScopedRouter extends StatelessWidget {
  final TodoTestEnv env;
  final GoRouter router;

  const _ScopedRouter({required this.env, required this.router});

  @override
  Widget build(BuildContext context) => env.scope(
        MaterialApp.router(routerConfig: router),
      );
}
