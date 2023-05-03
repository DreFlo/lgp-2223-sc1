import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/project_show.dart';
import 'package:src/utils/date_formatter.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/enums.dart';
import '../../../utils/service_locator_test_util.dart';
import '../../widget_tests_utils.dart';

void main() {
  int taskGroupId = 1;
  String taskGroupName = "project_group_name",
      taskGroupDescription = "project_group_description";
  Priority taskGroupPriority = Priority.low;
  DateTime taskGroupDeadline =
      DateFormatter.day(DateTime.now()).add(const Duration(days: 2));
  String taskName = "task_name";

  int subjectId = 1;
  String subjectName = "subject_name", subjectAcronym = "subject_acronym";
  int institutionId = 1;
  String institutionName = "institution_name";
  InstitutionType institutionType = InstitutionType.other;
  int userId = 1;
  TaskGroup taskGroup = TaskGroup(
      id: taskGroupId,
      name: taskGroupName,
      description: taskGroupDescription,
      priority: taskGroupPriority,
      deadline: taskGroupDeadline,
      subjectId: subjectId);
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
  Task task = Task(
      id: 1,
      name: taskName,
      description: 'description',
      priority: Priority.low,
      deadline: DateTime.now(),
      taskGroupId: taskGroupId,
      subjectId: subject.id!,
      finished: false,
      xp: 0);

  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  loadData() {
    final mockTaskGroupDao = serviceLocator.get<TaskGroupDao>();
    when(mockTaskGroupDao.findTaskGroupById(taskGroup.id!))
        .thenAnswer((_) => Stream.value(taskGroup));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectById(subject.id!))
        .thenAnswer((_) => Stream.value(subject));

    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(institution.id!))
        .thenAnswer((_) => Stream.value(institution));

    when(mockInstitutionDao.findAllInstitutions())
        .thenAnswer((_) async => [institution]);

    when(mockSubjectDao.findSubjectByInstitutionId(institution.id!))
        .thenAnswer((_) async => [subject]);

    final mockTaskDao = serviceLocator.get<TaskDao>();
    when(mockTaskDao.findTasksByTaskGroupId(taskGroup.id!))
        .thenAnswer((realInvocation) async => [task]);
  }

  testWidgets('Load correct project information test',
      (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectShow(
      scrollController: ScrollController(),
      taskGroup: taskGroup,
    )));

    await widgetTester.pumpAndSettle();

    //String properties
    expect(find.text(taskGroupName), findsOneWidget);
    expect(find.text(taskGroupDescription), findsOneWidget);
    expect(find.text(DateFormatter.format(taskGroupDeadline)), findsOneWidget);

    // Selected institution
    expect(find.text(institution.name), findsOneWidget);

    // Selected subject
    expect(find.text(subject.acronym), findsOneWidget);

    //Notes
    expect(find.text(task.name), findsOneWidget);

    expect(find.byKey(const Key('projectEditButton')), findsOneWidget);
  });

  // Not testing interaction with subpages
}
