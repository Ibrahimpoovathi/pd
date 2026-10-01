import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/scoring/domain/score_service.dart';
import 'package:pd/features/water/data/water_notifications.dart';
import 'package:pd/features/water/data/water_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<WaterRepository> openRepo() async {
  final db = AppDatabase(NativeDatabase.memory());
  addTearDown(db.close);
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return WaterRepository(db, prefs);
}

DateTime day(int y, int m, int d) => DateTime(y, m, d);

DateTime at(DateTime day, int minutes) =>
    DateTime(day.year, day.month, day.day, minutes ~/ 60, minutes % 60);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WaterNotifications.slotsFor', () {    test('even slots between wake and sleep, future only', () {
      final now = day(2026, 5, 1).add(const Duration(hours: 8));
      final slots = WaterNotifications.slotsFor(
        now: now,
        wakeMinutes: 7 * 60,
        sleepMinutes: 23 * 60,
        intervalMinutes: 120,
      );
      // 9,11,13,15,17,19,21.
      expect(slots.length, 7);
      expect(slots.first, at(day(2026, 5, 1), 9 * 60));
      expect(slots.last, at(day(2026, 5, 1), 21 * 60));
    });

    test('skips past slots, rejects bad config', () {
      final late = day(2026, 5, 1).add(const Duration(hours: 22));
      final slots = WaterNotifications.slotsFor(
        now: late,
        wakeMinutes: 7 * 60,
        sleepMinutes: 23 * 60,
        intervalMinutes: 120,
      );
      expect(slots, isEmpty);

      expect(
        WaterNotifications.slotsFor(
          now: late,
          wakeMinutes: 23 * 60,
          sleepMinutes: 7 * 60,
          intervalMinutes: 120,
        ),
        isEmpty,
      );
      expect(
        WaterNotifications.slotsFor(
          now: late,
          wakeMinutes: 7 * 60,
          sleepMinutes: 23 * 60,
          intervalMinutes: 0,
        ),
        isEmpty,
      );
    });
  });

  group('WaterRepository + scoring', () {
    test('addMl accumulates and clamps', () async {
      final repo = await openRepo();
      var rec = await repo.addMl(250);
      expect(rec.mlConsumed, 250);
      rec = await repo.addMl(500);
      expect(rec.mlConsumed, 750);
      rec = await repo.addMl(-1000);
      expect(rec.mlConsumed, 0);
      expect(repo.goalMl, 8 * 250);
    });

    test('goal met scores 15, streak adds +2/day', () async {
      final repo = await openRepo();
      final scores = ScoreService(repo.db);
      final today = day(2026, 9, 27);
      // Yesterday met.
      await repo.addMl(
          2000, today.subtract(const Duration(days: 1)));
      // Today met.
      await repo.addMl(2000, today);
      await scores.recordWaterDay(
          await repo.getOrCreateToday(today),
          now: today);
      final row = await scores.todayRow(today);
      // 15 + 1*2 = 17 → overall 0.15 * (17/30) * 100 = 8.5 → 9.
      expect(row?.waterScore, 17);
      expect(row?.totalScore, 9);
    });

    test('unmet goal scores 0 and breaks streak', () async {
      final repo = await openRepo();
      final scores = ScoreService(repo.db);
      final today = day(2026, 9, 27);
      await repo.getOrCreateToday(today); // 0 ml
      final t = await repo.getOrCreateToday(today);
      await scores.recordWaterDay(t, now: today);
      expect((await scores.todayRow(today))?.waterScore, 0);
      expect(await repo.goalStreak(today), 0);
    });
  });
}
