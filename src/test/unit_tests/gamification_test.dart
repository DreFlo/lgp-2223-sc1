import 'package:flutter_test/flutter_test.dart';
import 'package:src/database/database.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';

void main() {
  setUp(() async {
    await setup(testing: true);
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator<AppDatabase>().close();
  });

  testWidgets('Get the level user is going to level up to',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      int level = getLevel(2260, 1);
      expect(level, 10);
    });
  });
}
