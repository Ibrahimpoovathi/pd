import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/prayer/data/prayer_time_calculator.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:timezone/timezone.dart' as tz;

/// Azan-time alerts for the five daily prayers. Re-scheduled at every app
/// start (times shift daily) and whenever prayer settings change.
class PrayerNotifications {
  final NotificationService _service;

  PrayerNotifications(this._service);

  Future<void> cancelAll() async {
    for (final p in PrayerName.values) {
      await _service.cancel(p.notificationId);
    }
  }

  Future<void> reschedule({
    required PrayerSetting settings,
    required DateTime now,
  }) async {
    await cancelAll();
    if (!settings.notificationsEnabled) return;
    final lat = settings.latitude;
    final lng = settings.longitude;
    if (lat == null || lng == null) return;

    final times = PrayerTimeCalculator.calculate(
      latitude: lat,
      longitude: lng,
      methodKey: settings.calculationMethod,
      madhabKey: settings.madhab,
      date: now,
      useManual: settings.useManual,
      manualOffsets:
          PrayerTimeCalculator.parseOffsets(settings.manualOffsetsJson),
    );
    final exact = await _service.requestExactAlarms();
    for (final p in PrayerName.values) {
      final at = times.timeOf(p);
      if (!at.isAfter(now)) continue;
      await _service.scheduleReminder(
        id: p.notificationId,
        title: '${p.label} time',
        body: 'It is time for ${p.label} prayer.',
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        payload: 'prayer:${p.name}',
        channel: NotificationChannels.prayer,
        exact: exact,
      );
    }
  }
}
