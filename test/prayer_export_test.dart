import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';import 'package:pd/core/storage/database.dart';
import 'package:pd/features/prayer/data/prayer_history_export.dart';
import 'package:pd/features/prayer/data/prayer_repository.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:pd/features/scoring/domain/score_service.dart';

import 'todo_test_utils.dart';

void main() {
  // Plain tests using TodoTestEnv need the tester binding for channel mocks.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('cell codes', () {
    test('prayerCell marks ada/qada/miss + jamaat/mosque', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = PrayerRepository(db);
      final rec = await repo.getOrCreateToday(DateTime(2026, 5, 1));
      // Empty record: all missed.
      expect(prayerCell(rec, PrayerName.fajr), '-');
      expect(adhkarCell(rec), '-');

      await repo.updateRecord(
        rec.id,
        const PrayerRecordsCompanion(
          fajr: Value(true),
          fajrJamaat: Value(true),
          dhuhr: Value(true),
          dhuhrMosque: Value(true),
          asr: Value(true),
          asrQada: Value(true),
          adhkarMorning: Value(true),
          adhkarEvening: Value(true),
        ),
      );
      final updated = await repo.recordOn(DateTime(2026, 5, 1));
      expect(prayerCell(updated, PrayerName.fajr), 'vj');
      expect(prayerCell(updated, PrayerName.dhuhr), 'vm');
      expect(prayerCell(updated, PrayerName.asr), 'Q');
      expect(prayerCell(updated, PrayerName.maghrib), '-');
      expect(adhkarCell(updated), 'ME');
      expect(adhkarCell(null), '-');
    });

    test('HistoryDay status mapping', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = PrayerRepository(db);
      final day = DateTime(2026, 5, 2);
      expect(
        HistoryDay(date: day, record: null, points: 0).status,
        HistoryStatus.none,
      );
      var rec = await repo.getOrCreateToday(day);
      expect(
        HistoryDay(date: day, record: rec, points: 0).status,
        HistoryStatus.none,
      );
      await repo.updateRecord(
        rec.id,
        const PrayerRecordsCompanion(fajr: Value(true)),
      );
      rec = (await repo.recordOn(day))!;
      expect(
        HistoryDay(date: day, record: rec, points: 0).status,
        HistoryStatus.partial,
      );
    });
  });

  group('recordsBetween + PDF', () {
    test('range query inclusive, pdf non-empty', () async {
      final env = TodoTestEnv();
      await env.setUp();
      addTearDown(env.tearDown);
      final repo = PrayerRepository(env.db);
      final base = DateTime(2026, 4, 10);
      await repo.getOrCreateToday(base);
      await repo.getOrCreateToday(base.add(const Duration(days: 2)));

      final rows = await repo.recordsBetween(
          base, base.add(const Duration(days: 2)));
      expect(rows.length, 2);
      final narrow =
          await repo.recordsBetween(base, base.add(const Duration(days: 1)));
      expect(narrow.length, 1);

      final scores = ScoreService(env.db);
      final days = <HistoryDay>[];
      var cursor = base;
      final end = base.add(const Duration(days: 2));
      while (!cursor.isAfter(end)) {
        days.add(HistoryDay(
          date: cursor,
          record: await repo.recordOn(cursor),
          points: await scores.prayerScoreOn(cursor),
        ));
        cursor = cursor.add(const Duration(days: 1));
      }
      final bytes =
          await buildPrayerHistoryPdf(days: days, from: base, to: end);
      expect(bytes.isNotEmpty, isTrue);
    });
  });
}
