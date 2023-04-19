// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/utils/service_locator.dart';

import '../utils/service_locator_test_util.dart';

import 'package:src/daos/student/institution_dao.dart';

import 'package:mockito/mockito.dart';

class LocalizationsInjector extends StatelessWidget {
  final Widget child;
  const LocalizationsInjector({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Material(child: child),
    );
  }
}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  testWidgets('Create empty subject test', (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findAllInstitutions()).thenAnswer((_) async => []);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: SubjectForm(scrollController: ScrollController())));

    await widgetTester.pump(const Duration(seconds: 10));

    Finder saveButton = find.byKey(const Key('saveSubjectButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveSubjectButton'), skipOffstage: false));

    await widgetTester.pump(const Duration(seconds: 10));

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Acronym is required'), findsOneWidget);
    expect(find.text('Weight for Average is required'), findsOneWidget);
  });

  /*testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final mockPersonDao = serviceLocator.get<PersonDao>();
    when(mockPersonDao.findAllPersons()).thenAnswer((_) async => []);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    await tester.pump(const Duration(seconds: 10));
    //
    // // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    //
    // // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(const Duration(seconds: 10));
    //
    // // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/
}
