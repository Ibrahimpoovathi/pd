import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:timezone/timezone.dart' as tz;

/// Day-before reminders for to-dos: 10:00 AM and 6:00 PM on the day before
/// the due date. Only scheduled when the due date is at least tomorrow.
class TodoNotifications {
  final NotificationService _service;

  TodoNotifications(this._service);

  /// Stable notification ids per to-do.
  static int id10am(int todoId) => todoId * 10 + 1;
  static int id6pm(int todoId) => todoId * 10 + 2;

  static String payloadFor(int todoId) => 'todo:$todoId';

  static int? todoIdFromPayload(String? payload) {
    if (payload == null || !payload.startsWith('todo:')) return null;
    return int.tryParse(payload.substring('todo:'.length));
  }

  Future<void> cancelFor(int todoId) async {
    await _service.cancel(id10am(todoId));
    await _service.cancel(id6pm(todoId));
  }

  /// (Re)schedules both reminders for [todo]. No-ops for undated,
  /// completed, or past-due rows.
  Future<void> scheduleFor(Todo todo) async {
    await cancelFor(todo.id);
    final due = todo.dueDate;
    if (due == null || todo.isCompleted) return;

    final dayBefore = dateOnly(due).subtract(const Duration(days: 1));
    final now = DateTime.now();
    // Skip if the day-before is already past (due today or earlier).
    if (!dayBefore.isAfter(dateOnly(now))) return;

    final exact = await _service.requestExactAlarms();

    final times = <int, int>{id10am(todo.id): 10 * 60, id6pm(todo.id): 18 * 60};
    for (final entry in times.entries) {
      final at = DateTime(
        dayBefore.year,
        dayBefore.month,
        dayBefore.day,
        entry.value ~/ 60,
        entry.value % 60,
      );
      if (!at.isAfter(now)) continue;
      await _service.scheduleReminder(
        id: entry.key,
        title: 'Upcoming to-do',
        body: '“${todo.title}” is due tomorrow.',
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        payload: payloadFor(todo.id),
        channel: NotificationChannels.todo,
        exact: exact,
      );
    }
  }

  /// Re-schedules reminders for every pending dated to-do.
  /// Called at app start (survives reboots) and after settings changes.
  Future<void> rescheduleAll(List<Todo> todos) async {
    for (final t in todos) {
      await scheduleFor(t);
    }
  }
}
