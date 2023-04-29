import 'package:flutter_test/flutter_test.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/tasks/evaluation_bar.dart';
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

    await widgetTester.pumpAndSettle();

    expect(find.text('name'), findsOneWidget);
    expect(find.text('acronym'), findsOneWidget);

    Finder saveButton = find.byKey(const Key('saveSubjectButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveSubjectButton'), skipOffstage: false));

    await widgetTester.pump(const Duration(seconds: 10));

    expect(find.text('Name is required'), findsNothing);
    expect(find.text('Acronym is required'), findsNothing);
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
                name: 'sub_name', acronym: 'sub_acronym', institutionId: 1))));

    await widgetTester.pump(const Duration(seconds: 10));

    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);

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
    when(mockSubjectDao.findSubjectById(1))
        .thenAnswer((_) => Stream.value(Subject(
              id: 1,
              name: 'name',
              acronym: 'acronym',
            )));

    when(mockSubjectDao.updateSubject(
            Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: SubjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);

    await widgetTester.enterText(
        find.byKey(const Key('nameField')), 'sub_name');

    await widgetTester.enterText(
        find.byKey(const Key('acronymField')), 'sub_acronym');

    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);

    Finder saveButton = find.byKey(const Key('saveSubjectButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveSubjectButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);
  });

  testWidgets('Delete subject test', (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findAllInstitutions()).thenAnswer((_) async => []);

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) =>
        Stream.value(Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')));

    when(mockSubjectDao.deleteSubject(MockSubject()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: SubjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);

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
  });

  group("Evaluation tests", () {
    testWidgets("Add evaluation test", (WidgetTester widgetTester) async {
      final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
      when(mockInstitutionDao.findAllInstitutions())
          .thenAnswer((_) async => []);

      await widgetTester.pumpWidget(LocalizationsInjector(
          child: SubjectForm(scrollController: ScrollController())));

      await widgetTester.pumpAndSettle();

      expect(find.text("You have no evaluations... yet!"), findsOneWidget);
      Finder addEvaluationButton = find.byKey(const Key('addEvaluationButton'));
      Finder scroll = find.byType(Scrollable).last;

      await widgetTester.scrollUntilVisible(addEvaluationButton, 100,
          scrollable: scroll);
      await widgetTester.tap(addEvaluationButton);

      await widgetTester.pumpAndSettle();
      //Opened evaluation form

      String evaluationName = 'evaluation_name';
      String evaluationGrade = '3';
      await widgetTester.enterText(
          find.byKey(const Key('nameEvaluationField')), evaluationName);
      await widgetTester.enterText(
          find.byKey(const Key('gradeEvaluationField')), evaluationGrade);
      final saveButton = find.byKey(const Key('saveEvaluationButton'));

      Finder scrollable = find.byType(Scrollable).last;

      await widgetTester.scrollUntilVisible(saveButton, 100,
          scrollable: scrollable);

      await widgetTester.tap(saveButton);

      await widgetTester.pumpAndSettle();
      //Saved and closed evaluation form

      expect(find.text(evaluationName), findsOneWidget);
      expect(find.textContaining(evaluationGrade), findsOneWidget);
      expect(find.text("You have no evaluations... yet!"), findsNothing);
    });

    testWidgets("Load evaluation test", (WidgetTester widgetTester) async {
      final mockSubjectDao = serviceLocator.get<SubjectDao>();
      when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
          Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')));

      final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
      when(mockInstitutionDao.findAllInstitutions())
          .thenAnswer((_) async => []);

      String evaluationName = 'evaluation_name';
      double evaluationGrade = 3.0;
      final mockStudentEvaluationDao =
          serviceLocator.get<StudentEvaluationDao>();
      when(mockStudentEvaluationDao.findStudentEvaluationsBySubjectId(1))
          .thenAnswer((_) async => [
                StudentEvaluation(
                    id: 1,
                    name: evaluationName,
                    grade: evaluationGrade,
                    subjectId: 1)
              ]);
      await widgetTester.pumpWidget(LocalizationsInjector(
          child: SubjectForm(id: 1, scrollController: ScrollController())));

      await widgetTester.pumpAndSettle();

      expect(find.text("You have no evaluations... yet!"), findsNothing);
      expect(find.text(evaluationName), findsOneWidget);
      expect(find.textContaining(evaluationGrade.toString()), findsOneWidget);
    });
    testWidgets("Edit evaluation test", (WidgetTester widgetTester) async {
      final mockSubjectDao = serviceLocator.get<SubjectDao>();
      when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
          Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')));

      final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
      when(mockInstitutionDao.findAllInstitutions())
          .thenAnswer((_) async => []);

      String evaluationName = 'evaluation_name';
      double evaluationGrade = 3.0;
      StudentEvaluation evaluation = StudentEvaluation(
          id: 1, name: evaluationName, grade: evaluationGrade, subjectId: 1);
      final mockStudentEvaluationDao =
          serviceLocator.get<StudentEvaluationDao>();
      when(mockStudentEvaluationDao.findStudentEvaluationsBySubjectId(1))
          .thenAnswer((_) async => [evaluation]);
      await widgetTester.pumpWidget(LocalizationsInjector(
          child: SubjectForm(id: 1, scrollController: ScrollController())));

      await widgetTester.pumpAndSettle();
      Finder addEvaluationButton = find.descendant(
          of: find.byType(EvaluationBar), matching: find.byType(InkWell));
      Finder scroll = find.byType(Scrollable).last;

      await widgetTester.scrollUntilVisible(addEvaluationButton, 100,
          scrollable: scroll);
      await widgetTester.tap(addEvaluationButton);

      await widgetTester.pumpAndSettle();
      //Opened evaluation form

      String newEvaluationName = 'new_evaluation_name';
      String newEvaluationGrade = '4.0';

      await widgetTester.enterText(
          find.byKey(const Key('nameEvaluationField')), newEvaluationName);
      await widgetTester.enterText(
          find.byKey(const Key('gradeEvaluationField')), newEvaluationGrade);
      final saveButton = find.byKey(const Key('saveEvaluationButton'));

      Finder scrollable = find.byType(Scrollable).last;

      await widgetTester.scrollUntilVisible(saveButton, 100,
          scrollable: scrollable);

      await widgetTester.tap(saveButton);

      await widgetTester.pumpAndSettle();
      //Saved and closed evaluation form

      expect(find.text(newEvaluationName), findsOneWidget);
      expect(find.textContaining(newEvaluationGrade), findsOneWidget);
      expect(find.text(evaluationName), findsNothing);
      expect(find.textContaining(evaluationGrade.toString()), findsNothing);
      expect(find.text("You have no evaluations... yet!"), findsNothing);
    });

    testWidgets("Delete evaluation test", (WidgetTester widgetTester) async {
      final mockSubjectDao = serviceLocator.get<SubjectDao>();
      when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
          Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')));

      final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
      when(mockInstitutionDao.findAllInstitutions())
          .thenAnswer((_) async => []);

      String evaluationName = 'evaluation_name';
      double evaluationGrade = 3.0;

      final mockStudentEvaluationDao =
          serviceLocator.get<StudentEvaluationDao>();
      when(mockStudentEvaluationDao.findStudentEvaluationsBySubjectId(1))
          .thenAnswer((_) async => [
                StudentEvaluation(
                    id: 1,
                    name: evaluationName,
                    grade: evaluationGrade,
                    subjectId: 1)
              ]);
      when(mockStudentEvaluationDao
              .deleteStudentEvaluation(MockStudentEvaluation()))
          .thenAnswer((_) async => 1);

      await widgetTester.pumpWidget(LocalizationsInjector(
          child: SubjectForm(id: 1, scrollController: ScrollController())));

      await widgetTester.pumpAndSettle();

      Finder deleteEvaluationButton = find.byIcon(Icons.close).last;

      Finder scrollable = find.byType(Scrollable).last;

      await widgetTester.scrollUntilVisible(deleteEvaluationButton, 100,
          scrollable: scrollable);

      await widgetTester.tap(deleteEvaluationButton);
      await widgetTester.pumpAndSettle();
      Finder deleteConfirmationButton =
          find.byKey(const Key("deleteConfirmationButton"));

      scrollable = find.byType(Scrollable).last;

      await widgetTester.scrollUntilVisible(deleteConfirmationButton, 100,
          scrollable: scrollable);

      await widgetTester.tap(deleteConfirmationButton);
      await widgetTester.pumpAndSettle();

      expect(find.text("You have no evaluations... yet!"), findsOneWidget);
      expect(find.text(evaluationName), findsNothing);
      expect(find.textContaining(evaluationGrade.toString()), findsNothing);
    });
  });
}
