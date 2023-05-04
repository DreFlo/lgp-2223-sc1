import 'package:flutter_test/flutter_test.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/task_note.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/institution_show.dart';
import 'package:src/pages/tasks/project_show.dart';
import 'package:src/pages/tasks/subject_show.dart';
import 'package:src/pages/tasks/task_show.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import '../../../utils/service_locator_test_util.dart';
import 'package:flutter/material.dart';
import '../../widget_tests_utils.dart';
import 'package:mockito/mockito.dart';

void callback() {}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('Load institution show correctly test',
      (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1, name: 'inst_name', type: InstitutionType.other, userId: 1)));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectByInstitutionId(1)).thenAnswer((_) async =>
        [Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')]);

    await widgetTester.pumpWidget(LocalizationsInjector(
      child: InstitutionShow(
          scrollController: ScrollController(), id: 1, callback: callback),
    ));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);
  });

  testWidgets('Load institution show from subject show test',
      (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1,
            name: 'inst_name',
            type: InstitutionType.education,
            userId: 1)));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectByInstitutionId(1)).thenAnswer((_) async => [
          Subject(
              id: 1, name: 'sub_name', acronym: 'sub_acronym', institutionId: 1)
        ]);
    when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
        Subject(
            id: 1,
            name: 'sub_name',
            acronym: 'sub_acronym',
            institutionId: 1)));

    final studentEvaluationDao = serviceLocator.get<StudentEvaluationDao>();
    when(studentEvaluationDao.findStudentEvaluationsBySubjectId(1)).thenAnswer(
        (_) async =>
            [StudentEvaluation(name: 'eval_name', grade: 1.1, subjectId: 1)]);

    await widgetTester.pumpWidget(LocalizationsInjector(
      child: SubjectShow(
          scrollController: ScrollController(), id: 1, callback: callback),
    ));

    await widgetTester.pumpAndSettle();

    Finder institutionShow = find.byKey(const Key('institutionShow'));
    expect(institutionShow, findsOneWidget);

    await widgetTester.tap(institutionShow);
    await widgetTester.pumpAndSettle();

    expect(find.text('Education'), findsWidgets);
  });

  testWidgets('Load institution show from project show test',
      (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1,
            name: 'inst_name',
            type: InstitutionType.education,
            userId: 1)));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
        Subject(
            id: 1,
            name: 'sub_name',
            acronym: 'sub_acronym',
            institutionId: 1)));

    final mockTaskDao = serviceLocator.get<TaskDao>();
    when(mockTaskDao.findTasksByTaskGroupId(1)).thenAnswer((_) async => []);

    await widgetTester.pumpWidget(LocalizationsInjector(
      child: ProjectShow(
          scrollController: ScrollController(),
          taskGroup: TaskGroup(
              id: 1,
              name: 'project_name',
              description: 'project_description',
              priority: Priority.high,
              deadline: DateTime.now(),
              subjectId: 1)),
    ));

    await widgetTester.pumpAndSettle();

    Finder institutionShow = find.byKey(const Key('institutionShow'));
    expect(institutionShow, findsOneWidget);

    await widgetTester.tap(institutionShow);
    await widgetTester.pumpAndSettle();

    expect(find.text('Education'), findsWidgets);
  });

  testWidgets('Load institution from task show test',
      (WidgetTester widgetTester) async {
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1,
            name: 'inst_name',
            type: InstitutionType.education,
            userId: 1)));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectByInstitutionId(1)).thenAnswer((_) async =>
        [Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')]);
    when(mockSubjectDao.findSubjectById(1)).thenAnswer((_) => Stream.value(
        Subject(
            id: 1,
            name: 'sub_name',
            acronym: 'sub_acronym',
            institutionId: 1)));

    final mockTaskGroupDao = serviceLocator.get<TaskGroupDao>();
    when(mockTaskGroupDao.findTaskGroupById(1)).thenAnswer((_) => Stream.value(
        TaskGroup(
            id: 1,
            name: 'project_name',
            description: 'project_description',
            priority: Priority.high,
            deadline: DateTime.now(),
            subjectId: 1)));

    final mockTaskNoteDao = serviceLocator.get<TaskNoteDao>();
    when(mockTaskNoteDao.findTaskNotesByTaskId(1))
        .thenAnswer((_) async => [TaskNote(id: 1, taskId: 1)]);

    final mockNoteDao = serviceLocator.get<NoteDao>();
    when(mockNoteDao.findNoteById(1)).thenAnswer((_) => Stream.value(Note(
        title: 'note_title',
        content: 'note_content',
        date: DateTime.now().add(const Duration(days: 1)))));

    await widgetTester.pumpWidget(LocalizationsInjector(
      child: TaskShow(
          scrollController: ScrollController(),
          task: Task(
              id: 1,
              name: 'task_name',
              description: 'task_description',
              priority: Priority.high,
              deadline: DateTime.now(),
              subjectId: 1,
              taskGroupId: 1,
              finished: false,
              xp: 1)),
    ));

    await widgetTester.pumpAndSettle();

    Finder institutionShow = find.byKey(const Key('institutionShow'));
    expect(institutionShow, findsOneWidget);

    await widgetTester.tap(institutionShow);
    await widgetTester.pumpAndSettle();

    expect(find.text('Education'), findsWidgets);
  });
}
