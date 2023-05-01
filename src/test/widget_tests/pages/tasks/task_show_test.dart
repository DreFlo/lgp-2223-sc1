import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/task_note.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/task_show.dart';
import 'package:src/utils/date_formatter.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/enums.dart';
import '../../../utils/model_mocks_util.mocks.dart';
import '../../../utils/service_locator_test_util.dart';
import '../../widget_tests_utils.dart';

void main() {
  int taskId = 1;
  String taskName = "task_name", taskDescription = "task_description";
  Priority taskPriority = Priority.low;
  DateTime taskDeadline = DateFormatter.day(DateTime.now());
  int subjectId = 1, taskXp = 0;
  String subjectName = "subject_name", subjectAcronym = "subject_acronym";
  int institutionId = 1;
  String institutionName = "institution_name";
  InstitutionType institutionType = InstitutionType.other;
  int userId = 1;
  int taskGroupId = 1;
  String taskGroupName = "project_group_name",
      taskGroupDescription = "project_group_description";
  Priority taskGroupPriority = Priority.low;
  DateTime taskGroupDeadline =
      DateFormatter.day(DateTime.now()).add(const Duration(days: 2));
  String noteContent = "note_content", noteTitle = "note_title";
  Task task = Task(
      id: taskId,
      name: taskName,
      description: taskDescription,
      priority: taskPriority,
      deadline: taskDeadline,
      subjectId: subjectId,
      taskGroupId: taskGroupId,
      finished: false,
      xp: taskXp);
  Subject subject = Subject(
      id: subjectId,
      name: subjectName,
      acronym: subjectAcronym,
      institutionId: institutionId);
  Institution institution = Institution(
      id: institutionId,
      name: institutionName,
      type: institutionType,
      userId: userId);
  TaskGroup taskGroup = TaskGroup(
      id: taskGroupId,
      name: taskGroupName,
      description: taskGroupDescription,
      priority: taskGroupPriority,
      deadline: taskGroupDeadline,
      subjectId: subjectId);
  TaskNote taskNote = TaskNote(id: 1, taskId: taskId);
  Note note = Note(
      title: noteTitle,
      content: noteContent,
      date: taskDeadline.add(const Duration(hours: -1)));

  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  loadData() {
    final mockTaskDao = serviceLocator.get<TaskDao>();
    when(mockTaskDao.updateTask(MockTask())).thenAnswer((_) async => 1);
    when(mockTaskDao.findTaskById(task.id!))
        .thenAnswer((_) => Stream.value(task));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectById(subject.id!))
        .thenAnswer((_) => Stream.value(subject));

    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(institution.id!))
        .thenAnswer((_) => Stream.value(institution));

    final mockTaskGroupDao = serviceLocator.get<TaskGroupDao>();
    when(mockTaskGroupDao.findTaskGroupById(taskGroup.id!))
        .thenAnswer((_) => Stream.value(taskGroup));

    when(mockTaskGroupDao.findAllTaskGroups())
        .thenAnswer((_) async => [taskGroup]);

    when(mockInstitutionDao.findAllInstitutions())
        .thenAnswer((_) async => [institution]);

    when(mockSubjectDao.findSubjectByInstitutionId(institution.id!))
        .thenAnswer((_) async => [subject]);

    final mockTaskNoteDao = serviceLocator.get<TaskNoteDao>();
    when(mockTaskNoteDao.findTaskNotesByTaskId(task.id!))
        .thenAnswer((_) async => [taskNote]);

    final mockNoteDao = serviceLocator.get<NoteDao>();
    when(mockNoteDao.findNoteById(taskNote.id!))
        .thenAnswer((_) => Stream.value(note));
  }

  testWidgets('Load correct task from taskGroup information test',
      (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskShow(
      scrollController: ScrollController(),
      task: task,
      taskGroup: taskGroup,
    )));

    await widgetTester.pumpAndSettle();

    //String properties
    expect(find.text(taskName), findsOneWidget);
    expect(find.text(taskDescription), findsOneWidget);
    expect(find.text(DateFormatter.format(taskDeadline)), findsOneWidget);

    // Selected taskgroup
    expect(find.text(taskGroup.name), findsOneWidget);

    // Selected institution
    expect(find.text(institution.name), findsOneWidget);

    // Selected subject
    expect(find.text(subject.acronym), findsOneWidget);

    expect(find.text(noteTitle), findsOneWidget);

    expect(find.byKey(const Key('taskEditButton')), findsOneWidget);

    // Not testing interaction with subpages
  });
  testWidgets('Load correct task with taskGroup information test',
      (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskShow(scrollController: ScrollController(), task: task)));

    await widgetTester.pumpAndSettle();

    //String properties
    expect(find.text(taskName), findsOneWidget);
    expect(find.text(taskDescription), findsOneWidget);
    expect(find.text(DateFormatter.format(taskDeadline)), findsOneWidget);

    // Selected taskgroup
    expect(find.text(taskGroup.name), findsOneWidget);

    // Selected institution
    expect(find.text(institution.name), findsOneWidget);

    // Selected subject
    expect(find.text(subject.acronym), findsOneWidget);

    expect(find.text(noteTitle), findsOneWidget);

    expect(find.byKey(const Key('taskEditButton')), findsOneWidget);

    // Not testing interaction with subpages
  });
}
