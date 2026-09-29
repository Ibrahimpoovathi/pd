import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/todo/presentation/providers/todo_providers.dart';
import 'package:pd/features/todo/presentation/widgets/todo_tile.dart';

/// Tabbed to-do home: All / Today / Tomorrow / Favorites / Trash.
///
/// Completed rows sink to a "Done" section instantly. When this screen is
/// left, completed rows are archived into the trash (date-grouped).
class TodoHomeScreen extends ConsumerStatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  ConsumerState<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends ConsumerState<TodoHomeScreen> {
  @override
  void deactivate() {
    // Leaving the to-do section: archive completed rows into the trash.
    // Fire-and-forget: the drift streams push the updated lists automatically,
    // so no manual provider invalidation (which would be unsafe here).
    unawaited(
      ref.read(todoRepositoryProvider).archiveCompleted(),
    );
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To-Do'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Today'),
              Tab(text: 'Tomorrow'),
              Tab(text: 'Favorites'),
              Tab(text: 'Trash'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TodoListTab(filter: _TodoFilter.all),
            _TodoListTab(filter: _TodoFilter.today),
            _TodoListTab(filter: _TodoFilter.tomorrow),
            _TodoListTab(filter: _TodoFilter.favorites),
            _TrashTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add to-do',
          onPressed: () => context.push('/todo/new'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

enum _TodoFilter { all, today, tomorrow, favorites }

class _TodoListTab extends ConsumerWidget {
  final _TodoFilter filter;

  const _TodoListTab({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(activeTodosProvider);
    return todos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load to-dos: $e')),
      data: (all) {
        final filtered = all.where(_matches).toList();
        final open = filtered.where((t) => !t.isCompleted).toList();
        final done = filtered.where((t) => t.isCompleted).toList();
        if (filtered.isEmpty) return Center(child: Text(_emptyHint()));
        return ListView(
          children: [
            for (final t in open) TodoTile(key: ValueKey(t.id), todo: t),
            if (done.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  'Done — moves to trash when you leave',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              for (final t in done) TodoTile(key: ValueKey(t.id), todo: t),
            ],
          ],
        );
      },
    );
  }

  bool _matches(Todo t) {
    switch (filter) {
      case _TodoFilter.all:
        return true;
      case _TodoFilter.today:
        return t.dueDate != null && isToday(t.dueDate!);
      case _TodoFilter.tomorrow:
        return t.dueDate != null && isTomorrow(t.dueDate!);
      case _TodoFilter.favorites:
        return t.isFavorite;
    }
  }

  String _emptyHint() {
    switch (filter) {
      case _TodoFilter.all:
        return 'Nothing here yet. Tap + to add your first to-do.';
      case _TodoFilter.today:
        return 'Nothing due today. Enjoy the calm — or tap + to plan.';
      case _TodoFilter.tomorrow:
        return 'Nothing due tomorrow yet.';
      case _TodoFilter.favorites:
        return 'Star a to-do to pin it here.';
    }
  }
}

class _TrashTab extends ConsumerStatefulWidget {
  const _TrashTab();

  @override
  ConsumerState<_TrashTab> createState() => _TrashTabState();
}

class _TrashTabState extends ConsumerState<_TrashTab> {
  @override
  void initState() {
    super.initState();
    // Auto-clear old trash on open (0 days = manual only).
    Future.microtask(() async {
      final prefs = ref.read(prefsProvider);
      final keepDays = prefs.getInt(PrefKeys.todoTrashKeepDays) ?? 7;
      final removed =
          await ref.read(todoRepositoryProvider).autoClearTrash(keepDays);
      if (removed > 0 && mounted) ref.invalidate(trashProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final trash = ref.watch(trashProvider);
    return trash.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load trash: $e')),
      data: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('Trash is empty.'));
        }
        final groups = <DateTime, List<TodoTrashData>>{};
        for (final r in rows) {
          final key = dateOnly(r.originalDueDate ?? r.deletedAt);
          (groups[key] ??= []).add(r);
        }
        final days = groups.keys.toList()
          ..sort((a, b) => b.compareTo(a));
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Clear all'),
                onPressed: () => _confirmClear(context, ref),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final day in days) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Text(
                        DateFormat('EEEE, d MMM yyyy').format(day),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    for (final r in groups[day]!)
                      ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(r.title),
                      ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear trash?'),
        content: const Text(
          'All trashed to-dos will be permanently deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(todoRepositoryProvider).clearTrash();
      ref.invalidate(trashProvider);
    }
  }
}
