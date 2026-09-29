import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/providers.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/scoring/domain/score_service.dart';

final scoreServiceProvider = Provider<ScoreService>(
  (ref) => ScoreService(ref.watch(databaseProvider)),
);

/// Today's [DailyScore] row (null until the first scored event).
final todayScoreProvider = StreamProvider<DailyScore?>(
  (ref) => ref.watch(scoreServiceProvider).watchToday(),
);
