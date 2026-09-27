import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/storage/database.dart';

/// Provides the shared [AppDatabase] instance.
/// Overridden in `main()` after construction.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden in main()'),
);
