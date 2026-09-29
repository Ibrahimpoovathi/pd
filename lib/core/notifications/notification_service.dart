import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Provides the shared [NotificationService].
/// Overridden in `main()` with the initialized instance.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError(
    'notificationServiceProvider must be overridden in main()',
  ),
);

/// Notification channel ids, one per module.
abstract final class NotificationChannels {
  static const todo = 'todo_reminders';
  static const prayer = 'prayer_times';
  static const water = 'water_reminders';
  static const pomodoro = 'pomodoro';
  static const screenTime = 'screen_time';
}

/// Central wrapper around flutter_local_notifications.
/// Phase-specific scheduling (todo reminders, azan, water, pomodoro phase
/// transitions) will be added in their respective phases; this class owns
/// initialization, channels, permissions and cancellation.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Called with the notification payload when the user taps a notification.
  Future<void> Function(String? payload)? onTap;

  Future<void> init({Future<void> Function(String? payload)? onTap}) async {
    if (_initialized) return;
    this.onTap = onTap;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) =>
          onTap?.call(response.payload),
    );

    tz.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Fall back to UTC if the device timezone cannot be resolved.
      tz.setLocalLocation(tz.UTC);
    }

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    for (final channel in _channels) {
      await androidImpl?.createNotificationChannel(channel);
    }

    _initialized = true;
  }

  static const _channels = [
    AndroidNotificationChannel(
      NotificationChannels.todo,
      'To-Do Reminders',
      description: 'Day-before reminders for scheduled to-dos',
      importance: Importance.high,
    ),
    AndroidNotificationChannel(
      NotificationChannels.prayer,
      'Prayer Times',
      description: 'Prayer time and azan notifications',
      importance: Importance.high,
    ),
    AndroidNotificationChannel(
      NotificationChannels.water,
      'Water Reminders',
      description: 'Hydration reminders during waking hours',
      importance: Importance.defaultImportance,
    ),
    AndroidNotificationChannel(
      NotificationChannels.pomodoro,
      'Pomodoro',
      description: 'Focus session transitions and foreground timer',
      importance: Importance.high,
    ),
    AndroidNotificationChannel(
      NotificationChannels.screenTime,
      'Screen Time',
      description: 'App limit and focus mode alerts',
      importance: Importance.defaultImportance,
    ),
  ];

  /// Requests notification permissions on Android 13+ and iOS.
  /// Returns true if alerts are (now) allowed.
  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted = await android?.requestNotificationsPermission();

    final ios =
        _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  Future<void> cancel(int id) => _plugin.cancel(id: id);

  Future<void> cancelAll() => _plugin.cancelAll();

  /// Requests the exact-alarm permission (Android 12+). Returns true when
  /// exact scheduling is allowed (always true on iOS / older Android).
  Future<bool> requestExactAlarms() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestExactAlarmsPermission() ?? true;
  }

  /// Schedules a one-shot reminder. [exact]=false falls back to inexact
  /// timing when the exact-alarm permission was denied.
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required String channel,
    String? payload,
    bool exact = true,
  }) {
    final androidDetails = AndroidNotificationDetails(channel, channel);
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      payload: payload,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexact,
    );
  }
}
