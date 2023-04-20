import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/service_locator.dart';
import '../../../utils/service_locator_test_util.dart';
import 'package:flutter/material.dart';
import 'package:src/utils/enums.dart';
import 'package:mockito/mockito.dart';
import '../../../utils/model_mocks_util.mocks.dart';
import '../../widget_tests_utils.dart';

import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';

import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';

import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/pages/tasks/institution_form.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('Create institution with incorrect fields test',
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController())));

    await widgetTester.pumpAndSettle();

    Finder saveButton = find.byKey(const Key('saveButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
  });

  testWidgets('Create institution normally test',
      (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();

    when(mockInstitutionDao.insertInstitution(MockInstitution()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController())));

    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(
        find.byKey(const Key('institutionNameField')), 'inst_name');

    expect(find.text('inst_name'), findsOneWidget);

    Finder saveButton = find.byKey(const Key('saveButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name'), findsNothing);
  });
}
