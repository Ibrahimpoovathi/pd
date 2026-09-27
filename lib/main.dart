import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/app.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase();
  final notifications = NotificationService();
  await notifications.init();

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
