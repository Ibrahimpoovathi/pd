import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/water/data/water_repository.dart';
import 'package:timezone/timezone.dart' as tz;

/// Hydration reminders between wake and sleep times at the set interval.
/// Re-scheduled at every app start, settings change, and cup added
/// (so the message can quote live progress).
class WaterNotifications {
  final NotificationService _service;

  WaterNotifications(this._service);

  /// Stable id space: 6001..6016 (up to 16 slots a day).
  static int slotId(int index) => 6001 + index;

  /// Pure slot computation — unit tested.
  /// Returns today's reminder times (local) strictly after [now].
  static List<DateTime> slotsFor({
    required DateTime now,
    required int wakeMinutes,
    required int sleepMinutes,
    required int intervalMinutes,
  }) {
    if (intervalMinutes <= 0 || wakeMinutes >= sleepMinutes) return [];
    final day = dateOnly(now);
    final slots = <DateTime>[];
    var cursor = wakeMinutes + intervalMinutes;
    var index = 0;
    while (cursor < sleepMinutes && index < 16) {
      final at = day.add(Duration(minutes: cursor));
      if (at.isAfter(now)) slots.add(at);
      cursor += intervalMinutes;
      index++;
    }
    return slots;
  }

  Future<void> cancelAll() async {
    for (var i = 0; i < 16; i++) {
      await _service.cancel(slotId(i));
    }
  }

  Future<void> reschedule(WaterRepository repo) async {
    await cancelAll();
    if (!repo.remindersEnabled) return;
    final now = DateTime.now();
    final slots = slotsFor(
      now: now,
      wakeMinutes: repo.wakeMinutes,
      sleepMinutes: repo.sleepMinutes,
      intervalMinutes: repo.reminderInterval,
    );
    if (slots.isEmpty) return;
    final exact = await _service.requestExactAlarms();
    final today = await repo.getOrCreateToday(now);
    final drunk = today.mlConsumed;
    final goal = repo.goalMl;
    for (var i = 0; i < slots.length; i++) {
      await _service.scheduleReminder(
        id: slotId(i),
        title: 'Time for water',
        body: drunk >= goal
            ? 'Goal reached — nice work staying hydrated.'
            : 'You are at ${drunk}ml of ${goal}ml so far.',
        scheduledDate: tz.TZDateTime.from(slots[i], tz.local),
        payload: 'water:remind',
        channel: NotificationChannels.water,
        exact: exact,
      );
    }
  }
}
