import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/todo/presentation/providers/todo_providers.dart';

/// Create a new to-do ([todoId] == null) or edit an existing one.
class TodoDetailScreen extends ConsumerStatefulWidget {
  final int? todoId;

  const TodoDetailScreen({super.key, this.todoId});

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;
  int? _dueTimeMinutes;
  bool _isFavorite = false;
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final existing = widget.todoId == null
        ? null
        : ref.watch(todoByIdProvider(widget.todoId!));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoId == null ? 'New to-do' : 'Edit to-do'),
        actions: [
          if (widget.todoId != null)
            IconButton(
              tooltip: 'Delete permanently',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: existing == null
          ? _form(context, null)
          : existing.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Could not load: $e')),
              data: (todo) {
                if (todo == null) {
                  // Archived to trash while this screen was open.
                  return const Center(
                    child: Text('This task was completed and moved to trash.'),
                  );
                }
                if (!_loaded) {
                  _titleController.text = todo.title;
                  _descController.text = todo.description ?? '';
                  _dueDate = todo.dueDate;
                  _dueTimeMinutes = todo.dueTimeMinutes;
                  _isFavorite = todo.isFavorite;
                  _loaded = true;
                }
                return _form(context, todo.isCompleted);
              },
            ),
    );
  }

  Widget _form(BuildContext context, bool? isCompleted) {
    final dateLabel = _dueDate == null
        ? 'No date'
        : DateFormat('EEE, d MMM yyyy').format(_dueDate!);
    final timeLabel = _dueTimeMinutes == null
        ? 'No time'
        : formatMinutes(_dueTimeMinutes!);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'What needs doing?',
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descController,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_today_outlined),
          title: Text(dateLabel),
          trailing: _dueDate == null
              ? TextButton(
                  onPressed: _pickDate,
                  child: const Text('Set date'),
                )
              : TextButton(
                  onPressed: () => setState(() {
                    _dueDate = null;
                    _dueTimeMinutes = null;
                  }),
                  child: const Text('Clear'),
                ),
          onTap: _pickDate,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule_outlined),
          title: Text(timeLabel),
          subtitle: _dueDate == null
              ? const Text('Set a date first to add a time.')
              : null,
          trailing: _dueTimeMinutes == null
              ? TextButton(
                  onPressed: _dueDate == null ? null : _pickTime,
                  child: const Text('Set time'),
                )
              : TextButton(
                  onPressed: () =>
                      setState(() => _dueTimeMinutes = null),
                  child: const Text('Clear'),
                ),
          onTap: _dueDate == null ? null : _pickTime,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Favorite'),
          secondary: const Icon(Icons.star_border),
          value: _isFavorite,
          onChanged: (v) => setState(() => _isFavorite = v),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _saving ? null : () => _save(context),
          child: _saving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _dueDate = dateOnly(picked));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTimeMinutes == null
          ? TimeOfDay.now()
          : TimeOfDay(
              hour: _dueTimeMinutes! ~/ 60, minute: _dueTimeMinutes! % 60),
    );
    if (picked != null) {
      setState(
        () => _dueTimeMinutes = timeToMinutes(picked.hour, picked.minute),
      );
    }
  }

  Future<void> _save(BuildContext context) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please give your to-do a title.')),
      );
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(todoRepositoryProvider);
    final notifs = ref.read(todoNotificationsProvider);
    try {
      if (widget.todoId == null) {
        final id = await repo.create(
          title: title,
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          dueDate: _dueDate,
          dueTimeMinutes: _dueTimeMinutes,
          isFavorite: _isFavorite,
        );
        final created = await repo.getById(id);
        if (created != null) await notifs.scheduleFor(created);
      } else {
        await repo.update(
          id: widget.todoId!,
          title: title,
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          dueDate: _dueDate,
          dueTimeMinutes: _dueTimeMinutes,
          isFavorite: _isFavorite,
        );
        final updated = await repo.getById(widget.todoId!);
        if (updated != null) await notifs.scheduleFor(updated);
      }
      ref.invalidate(activeTodosProvider);
      if (context.mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete to-do?'),
        content: const Text(
          'This deletes the task permanently (it will not go to trash).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && widget.todoId != null) {
      await ref.read(todoNotificationsProvider).cancelFor(widget.todoId!);
      await ref.read(todoRepositoryProvider).delete(widget.todoId!);
      ref.invalidate(activeTodosProvider);
      if (context.mounted) context.pop();
    }
  }
}
