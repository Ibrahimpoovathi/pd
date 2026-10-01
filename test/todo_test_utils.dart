import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

/// Fake Android notification platform: records scheduled/cancelled ids,
/// grants permissions. Extends the Android plugin so the app plugin's
/// Android-only `!` delegation resolves to this fake instead of null.
class FakeNotificationsPlatform
    extends AndroidFlutterLocalNotificationsPlugin {
  final scheduled = <int>[];
  final cancelled = <int>[];

  @override
  Future<bool> initialize({
    required AndroidInitializationSettings settings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async =>
      true;

  @override
  Future<void> zonedSchedule({
    required int id,
    String? title,
    String? body,
    required tz.TZDateTime scheduledDate,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
    AndroidNotificationDetails? notificationDetails,
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exact,
  }) async {
    scheduled.add(id);
  }

  @override
  Future<void> cancel({required int id, String? tag}) async {
    cancelled.add(id);
  }

  @override
  Future<void> createNotificationChannel(
    AndroidNotificationChannel notificationChannel,
  ) async {}

  @override
  Future<bool?> requestExactAlarmsPermission() async => true;
}

class TodoTestEnv {
  late FakeNotificationsPlatform fake;
  late AppDatabase db;
  late SharedPreferences prefs;
  late NotificationService notifications;

  Future<void> setUp() async {
    fake = FakeNotificationsPlatform();
    FlutterLocalNotificationsPlatform.instance = fake;
    // flutter_timezone has no test double: answer its channel directly.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_timezone'),
      (call) async => 'UTC',
    );
    db = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    notifications = NotificationService();
    await notifications.init();
  }

  Future<void> tearDown() => db.close();

  // NB: Riverpod 3 does not publicly export the Override type, so extras
  // are dynamic (type-checked against ProviderScope's parameter at use).
  Widget scope(Widget child, {List<dynamic> extra = const []}) {
    return ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(notifications),
        ...extra,
      ],
      child: MaterialApp(home: child),
    );
  }
}

/// Disposes the widget tree and advances the fake clock so drift's
/// zero-duration stream-close timer fires before teardown.
Future<void> disposeTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}
