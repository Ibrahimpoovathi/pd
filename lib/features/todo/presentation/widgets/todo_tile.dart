import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/scoring/presentation/providers/score_providers.dart';
import 'package:pd/features/todo/presentation/providers/todo_providers.dart';

/// One row in a to-do list: checkbox, title, due info, favorite star.
class TodoTile extends ConsumerWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = _subtitle(todo);

    return Opacity(
      opacity: todo.isCompleted ? 0.55 : 1.0,
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => _toggle(ref),
        ),
        title: Text(
          todo.title,
          style: todo.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: subtitle == null ? null : Text(subtitle),
        trailing: IconButton(
          tooltip: todo.isFavorite ? 'Unfavorite' : 'Favorite',
          icon: Icon(
            todo.isFavorite ? Icons.star : Icons.star_border,
            color: todo.isFavorite ? scheme.primary : null,
          ),
          onPressed: () => ref
              .read(todoRepositoryProvider)
              .setFavorite(todo.id, !todo.isFavorite),
        ),
        onTap: () => context.push('/todo/${todo.id}'),
      ),
    );
  }

  String? _subtitle(Todo todo) {
    final parts = <String>[];
    if (todo.dueDate != null) {
      parts.add(DateFormat('EEE, d MMM').format(todo.dueDate!));
      if (todo.dueTimeMinutes != null) {
        parts.add(formatMinutes(todo.dueTimeMinutes!));
      }
    }
    if (todo.description != null && todo.description!.isNotEmpty) {
      parts.add(todo.description!);
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Future<void> _toggle(WidgetRef ref) async {
    final repo = ref.read(todoRepositoryProvider);
    final updated = await repo.toggleComplete(todo.id);
    if (updated == null) return;
    final notifs = ref.read(todoNotificationsProvider);
    if (updated.isCompleted) {
      await notifs.cancelFor(updated.id);
      final due = updated.dueDate;
      final overdue = due != null &&
          dateOnly(DateTime.now()).isAfter(dateOnly(due));
      await ref.read(scoreServiceProvider).recordTodoCompletion(
            completedAt: DateTime.now(),
            overdue: overdue,
          );
    } else {
      // Re-arm reminders when a task is un-completed.
      await notifs.scheduleFor(updated);
    }
  }
}
