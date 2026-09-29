import 'package:flutter_test/flutter_test.dart';
import 'package:pd/features/todo/data/todo_notifications.dart';
import 'package:pd/features/todo/data/todo_repository.dart';

import 'todo_test_utils.dart';

void main() {
  // Plain (non-widget) tests need the tester binding for channel mocks.
  TestWidgetsFlutterBinding.ensureInitialized();

  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  test('dated to-do schedules 10am + 6pm day-before reminders', () async {
    final scheduler = TodoNotifications(env.notifications);
    final repo = TodoRepository(env.db);
    final due = DateTime.now().add(const Duration(days: 3));
    final id = await repo.create(
      title: 'Reminder task',
      dueDate: DateTime(due.year, due.month, due.day),
    );
    final todo = await repo.getById(id);
    await scheduler.scheduleFor(todo!);

    expect(
      env.fake.scheduled,
      containsAll(
          [TodoNotifications.id10am(id), TodoNotifications.id6pm(id)]),
    );

    // Past-due rows schedule nothing.
    env.fake.scheduled.clear();
    final pastId = await repo.create(
      title: 'Old task',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
    );
    await scheduler.scheduleFor((await repo.getById(pastId))!);
    expect(env.fake.scheduled, isEmpty);
  });
}
