import 'package:flutter_test/flutter_test.dart';
import 'package:pd/features/scoring/domain/score_service.dart';
import 'package:pd/features/water/data/water_repository.dart';
import 'package:pd/features/water/presentation/screens/water_home_screen.dart';

import 'todo_test_utils.dart';

void main() {
  final env = TodoTestEnv();
  setUp(env.setUp);
  tearDown(env.tearDown);

  testWidgets('adding a cup updates ring, history and score',
      (tester) async {
    await tester.pumpWidget(env.scope(const WaterHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('ml of 2000'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // +250 default cup.
    await tester.tap(find.text('+250'));
    await tester.pumpAndSettle();
    expect(find.text('250'), findsOneWidget);

    // +500.
    await tester.tap(find.text('+500'));
    await tester.pumpAndSettle();
    expect(find.text('750'), findsOneWidget);

    // Undo removes one cup.
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('500'), findsOneWidget);

    // Score: 500 < 2000 goal -> 0.
    final db = env.db;
    expect((await ScoreService(db).todayRow())?.waterScore ?? 0, 0);

    // Reach the goal via repository, then score.
    final repo = WaterRepository(db, env.prefs);
    final updated = await repo.addMl(1500);
    await ScoreService(db).recordWaterDay(updated);
    expect((await ScoreService(db).todayRow())?.waterScore, 15);

    await disposeTree(tester);
  });
}
