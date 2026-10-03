import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/app.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/app/router.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/features/pomodoro/data/pomodoro_notifications.dart';
import 'package:pd/features/pomodoro/data/pomodoro_repository.dart';
import 'package:pd/features/prayer/data/prayer_notifications.dart';
import 'package:pd/features/prayer/data/prayer_repository.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:pd/features/todo/data/todo_notifications.dart';
import 'package:pd/features/todo/data/todo_repository.dart';
import 'package:pd/features/water/data/water_notifications.dart';
import 'package:pd/features/water/data/water_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase();
  final notifications = NotificationService(prefs: prefs);
  await notifications.init(
    onTap: (payload) async {
      final todoId = TodoNotifications.todoIdFromPayload(payload);
      if (todoId != null) {
        router.go('/todo/$todoId');
        return;
      }
      if (PrayerNameX.fromPayload(payload) != null) {
        router.go('/prayer');
      }
    },
  );

  // Re-arm day-before reminders every launch (survives reboots).
  final pending = await TodoRepository(database).pendingWithDueDate();
  await TodoNotifications(notifications).rescheduleAll(pending);

  // Re-schedule today's prayer alerts (times shift daily).
  final prayerSettings = await PrayerRepository(database).getSettings();
  await PrayerNotifications(notifications)
      .reschedule(settings: prayerSettings, now: DateTime.now());

  // Re-arm water reminders between wake and sleep.
  await WaterNotifications(notifications)
      .reschedule(WaterRepository(database, prefs));

  // Re-arm Pomodoro reminders.
  await PomodoroNotifications(notifications)
      .reschedule(PomodoroRepository(database));

  runApp(
    ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const PdApp(),
    ),
  );
}
