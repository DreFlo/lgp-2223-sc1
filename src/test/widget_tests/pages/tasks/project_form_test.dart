import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/project_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/tasks/task_bar.dart';
import '../../../utils/model_mocks_util.mocks.dart';
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

  Institution institutionNone =
      Institution(id: -1, name: 'None', type: InstitutionType.other, userId: 1);
  Subject subjectNone = Subject(
    id: -1,
    name: 'None',
    acronym: 'None',
  );

  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  getSelectedInstitution() {
    Element institutionDropdown =
        find.byKey(const ValueKey("projectInstitution")).evaluate().first;
    Institution selectedInstitution =
        (institutionDropdown.widget as DropdownButton).value;
    return selectedInstitution;
  }

  getSelectedSubject() {
    Element subjectDropdown =
        find.byKey(const ValueKey("projectSubject")).evaluate().first;
    Subject selectedSubject = (subjectDropdown.widget as DropdownButton).value;
    return selectedSubject;
  }

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
  }

  tap(WidgetTester widgetTester, Finder finder) async {
    await widgetTester.scrollUntilVisible(finder, 100,
        scrollable: find.byType(Scrollable).last);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  save(WidgetTester widgetTester) async {
    Finder saveButton = find.byKey(const Key('projectSaveButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('projectSaveButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();
  }

  testWidgets('Create project with incorrect field tests',
      // Missing priority
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController())));
    await widgetTester.pumpAndSettle();

    await save(widgetTester);

    expect(find.text("Missing priority"), findsOneWidget);
  });

  testWidgets('Create project normally test',
      (WidgetTester widgetTester) async {
    final mockTaskDao = serviceLocator.get<TaskGroupDao>();

    when(mockTaskDao.insertTaskGroup(MockTaskGroup()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController())));

    await widgetTester.pumpAndSettle();

    String title = 'project_title';
    await widgetTester.enterText(find.byKey(const Key('projectTitle')), title);

    expect(find.text(title), findsOneWidget);

    await widgetTester.tap(find.byKey(const Key('priorityLow')));

    await save(widgetTester);

    expect(find.text(title), findsNothing);
  });

  testWidgets('Load correct project information test',
      (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    //String properties
    expect(find.text(taskGroupName), findsOneWidget);
    expect(find.text(taskGroupDescription), findsOneWidget);
    expect(find.text(DateFormatter.format(taskGroupDeadline)), findsOneWidget);

    // Selected institution
    Institution selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution, institution);

    // Selected subject
    Subject selectedSubject = getSelectedSubject();
    expect(selectedSubject, subject);
  });

  testWidgets('Edit task test - atomic properties',
      (WidgetTester widgetTester) async {
    String taskGroupTitleEdited = 'task_group_title_edited';
    String taskGroupDescriptionEdited = 'task_group_description_edited';

    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    // Change title
    await widgetTester.enterText(
        find.byKey(const Key('projectTitle')), taskGroupTitleEdited);

    //Change description
    await widgetTester.enterText(find.byKey(const Key('projectDescription')),
        taskGroupDescriptionEdited);

    final priorityHighButton = find.byKey(const Key('priorityHigh'));
    await tap(widgetTester, priorityHighButton);

    expect(find.text(taskGroupTitleEdited), findsOneWidget);
    expect(find.text(taskGroupDescriptionEdited), findsOneWidget);

    Container priorityContainer =
        widgetTester.firstWidget(find.byKey(const Key('priorityHigh')));
    BoxDecoration decoration = priorityContainer.decoration as BoxDecoration;
    expect(decoration.color, primaryColor);

    await save(widgetTester);
    expect(find.byKey(const Key('projectTitle')), findsNothing);
  });

  testWidgets('Edit project test - subject fail',
      (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    // Selected institution
    Institution selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution, institution);

    // Selected subject
    Subject selectedSubject = getSelectedSubject();
    expect(selectedSubject, subject);

    final subjectButton = find.byKey(const Key('projectSubject'));
    await tap(widgetTester, subjectButton);
    await widgetTester.pumpAndSettle();

    final subjectNoneButton = find.byKey(const Key('projectSubject_None')).last;
    await tap(widgetTester, subjectNoneButton);
    await widgetTester.pumpAndSettle();

    selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution.id, institution.id);

    selectedSubject = getSelectedSubject();
    expect(selectedSubject.id, subjectNone.id);

    await save(widgetTester);

    selectedSubject = getSelectedSubject();
    expect(selectedSubject.id, subjectNone.id);
    expect(find.text("Subject must be selected or institution must be none"),
        findsOneWidget);
  });
  testWidgets('Edit project test - subject', (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    // Selected institution
    Institution selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution, institution);

    // Selected subject
    Subject selectedSubject = getSelectedSubject();
    expect(selectedSubject, subject);

    final subjectButton = find.byKey(const Key('projectSubject'));
    await tap(widgetTester, subjectButton);
    await widgetTester.pumpAndSettle();

    final subjectNoneButton = find.byKey(const Key('projectSubject_None')).last;
    await tap(widgetTester, subjectNoneButton);
    await widgetTester.pumpAndSettle();

    final institutionButton = find.byKey(const Key('projectInstitution'));
    await tap(widgetTester, institutionButton);
    await widgetTester.pumpAndSettle();

    final institutionNoneButton =
        find.byKey(const Key('projectInstitution_None')).last;
    await tap(widgetTester, institutionNoneButton);
    await widgetTester.pumpAndSettle();

    selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution.id, institutionNone.id);

    selectedSubject = getSelectedSubject();
    expect(selectedSubject.id, subjectNone.id);

    await save(widgetTester);

    expect(find.byKey(Key(taskName)), findsNothing);
  });

  testWidgets('Delete project test', (WidgetTester widgetTester) async {
    loadData();

    final mockTaskDao = serviceLocator<TaskDao>();
    when(mockTaskDao.deleteTask(MockTask())).thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('projectTitle')), findsOneWidget);

    final deleteButton = find.byKey(const Key('projectDeleteButton'));
    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(deleteButton, 100,
        scrollable: scroll);
    await widgetTester.tap(deleteButton);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('cancelConfirmationButton')), findsOneWidget);
    expect(find.byKey(const Key('deleteConfirmationButton')), findsOneWidget);

    await widgetTester.tap(find.byKey(const Key('deleteConfirmationButton')));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('projectTitle')), findsNothing);
  });

  testWidgets('Add new task from project test',
      (WidgetTester widgetTester) async {
    loadData();
    String taskName = 'task_name';
    String taskDescription = 'task_description';

    final mockNoteTaskSuperDao = serviceLocator<TaskDao>();
    when(mockNoteTaskSuperDao.insertTask(MockTask()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: ProjectForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('taskTitle')), findsNothing);
    expect(find.byKey(const Key('taskDescription')), findsNothing);

    final addTaskButton = find.byKey(const Key('addTaskButton'));
    await tap(widgetTester, addTaskButton);

    expect(find.byKey(const Key('taskTitle')), findsOneWidget);
    expect(find.byKey(const Key('taskDescription')), findsOneWidget);

    // Project
    final projectFinder = find.byKey(const Key('taskTaskGroup'));
    expect(projectFinder, findsOneWidget);
    final project = projectFinder.evaluate().first.widget;
    expect(project, isA<DropdownMenuItem<TaskGroup>>());

    // Institution
    final institutionFinder = find.byKey(const Key('taskInstitution'));
    expect(institutionFinder, findsOneWidget);
    final institution = institutionFinder.evaluate().first.widget;
    expect(institution, isA<DropdownMenuItem<Institution>>());

    // Subject
    final subjectFinder = find.byKey(const Key('taskSubject'));
    expect(subjectFinder, findsOneWidget);
    final subject = subjectFinder.evaluate().first.widget;
    expect(subject, isA<DropdownMenuItem<Subject>>());

    await widgetTester.enterText(find.byKey(const Key('taskTitle')), taskName);
    await widgetTester.enterText(
        find.byKey(const Key('taskDescription')), taskDescription);

    final priorityHighButton = find.byKey(const Key('priorityHigh')).last;
    await tap(widgetTester, priorityHighButton);

    Finder saveButton =
        find.byKey(const Key('taskSaveButton'), skipOffstage: false);
    await tap(widgetTester, saveButton);

    expect(find.byKey(const Key('taskTitle')), findsNothing);
    expect(find.byKey(const Key('taskDescription')), findsNothing);

    expect(find.text(taskName), findsOneWidget);
    expect(find.byType(TaskBar), findsOneWidget);
  });
}
