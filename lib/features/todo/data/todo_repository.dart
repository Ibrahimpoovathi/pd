import 'package:drift/drift.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/utils/date_helpers.dart';

/// Data access for to-dos and the to-do trash.
///
/// Active rows live in [Todos] (completed rows sink to the bottom of lists).
/// [archiveCompleted] moves completed rows into [TodoTrash], grouped by date.
class TodoRepository {
  final AppDatabase _db;

  TodoRepository(this._db);

  /// All rows in [Todos], sorted: incomplete first (by due date/time),
  /// completed last (most recently completed first).
  Stream<List<Todo>> watchActive() {
    return _db.select(_db.todos).watch().map(_sortActive);
  }

  Future<List<Todo>> pendingWithDueDate() {
    return (_db.select(_db.todos)
          ..where((t) => t.dueDate.isNotNull() & t.isCompleted.equals(false)))
        .get();
  }

  Future<Todo?> getById(int id) {
    return (_db.select(_db.todos)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<Todo?> watchById(int id) {
    return (_db.select(_db.todos)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<int> create({
    required String title,
    String? description,
    DateTime? dueDate,
    int? dueTimeMinutes,
    bool isFavorite = false,
  }) {
    return _db.into(_db.todos).insert(
          TodosCompanion.insert(
            title: title,
            description: Value(description),
            dueDate: Value(dueDate == null ? null : dateOnly(dueDate)),
            dueTimeMinutes: Value(dueTimeMinutes),
            isFavorite: Value(isFavorite),
          ),
        );
  }

  Future<void> update({
    required int id,
    required String title,
    String? description,
    DateTime? dueDate,
    int? dueTimeMinutes,
    required bool isFavorite,
  }) {
    return (_db.update(_db.todos)..where((t) => t.id.equals(id))).write(
      TodosCompanion(
        title: Value(title),
        description: Value(description),
        dueDate: Value(dueDate == null ? null : dateOnly(dueDate)),
        dueTimeMinutes: Value(dueTimeMinutes),
        isFavorite: Value(isFavorite),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.todos)..where((t) => t.id.equals(id))).go();
  }

  /// Toggles completion. Returns the updated row, or null if missing.
  /// Sets [Todo.completedAt]; clears it when un-completing.
  Future<Todo?> toggleComplete(int id) async {
    final current = await getById(id);
    if (current == null) return null;
    final now = DateTime.now();
    final completed = !current.isCompleted;
    await (_db.update(_db.todos)..where((t) => t.id.equals(id))).write(
      TodosCompanion(
        isCompleted: Value(completed),
        completedAt: Value(completed ? now : null),
        updatedAt: Value(now),
      ),
    );
    return (await getById(id))!;
  }

  Future<void> setFavorite(int id, bool favorite) {
    return (_db.update(_db.todos)..where((t) => t.id.equals(id))).write(
      TodosCompanion(
        isFavorite: Value(favorite),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Moves every completed row into [TodoTrash]. Returns the archived count.
  Future<int> archiveCompleted() async {
    final done = await (_db.select(_db.todos)
          ..where((t) => t.isCompleted.equals(true)))
        .get();
    if (done.isEmpty) return 0;
    await _db.transaction(() async {
      for (final t in done) {
        await _db.into(_db.todoTrash).insert(
              TodoTrashCompanion.insert(
                todoId: t.id,
                title: t.title,
                originalDueDate: Value(t.dueDate),
              ),
            );
      }
      await (_db.delete(_db.todos)
            ..where((t) => t.isCompleted.equals(true)))
          .go();
    });
    return done.length;
  }

  Stream<List<TodoTrashData>> watchTrash() {
    return (_db.select(_db.todoTrash)
          ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]))
        .watch();
  }

  Future<void> clearTrash() => _db.delete(_db.todoTrash).go();

  /// Deletes trash rows older than [keepDays]. Returns the removed count.
  /// [keepDays] <= 0 means manual-only (removes nothing).
  Future<int> autoClearTrash(int keepDays) {
    if (keepDays <= 0) return Future.value(0);
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    return (_db.delete(_db.todoTrash)
          ..where((t) => t.deletedAt.isSmallerThanValue(cutoff)))
        .go();
  }
}

List<Todo> _sortActive(List<Todo> rows) {
  final open = rows.where((t) => !t.isCompleted).toList()
    ..sort(_compareOpen);
  final done = rows.where((t) => t.isCompleted).toList()
    ..sort((a, b) => (b.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
  return [...open, ...done];
}

int _compareOpen(Todo a, Todo b) {
  if (a.dueDate == null && b.dueDate != null) return 1;
  if (a.dueDate != null && b.dueDate == null) return -1;
  if (a.dueDate != null && b.dueDate != null) {
    final c = a.dueDate!.compareTo(b.dueDate!);
    if (c != 0) return c;
    final ta = a.dueTimeMinutes ?? (24 * 60 + 1);
    final tb = b.dueTimeMinutes ?? (24 * 60 + 1);
    final tc = ta.compareTo(tb);
    if (tc != 0) return tc;
  }
  return b.id.compareTo(a.id); // newest first when no dates
}
