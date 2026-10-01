import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/features/scoring/presentation/providers/score_providers.dart';
import 'package:pd/features/water/data/water_notifications.dart';
import 'package:pd/features/water/data/water_repository.dart';

final waterRepositoryProvider = Provider<WaterRepository>(
  (ref) => WaterRepository(
    ref.watch(databaseProvider),
    ref.watch(prefsProvider),
  ),
);

final waterNotificationsProvider = Provider<WaterNotifications>(
  (ref) => WaterNotifications(ref.watch(notificationServiceProvider)),
);

final todayWaterProvider = StreamProvider<WaterRecord?>(
  (ref) => ref.watch(waterRepositoryProvider).watchTodayEnsured(),
);

/// Last 7 days, oldest first (missing days omitted).
final weekWaterProvider = FutureProvider<List<WaterRecord>>((ref) async {
  final rows =
      await ref.watch(waterRepositoryProvider).lastDays(7);
  return rows.reversed.toList();
});

final waterStreakProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(waterRepositoryProvider);
  final record = await ref.watch(todayWaterProvider.future);
  final today = record?.date ?? DateTime.now();
  return repo.goalStreak(today);
});

/// Adds [ml], refreshes water scoring, and re-arms reminders.
Future<void> addWater(WidgetRef ref, int ml) async {
  final repo = ref.read(waterRepositoryProvider);
  final updated = await repo.addMl(ml);
  await ref.read(scoreServiceProvider).recordWaterDay(updated);
  await ref
      .read(waterNotificationsProvider)
      .reschedule(repo);
}
