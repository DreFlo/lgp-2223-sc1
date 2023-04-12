// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:src/pages/home_page.dart';
import 'package:src/utils/service_locator.dart';

import '../utils/service_locator_test_util.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    /*final mockPersonDao = serviceLocator.get<PersonDao>();
    when(mockPersonDao.findAllPersons()).thenAnswer((_) async => []);

    // Build our app and trigger a frame.
    // await tester.pumpWidget(HomePage(title: "Wokka"));
    // expect(find.text('Wokka'), findsOneWidget);

    // await tester.pump(const Duration(seconds: 10));
    //
    // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);
    //
    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pumpAndSettle(const Duration(seconds: 10));
    //
    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);*/
  });
}
