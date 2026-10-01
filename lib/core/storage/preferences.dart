import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the [SharedPreferences] instance.
/// Overridden in `main()` after async initialization.
final prefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('prefsProvider must be overridden in main()'),
);

/// SharedPreferences keys used across the app.
abstract final class PrefKeys {
  static const themeMode = 'theme_mode';

  // Module toggles. Prayer tracker is OFF by default, the rest are ON.
  static const modulePrayer = 'module_prayer_enabled';
  static const moduleWater = 'module_water_enabled';
  static const modulePomodoro = 'module_pomodoro_enabled';
  static const moduleScreenTime = 'module_screen_time_enabled';

  // Water defaults / smart-reminder settings.
  static const waterGoalCups = 'water_goal_cups';
  static const waterCupSizeMl = 'water_cup_size_ml';
  static const waterWakeMinutes = 'water_wake_minutes';
  static const waterSleepMinutes = 'water_sleep_minutes';
  static const waterReminderInterval = 'water_reminder_interval_minutes';
  static const waterRemindersEnabled = 'water_reminders_enabled';

  // To-do trash auto-clear (days to keep, 0 = manual only).
  static const todoTrashKeepDays = 'todo_trash_keep_days';

  // Exact-alarm permission state (cached; only prompt with in-app context).
  static const exactAlarmsGranted = 'exact_alarms_granted';
}
