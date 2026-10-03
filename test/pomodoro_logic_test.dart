import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/pomodoro/data/pomodoro_repository.dart';

AppDatabase openTestDb() => AppDatabase(NativeDatabase.memory());

DateTime day(int y, int m, int d) => DateTime(y, m, d);

void main() {
  group('PomodoroRepository', () {
    late AppDatabase db;
    late PomodoroRepository repo;

    setUp(() {
      db = openTestDb();
      repo = PomodoroRepository(db);
    });

    tearDown(() => db.close());

    test('getAllPresets returns default presets', () async {
      await repo.ensureDefaultPresets();
      final presets = await repo.getAllPresets();
      expect(presets.length, greaterThanOrEqualTo(3));
      expect(presets.any((p) => p.name == 'Standard'), isTrue);
      expect(presets.any((p) => p.name == 'Deep Work'), isTrue);
      expect(presets.any((p) => p.name == 'Quick'), isTrue);
    });

    test('createPreset adds custom preset', () async {
      final id = await repo.createPreset(
        name: 'Custom',
        workMinutes: 30,
        shortBreakMinutes: 5,
        longBreakMinutes: 10,
        totalCycles: 4,
        isCustom: true,
      );
      expect(id, greaterThan(0));
      final preset = await repo.getPreset(id);
      expect(preset?.name, 'Custom');
      expect(preset?.workMinutes, 30);
      expect(preset?.totalCycles, 4);
    });

    test('updatePreset modifies existing', () async {
      final id = await repo.createPreset(
        name: 'Test',
        workMinutes: 20,
        shortBreakMinutes: 3,
        longBreakMinutes: 10,
        totalCycles: 4,
        isCustom: true,
      );
      await repo.updatePreset(
        id: id,
        name: 'Updated',
        workMinutes: 30,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        totalCycles: 5,
      );
      final updated = await repo.getPreset(id);
      expect(updated?.name, 'Updated');
      expect(updated?.workMinutes, 30);
      expect(updated?.totalCycles, 5);
    });

    test('deletePreset removes custom preset', () async {
      final id = await repo.createPreset(
        name: 'ToDelete',
        workMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        totalCycles: 4,
        isCustom: true,
      );
      await repo.deletePreset(id);
      expect(await repo.getPreset(id), isNull);
    });
  });

  group('PomodoroRepository sessions', () {
    late AppDatabase db;
    late PomodoroRepository repo;

    setUp(() {
      db = openTestDb();
      repo = PomodoroRepository(db);
    });

    tearDown(() => db.close());

    test('getOrCreateToday creates record', () async {
      final today = DateTime(2026, 9, 27);
      final rec = await repo.getOrCreateToday(today);
      expect(rec.date, DateTime(2026, 9, 27));
      expect(rec.completedWorkSessions, 0);
      expect(rec.totalFocusMinutes, 0);
    });

    test('updateSession increments counters', () async {
      final today = DateTime(2026, 9, 27);
      final rec = await repo.getOrCreateToday(today);
      await repo.updateSession(
        id: rec.id,
        completedWorkSessions: 1,
        totalFocusMinutes: 25,
      );
      final updated = await repo.recordOn(today);
      expect(updated?.completedWorkSessions, 1);
      expect(updated?.totalFocusMinutes, 25);
    });

    test('focusStreak counts consecutive days', () async {
      final today = DateTime(2026, 9, 27);
      // Seed 3 consecutive days
      for (var i = 3; i >= 1; i--) {
        final rec = await repo.getOrCreateToday(today.subtract(Duration(days: i)));
        await repo.updateSession(
          id: rec.id,
          completedWorkSessions: 1,
          totalFocusMinutes: 25,
        );
      }
      // Today has no session yet
      final streak = await repo.focusStreak(today);
      expect(streak, 3);

      // Miss today
      final streak2 = await repo.focusStreak(today.add(const Duration(days: 1)));
      expect(streak2, 0);
    });
  });
}
