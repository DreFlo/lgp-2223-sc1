import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/daos/badges_dao.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/models/badges.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/user.dart';
import 'package:src/models/user_badge.dart';
import 'package:src/daos/log_dao.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/notes/note_bar.dart';
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

  TaskGroup taskGroupNone = TaskGroup(
      id: -1,
      name: "None",
      description: "",
      priority: Priority.high,
      deadline: DateFormatter.day(DateTime.now()));
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

  getSelectedTaskGroup() {
    Element taskGroupDropdown =
        find.byKey(const ValueKey("taskTaskGroup")).evaluate().first;
    TaskGroup selected = (taskGroupDropdown.widget as DropdownButton).value;
    return selected;
  }

  getSelectedInstitution() {
    Element institutionDropdown =
        find.byKey(const ValueKey("taskInstitution")).evaluate().first;
    Institution selectedInstitution =
        (institutionDropdown.widget as DropdownButton).value;
    return selectedInstitution;
  }

  getSelectedSubject() {
    Element subjectDropdown =
        find.byKey(const ValueKey("taskSubject")).evaluate().first;
    Subject selectedSubject = (subjectDropdown.widget as DropdownButton).value;
    return selectedSubject;
  }

  loadBadgesInfo() {
    User user = User(
        id: 1,
        name: 'name',
        email: 'email',
        password: 'password',
        level: 1,
        imagePath: '',
        xp: 0);
    final mockAuthenticationService =
        serviceLocator.get<AuthenticationService>();
    when(mockAuthenticationService.getLoggedInUser()).thenAnswer((_) => user);
    final mockUserBadgeDao = serviceLocator.get<UserBadgeDao>();
    when(mockUserBadgeDao.findUserBadgeByIds(user.id!, 1))
        .thenAnswer((_) async => UserBadge(userId: 0, badgeId: 0));
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);
    DateTime end = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59, 59, 59);

    final mockLogDao = serviceLocator.get<LogDao>();
    when(mockLogDao.countLogsByDate(today, end)).thenAnswer((_) async => 1);
    when(mockLogDao.countLogs()).thenAnswer((_) async => 5);
  }

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

    loadBadgesInfo();
  }

  tap(WidgetTester widgetTester, Finder finder) async {
    await widgetTester.scrollUntilVisible(finder, 100,
        scrollable: find.byType(Scrollable).last);
    await widgetTester.tap(finder);
    await widgetTester.pumpAndSettle();
  }

  save(WidgetTester widgetTester) async {
    Finder saveButton = find.byKey(const Key('taskSaveButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('taskSaveButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();
  }

  testWidgets('Create task with incorrect field tests',
      // Missing priority
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController())));
    await widgetTester.pumpAndSettle();

    await save(widgetTester);

    expect(find.text("Missing priority"), findsOneWidget);
  });

  testWidgets('Create task normally test', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final mockTaskDao = serviceLocator.get<TaskDao>();

    when(mockTaskDao.insertTask(MockTask())).thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController())));

    await widgetTester.pumpAndSettle();

    String title = 'task_title';
    await widgetTester.enterText(find.byKey(const Key('taskTitle')), title);

    expect(find.text(title), findsOneWidget);

    await widgetTester.tap(find.byKey(const Key('priorityLow')));

    await save(widgetTester);

    expect(find.text(title), findsNothing);
  });

  testWidgets('Create task to win first task badge',
      (WidgetTester widgetTester) async {
    User user = User(
        id: 1,
        name: 'name',
        email: 'email',
        password: 'password',
        level: 1,
        imagePath: '',
        xp: 0);
    final mockAuthenticationService =
        serviceLocator.get<AuthenticationService>();
    when(mockAuthenticationService.getLoggedInUser()).thenAnswer((_) => user);
    final mockUserBadgeDao = serviceLocator.get<UserBadgeDao>();
    when(mockUserBadgeDao.findUserBadgeByIds(user.id!, 1))
        .thenAnswer((_) async => UserBadge(userId: 0, badgeId: 0));
    when(mockUserBadgeDao.insertUserBadge(UserBadge(userId: 1, badgeId: 1)))
        .thenAnswer((_) async => 1);

    final mockBadgesDao = serviceLocator.get<BadgesDao>();
    when(mockBadgesDao.findBadgeById(1)).thenAnswer((_) async => Badges(
        id: 1,
        name: 'Bare Minimum Bob',
        description: 'Completed your first task!',
        icon: 'FontAwesome.face_flushed',
        colors: 'FF5DD3C5,FF0094FF',
        fact:
            'Male quokkas will defend their pregnant mate, but once the child is born, they turn into deadbeats.'));
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);
    DateTime end = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59, 59, 59);

    final mockLogDao = serviceLocator.get<LogDao>();
    when(mockLogDao.countLogsByDate(today, end)).thenAnswer((_) async => 1);
    when(mockLogDao.countLogs()).thenAnswer((_) async => 5);

    final mockTaskDao = serviceLocator.get<TaskDao>();

    when(mockTaskDao.insertTask(MockTask())).thenAnswer((_) async => 1);
    when(mockTaskDao.countTasks()).thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController())));

    await widgetTester.pumpAndSettle();

    String title = 'task_title';
    await widgetTester.enterText(find.byKey(const Key('taskTitle')), title);

    expect(find.text(title), findsOneWidget);

    await widgetTester.tap(find.byKey(const Key('priorityLow')));

    await save(widgetTester);

    expect(find.text(title), findsNothing);
    expect(find.text('Bare Minimum Bob'), findsOneWidget);
  });

  testWidgets('Load correct task information test',
      (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    //String properties
    expect(find.text(taskName), findsOneWidget);
    expect(find.text(taskDescription), findsOneWidget);
    expect(find.text(DateFormatter.format(taskDeadline)), findsOneWidget);

    // Selected taskgroup
    TaskGroup selectedTaskGroup = getSelectedTaskGroup();
    expect(selectedTaskGroup, taskGroup);

    // Selected institution
    Institution selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution, institution);

    // Selected subject
    Subject selectedSubject = getSelectedSubject();
    expect(selectedSubject, subject);
  });

  testWidgets('Edit task test - atomic properties',
      (WidgetTester widgetTester) async {
    String taskTitleEdited = 'task_title_edited';
    String taskDescriptionEdited = 'task_description_edited';

    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    // Change title
    await widgetTester.enterText(
        find.byKey(const Key('taskTitle')), taskTitleEdited);

    //Change description
    await widgetTester.enterText(
        find.byKey(const Key('taskDescription')), taskDescriptionEdited);

    final priorityHighButton = find.byKey(const Key('priorityHigh'));
    await tap(widgetTester, priorityHighButton);

    expect(find.text(taskTitleEdited), findsOneWidget);
    expect(find.text(taskDescriptionEdited), findsOneWidget);

    Container priorityContainer =
        widgetTester.firstWidget(find.byKey(const Key('priorityHigh')));
    BoxDecoration decoration = priorityContainer.decoration as BoxDecoration;
    expect(decoration.color, primaryColor);

    await save(widgetTester);
    expect(find.byKey(const Key('taskTitle')), findsNothing);
  });
  testWidgets('Edit task test - taskGroup', (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    // Selected taskgroup
    TaskGroup selectedTaskGroup = getSelectedTaskGroup();
    expect(selectedTaskGroup, taskGroup);

    // Selected institution
    Institution selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution, institution);

    // Selected subject
    Subject selectedSubject = getSelectedSubject();
    expect(selectedSubject, subject);
    final taskGroupButton = find.byKey(const Key('taskTaskGroup'));
    await tap(widgetTester, taskGroupButton);
    await widgetTester.pumpAndSettle();

    final taskGroupNoneButton =
        find.byKey(const Key('taskTaskGroup_None')).last;
    await tap(widgetTester, taskGroupNoneButton);
    await widgetTester.pumpAndSettle();

    selectedTaskGroup = getSelectedTaskGroup();
    expect(selectedTaskGroup.id, taskGroupNone.id);

    selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution.id, institutionNone.id);

    selectedSubject = getSelectedSubject();
    expect(selectedSubject.id, subjectNone.id);

    await save(widgetTester);
    expect(find.byKey(const Key('taskTitle')), findsNothing);
  });
  testWidgets('Edit task test - subject fail',
      (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    // Selected taskgroup
    TaskGroup selectedTaskGroup = getSelectedTaskGroup();
    expect(selectedTaskGroup, taskGroup);

    // Selected institution
    Institution selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution, institution);

    // Selected subject
    Subject selectedSubject = getSelectedSubject();
    expect(selectedSubject, subject);

    final subjectButton = find.byKey(const Key('taskSubject'));
    await tap(widgetTester, subjectButton);
    await widgetTester.pumpAndSettle();

    final subjectNoneButton = find.byKey(const Key('taskSubject_None')).last;
    await tap(widgetTester, subjectNoneButton);
    await widgetTester.pumpAndSettle();

    selectedTaskGroup = getSelectedTaskGroup();
    expect(selectedTaskGroup.id, taskGroupNone.id);

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
  testWidgets('Edit task test - subject', (WidgetTester widgetTester) async {
    loadData();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    // Selected taskgroup
    TaskGroup selectedTaskGroup = getSelectedTaskGroup();
    expect(selectedTaskGroup, taskGroup);

    // Selected institution
    Institution selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution, institution);

    // Selected subject
    Subject selectedSubject = getSelectedSubject();
    expect(selectedSubject, subject);

    final subjectButton = find.byKey(const Key('taskSubject'));
    await tap(widgetTester, subjectButton);
    await widgetTester.pumpAndSettle();

    final subjectNoneButton = find.byKey(const Key('taskSubject_None')).last;
    await tap(widgetTester, subjectNoneButton);
    await widgetTester.pumpAndSettle();

    final institutionButton = find.byKey(const Key('taskInstitution'));
    await tap(widgetTester, institutionButton);
    await widgetTester.pumpAndSettle();

    final institutionNoneButton =
        find.byKey(const Key('taskInstitution_None')).last;
    await tap(widgetTester, institutionNoneButton);
    await widgetTester.pumpAndSettle();

    selectedTaskGroup = getSelectedTaskGroup();
    expect(selectedTaskGroup.id, taskGroupNone.id);

    selectedInstitution = getSelectedInstitution();
    expect(selectedInstitution.id, institutionNone.id);

    selectedSubject = getSelectedSubject();
    expect(selectedSubject.id, subjectNone.id);

    await save(widgetTester);

    expect(find.byKey(Key(taskName)), findsNothing);
  });

  testWidgets('Delete task test', (WidgetTester widgetTester) async {
    loadData();

    final mockTaskDao = serviceLocator<TaskDao>();
    when(mockTaskDao.deleteTask(MockTask())).thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('taskTitle')), findsOneWidget);

    final deleteButton = find.byKey(const Key('taskDeleteButton'));
    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(deleteButton, 100,
        scrollable: scroll);
    await widgetTester.tap(deleteButton);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('cancelConfirmationButton')), findsOneWidget);
    expect(find.byKey(const Key('deleteConfirmationButton')), findsOneWidget);

    await widgetTester.tap(find.byKey(const Key('deleteConfirmationButton')));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('taskTitle')), findsNothing);
  });

  testWidgets('Add new note from task test', (WidgetTester widgetTester) async {
    var noteTitle = 'note_title';
    var noteContent = 'note_content';

    loadData();

    final mockNoteTaskSuperDao = serviceLocator<NoteTaskNoteSuperDao>();
    when(mockNoteTaskSuperDao
            .insertNoteTaskNoteSuperEntity(MockNoteTaskNoteSuperEntity()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: TaskForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('titleNoteField')), findsNothing);
    expect(find.byKey(const Key('contentNoteField')), findsNothing);

    final addNoteButton = find.byKey(const Key('addNoteButton'));
    await tap(widgetTester, addNoteButton);

    expect(find.byKey(const Key('titleNoteField')), findsOneWidget);
    expect(find.byKey(const Key('contentNoteField')), findsOneWidget);

    await widgetTester.enterText(
        find.byKey(const Key('titleNoteField')), noteTitle);

    await widgetTester.enterText(
        find.byKey(const Key('contentNoteField')), noteContent);

    Finder saveButton = find.byKey(const Key('saveTaskNoteButton'));
    await tap(widgetTester, saveButton);

    expect(find.byKey(const Key('titleNoteField')), findsNothing);
    expect(find.byKey(const Key('contentNoteField')), findsNothing);

    expect(find.text(noteTitle), findsOneWidget);
    expect(find.byType(NoteBar), findsOneWidget);
  });
}
