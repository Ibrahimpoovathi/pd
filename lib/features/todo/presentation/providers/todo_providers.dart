import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/core/notifications/notification_service.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/todo/data/todo_notifications.dart';
import 'package:pd/features/todo/data/todo_repository.dart';

final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(ref.watch(databaseProvider)),
);

final todoNotificationsProvider = Provider<TodoNotifications>(
  (ref) => TodoNotifications(ref.watch(notificationServiceProvider)),
);

/// All rows in [Todos], sorted incomplete-first (see repository).
final activeTodosProvider = StreamProvider<List<Todo>>(
  (ref) => ref.watch(todoRepositoryProvider).watchActive(),
);

final trashProvider = StreamProvider<List<TodoTrashData>>(
  (ref) => ref.watch(todoRepositoryProvider).watchTrash(),
);

final todoByIdProvider =
    StreamProvider.family.autoDispose<Todo?, int>(
  (ref, id) => ref.watch(todoRepositoryProvider).watchById(id),
);
