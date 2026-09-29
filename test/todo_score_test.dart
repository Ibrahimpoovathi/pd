import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/scoring/domain/score_service.dart';
import 'package:pd/features/todo/data/todo_repository.dart';

AppDatabase openTestDb() => AppDatabase(NativeDatabase.memory());

DateTime day(int y, int m, int d) => DateTime(y, m, d);

void main() {
  group('ScoreService.normalizeTotal', () {
    test('weights prayer 40 / todo 30 / screen 15 / water 15', () {
      // Full todo only: 0.3 * 100 = 30.
      expect(
        ScoreService.normalizeTotal(prayer: 0, todo: 100, screenTime: 0, water: 0),
        30,
      );
      // Everything maxed: 100.
      expect(
        ScoreService.normalizeTotal(
            prayer: 200, todo: 100, screenTime: 30, water: 30),
        100,
      );
      // All zero: 0.
      expect(
        ScoreService.normalizeTotal(prayer: 0, todo: 0, screenTime: 0, water: 0),
        0,
      );
      // Half prayer (100/200): 0.4 * 50 = 20.
      expect(
        ScoreService.normalizeTotal(prayer: 100, todo: 0, screenTime: 0, water: 0),
        20,
      );
      // Over-cap values clamp.
      expect(
        ScoreService.normalizeTotal(prayer: 9999, todo: 0, screenTime: 0, water: 0),
        40,
      );
    });
  });

  group('TodoRepository', () {
    late AppDatabase db;
    late TodoRepository repo;

    setUp(() {
      db = openTestDb();
      repo = TodoRepository(db);
    });

    tearDown(() => db.close());

    test('completed rows sink below open rows', () async {
      final a = await repo.create(title: 'first');
      final b = await repo.create(title: 'second');
      await repo.toggleComplete(a);
      final rows = await repo.watchActive().first;
      expect(rows.map((t) => t.id), [b, a]);
      expect(rows.last.isCompleted, isTrue);
    });

    test('archiveCompleted moves rows to trash with due date', () async {
      final id = await repo.create(title: 'done', dueDate: day(2026, 9, 20));
      await repo.toggleComplete(id);
      final archived = await repo.archiveCompleted();
      expect(archived, 1);

      final active = await repo.watchActive().first;
      expect(active, isEmpty);

      final trash = await repo.watchTrash().first;
      expect(trash, hasLength(1));
      expect(trash.single.title, 'done');
      expect(trash.single.originalDueDate, day(2026, 9, 20));
    });

    test('autoClearTrash respects keep days', () async {
      await db.into(db.todoTrash).insert(
            TodoTrashCompanion.insert(title: 'old', todoId: 1),
          );
      // Backdate the row 30 days.
      final row =
          await (db.select(db.todoTrash)).getSingle();
      await (db.update(db.todoTrash)..where((t) => t.id.equals(row.id)))
          .write(TodoTrashCompanion(
              deletedAt:
                  Value(DateTime.now().subtract(const Duration(days: 30)))));

      expect(await repo.autoClearTrash(7), 1);
      expect(await repo.watchTrash().first, isEmpty);

      // keepDays <= 0 removes nothing.
      await db.into(db.todoTrash).insert(
            TodoTrashCompanion.insert(title: 'kept', todoId: 2),
          );
      expect(await repo.autoClearTrash(0), 0);
      expect(await repo.watchTrash().first, hasLength(1));
    });
  });

  group('ScoreService.recordTodoCompletion', () {
    late AppDatabase db;
    late ScoreService scores;

    setUp(() {
      db = openTestDb();
      scores = ScoreService(db);
    });

    tearDown(() => db.close());

    test('base 10 points on time', () async {
      final now = day(2026, 9, 27);
      await scores.recordTodoCompletion(
        completedAt: now,
        overdue: false,
        now: now,
      );
      final row = await scores.todayRow(now);
      expect(row?.todoScore, 10);
      // 10/100 * 30 weight = 3.
      expect(row?.totalScore, 3);
    });

    test('overdue completion scores half', () async {
      final now = day(2026, 9, 27);
      await scores.recordTodoCompletion(
        completedAt: now,
        overdue: true,
        now: now,
      );
      expect((await scores.todayRow(now))?.todoScore, 5);
    });

    test('streak bonus +2 per prior active day, capped at +20', () async {
      final today = day(2026, 9, 27);
      // Seed 3 consecutive prior days with completions.
      for (var i = 1; i <= 3; i++) {
        await db.into(db.dailyScores).insert(
              DailyScoresCompanion.insert(
                date: today.subtract(Duration(days: i)),
                todoScore: const Value(10),
              ),
            );
      }
      await scores.recordTodoCompletion(
        completedAt: today,
        overdue: false,
        now: today,
      );
      // 10 base + 3*2 streak = 16.
      expect((await scores.todayRow(today))?.todoScore, 16);
    });

    test('broken streak gives no bonus', () async {
      final today = day(2026, 9, 27);
      await db.into(db.dailyScores).insert(
            DailyScoresCompanion.insert(
              date: today.subtract(const Duration(days: 2)),
              todoScore: const Value(10),
            ),
          );
      await scores.recordTodoCompletion(
        completedAt: today,
        overdue: false,
        now: today,
      );
      expect((await scores.todayRow(today))?.todoScore, 10);
    });

    test('daily cap of 100 holds', () async {
      final today = day(2026, 9, 27);
      for (var i = 0; i < 15; i++) {
        await scores.recordTodoCompletion(
          completedAt: today,
          overdue: false,
          now: today,
        );
      }
      expect((await scores.todayRow(today))?.todoScore, 100);
    });
  });
}
