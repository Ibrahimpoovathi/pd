import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/prayer/data/prayer_repository.dart';
import 'package:pd/features/scoring/domain/score_service.dart';

AppDatabase openTestDb() => AppDatabase(NativeDatabase.memory());

DateTime day(int y, int m, int d) => DateTime(y, m, d);

Future<PrayerRecord> seedRecord(
  PrayerRepository repo,
  DateTime date, {
  bool allFard = false,
  PrayerRecordsCompanion extra = const PrayerRecordsCompanion(),
}) async {
  final rec = await repo.getOrCreateToday(date);
  var entry = extra;
  if (allFard) {
    entry = entry.copyWith(
      fajr: const Value(true),
      dhuhr: const Value(true),
      asr: const Value(true),
      maghrib: const Value(true),
      isha: const Value(true),
    );
  }
  await repo.updateRecord(rec.id, entry);
  return (await repo.recordOn(date))!;
}

void main() {
  group('recordPrayerDay scoring', () {
    late AppDatabase db;
    late PrayerRepository repo;
    late ScoreService scores;

    setUp(() {
      db = openTestDb();
      repo = PrayerRepository(db);
      scores = ScoreService(db);
    });

    tearDown(() => db.close());

    test('single fard = 15, mosque+jamaat bonuses need the fard', () async {
      final today = day(2026, 9, 27);
      await seedRecord(
        repo,
        today,
        extra: const PrayerRecordsCompanion(
          fajr: Value(true),
          fajrMosque: Value(true),
          fajrJamaat: Value(true),
          // Bonuses without the fard must not count.
          dhuhrMosque: Value(true),
        ),
      );
      await scores.recordPrayerDay(today, now: today);
      // 15 + 5 + 3 = 23.
      expect((await scores.todayRow(today))?.prayerScore, 23);
    });

    test('extras add up: tahajjud/duha/quran/adhkar/dhikr', () async {
      final today = day(2026, 9, 27);
      await seedRecord(
        repo,
        today,
        extra: const PrayerRecordsCompanion(
          tahajjud: Value(true), // 25
          duha: Value(true), // 15
          quranWaqiah: Value(true), // 20
          quranMulk: Value(true), // 20
          quranOtherPages: Value(5), // 10
          adhkarMorning: Value(true), // 10
          salatDone: Value(true),
          salatCount: Value(100), // 5 + 20 -> capped within 20
          isthighfarDone: Value(true), // 5 (no count)
        ),
      );
      await scores.recordPrayerDay(today, now: today);
      // 25+15+20+20+10+10+20+5 = 125.
      expect((await scores.todayRow(today))?.prayerScore, 125);
    });

    test('section caps at 200', () async {
      final today = day(2026, 9, 27);
      await seedRecord(
        repo,
        today,
        allFard: true,
        extra: const PrayerRecordsCompanion(
          tahajjud: Value(true),
          duha: Value(true),
          quranWaqiah: Value(true),
          quranMulk: Value(true),
          quranOtherPages: Value(50),
          adhkarMorning: Value(true),
          adhkarEvening: Value(true),
          salatDone: Value(true),
          salatCount: Value(1000),
          thahleelDone: Value(true),
          thahleelCount: Value(1000),
          isthighfarDone: Value(true),
          isthighfarCount: Value(1000),
        ),
      );
      // Seed a long streak for max bonus too.
      for (var i = 1; i <= 30; i++) {
        await seedRecord(repo, today.subtract(Duration(days: i)),
            allFard: true);
      }
      await scores.recordPrayerDay(today, now: today);
      expect((await scores.todayRow(today))?.prayerScore, 200);
    });

    test('qada earns 8 and breaks the streak', () async {
      final today = day(2026, 9, 27);
      await seedRecord(repo, today.subtract(const Duration(days: 1)),
          allFard: true);
      await seedRecord(
        repo,
        today,
        allFard: true,
        extra: const PrayerRecordsCompanion(fajrQada: Value(true)),
      );
      await scores.recordPrayerDay(today, now: today);
      // 4 ada * 15 + 1 qada * 8 = 68, +3 streak bonus from yesterday.
      expect((await scores.todayRow(today))?.prayerScore, 71);
      // Yesterday still counts (all ada); tomorrow the qada breaks it.
      expect(await repo.fardStreak(today), 1);
      expect(
        await repo.fardStreak(today.add(const Duration(days: 1))),
        0,
      );
    });

    test('streak bonus +3/day, miss resets to zero', () async {      final today = day(2026, 9, 27);
      // 2 full days, then a miss yesterday.
      await seedRecord(repo, today.subtract(const Duration(days: 3)),
          allFard: true);
      await seedRecord(repo, today.subtract(const Duration(days: 2)),
          allFard: true);
      await seedRecord(
        repo,
        today.subtract(const Duration(days: 1)),
        extra: const PrayerRecordsCompanion(fajr: Value(true)), // miss!
      );
      await seedRecord(repo, today, allFard: true);
      await scores.recordPrayerDay(today, now: today);
      // 5*15 = 75, no streak bonus (yesterday missed).
      expect((await scores.todayRow(today))?.prayerScore, 75);
      expect(await repo.fardStreak(today), 0);
    });

    test('past days do not touch today row', () async {
      final today = day(2026, 9, 27);
      final past = day(2026, 9, 20);
      await seedRecord(repo, past, allFard: true);
      await scores.recordPrayerDay(past, now: today);
      // Today's row may exist (created for streak/recalc bookkeeping)
      // but carries no prayer points from the past day.
      expect((await scores.todayRow(today))?.prayerScore ?? 0, 0);
    });
  });

  group('PrayerRepository settings', () {
    late AppDatabase db;
    late PrayerRepository repo;

    setUp(() {
      db = openTestDb();
      repo = PrayerRepository(db);
    });

    tearDown(() => db.close());

    test('defaults then update then resetManual', () async {
      var s = await repo.getSettings();
      expect(s.useManual, isFalse);
      expect(s.manualOffsetsJson, '{}');

      await repo.updateSettings(const PrayerSettingsCompanion(
        useManual: Value(true),
        manualOffsetsJson: Value('{"Fajr": 2}'),
        latitude: Value(11.25),
        longitude: Value(75.77),
      ));
      s = await repo.getSettings();
      expect(s.useManual, isTrue);
      expect(s.latitude, 11.25);

      await repo.resetManual();
      s = await repo.getSettings();
      expect(s.useManual, isFalse);
      expect(s.manualOffsetsJson, '{}');
      // Location kept.
      expect(s.latitude, 11.25);
    });
  });
}
