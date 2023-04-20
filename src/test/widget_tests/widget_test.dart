import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import '../utils/service_locator_test_util.dart';
import 'package:mockito/mockito.dart';
import '../utils/model_mocks_util.mocks.dart';
import 'widget_tests_utils.dart';

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

  testWidgets('Create subject with incorrect fields test',
      (WidgetTester widgetTester) async {
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

  testWidgets('Create subject test', (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findAllInstitutions()).thenAnswer((_) async => []);

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.insertSubject(MockSubject()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: SubjectForm(scrollController: ScrollController())));

    await widgetTester.pump(const Duration(seconds: 10));

    await widgetTester.enterText(find.byKey(const Key('nameField')), 'name');

    await widgetTester.enterText(
        find.byKey(const Key('acronymField')), 'acronym');

    await widgetTester.enterText(
        find.byKey(const Key('weightAverageField')), '1');

    await widgetTester.pumpAndSettle();

    expect(find.text('name'), findsOneWidget);
    expect(find.text('acronym'), findsOneWidget);
    expect(find.textContaining('1'), findsOneWidget);

    Finder saveButton = find.byKey(const Key('saveSubjectButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveSubjectButton'), skipOffstage: false));

    await widgetTester.pump(const Duration(seconds: 10));

    expect(find.text('Name is required'), findsNothing);
    expect(find.text('Acronym is required'), findsNothing);
    expect(find.text('Weight for Average is required'), findsNothing);
  });

  testWidgets('Load correct subject information test',
      (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findAllInstitutions()).thenAnswer((_) async => [
          Institution(name: 'inst_name', type: InstitutionType.other, userId: 1)
        ]);

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.insertSubject(MockSubject()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: SubjectForm(
            scrollController: ScrollController(),
            subject: Subject(
                name: 'sub_name',
                acronym: 'sub_acronym',
                weightAverage: 3,
                institutionId: 1))));

    await widgetTester.pump(const Duration(seconds: 10));

    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);
    expect(find.textContaining('3'), findsOneWidget);

    final dropdown = find.byKey(const Key('institutionField'));
    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(dropdown, 100, scrollable: scroll);
    await widgetTester.tap(dropdown);

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name').last, findsOneWidget);
  });

  testWidgets('Edit Subject test', (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findAllInstitutions()).thenAnswer((_) async => []);

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
        Subject(id: 1, name: 'name', acronym: 'acronym', weightAverage: 1)));

    when(mockSubjectDao.updateSubject(Subject(
            id: 1, name: 'sub_name', acronym: 'sub_acronym', weightAverage: 3)))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: SubjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);
    expect(find.textContaining('3'), findsNothing);

    await widgetTester.enterText(
        find.byKey(const Key('nameField')), 'sub_name');

    await widgetTester.enterText(
        find.byKey(const Key('acronymField')), 'sub_acronym');

    await widgetTester.enterText(
        find.byKey(const Key('weightAverageField')), '3');

    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);
    expect(find.textContaining('3'), findsOneWidget);

    Finder saveButton = find.byKey(const Key('saveSubjectButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveSubjectButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);
    expect(find.textContaining('3'), findsNothing);
  });

  testWidgets('Delete subject test', (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findAllInstitutions()).thenAnswer((_) async => []);

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
        Subject(
            id: 1,
            name: 'sub_name',
            acronym: 'sub_acronym',
            weightAverage: 3)));

    when(mockSubjectDao.deleteSubject(MockSubject()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: SubjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);
    expect(find.textContaining('3'), findsOneWidget);

    final deleteButton = find.byKey(const Key('deleteSubjectButton'));
    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(deleteButton, 100,
        scrollable: scroll);
    await widgetTester.tap(deleteButton);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('cancelDeleteSubjectButton')), findsOneWidget);
    expect(find.byKey(const Key('deleteSubjectConfirmationButton')),
        findsOneWidget);

    await widgetTester
        .tap(find.byKey(const Key('deleteSubjectConfirmationButton')));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);
    expect(find.textContaining('3'), findsNothing);
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
