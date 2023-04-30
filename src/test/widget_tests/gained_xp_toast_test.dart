// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/pages/gamification/gained_xp_toast.dart';
import 'package:src/utils/service_locator.dart';

import '../utils/locations_injector.dart';
import '../utils/service_locator_test_util.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  testWidgets('XP Gain Toast', (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findAllInstitutions()).thenAnswer((_) async => []);

    await widgetTester.pumpWidget(const LocalizationsInjector(
        child: GainedXPToast(value: 10, level: 1, points: 20)));

    await widgetTester.pump(const Duration(seconds: 10));


    await widgetTester.pump(const Duration(seconds: 10));

    expect(find.text('You gained XP!'), findsOneWidget);
    expect(find.text('LEVEL 1'), findsOneWidget);
    expect(find.text('+ 20'), findsOneWidget);
  });
}
