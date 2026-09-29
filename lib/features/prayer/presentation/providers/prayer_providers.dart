import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/prayer/data/prayer_notifications.dart';
import 'package:pd/features/prayer/data/prayer_repository.dart';
import 'package:pd/features/prayer/data/prayer_time_calculator.dart';
import 'package:pd/features/scoring/presentation/providers/score_providers.dart';

final prayerRepositoryProvider = Provider<PrayerRepository>(
  (ref) => PrayerRepository(ref.watch(databaseProvider)),
);

final prayerNotificationsProvider = Provider<PrayerNotifications>(
  (ref) => PrayerNotifications(ref.watch(notificationServiceProvider)),
);

final prayerSettingsProvider = StreamProvider<PrayerSetting>(
  (ref) => ref.watch(prayerRepositoryProvider).watchSettings(),
);

final todayPrayerRecordProvider = StreamProvider<PrayerRecord?>(
  (ref) => ref.watch(prayerRepositoryProvider).watchTodayEnsured(),
);

/// Today's calculated prayer times, or null when no location is set.
final todayPrayerTimesProvider = FutureProvider<DayPrayerTimes?>((ref) async {
  final settings = await ref.watch(prayerSettingsProvider.future);
  final lat = settings.latitude;
  final lng = settings.longitude;
  if (lat == null || lng == null) return null;
  return PrayerTimeCalculator.calculate(
    latitude: lat,
    longitude: lng,
    methodKey: settings.calculationMethod,
    madhabKey: settings.madhab,
    date: DateTime.now(),
    useManual: settings.useManual,
    manualOffsets:
        PrayerTimeCalculator.parseOffsets(settings.manualOffsetsJson),
  );
});

/// Consecutive full-fard days before today (resets to 0 on a miss).
final prayerStreakProvider = FutureProvider<int>((ref) async {
  final record = await ref.watch(todayPrayerRecordProvider.future);
  final repo = ref.watch(prayerRepositoryProvider);
  final today = record != null ? record.date : dateOnly(DateTime.now());
  return repo.fardStreak(today);
});

/// Writes record fields, then refreshes prayer scoring + notifications.
Future<void> savePrayerRecord(
  WidgetRef ref,
  int id,
  PrayerRecordsCompanion entry,
) async {
  final repo = ref.read(prayerRepositoryProvider);
  await repo.updateRecord(id, entry);
  final record = await repo.getOrCreateToday();
  await ref.read(scoreServiceProvider).recordPrayerDay(record.date);
  final settings = await repo.getSettings();
  await ref
      .read(prayerNotificationsProvider)
      .reschedule(settings: settings, now: DateTime.now());
}
