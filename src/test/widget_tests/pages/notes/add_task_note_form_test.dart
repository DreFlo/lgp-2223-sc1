import 'package:flutter_test/flutter_test.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/daos/log_dao.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/models/user.dart';
import 'package:src/models/user_badge.dart';
import 'package:src/utils/service_locator.dart';
import '../../../utils/service_locator_test_util.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import '../../../utils/model_mocks_util.mocks.dart';
import '../../widget_tests_utils.dart';

import 'package:src/pages/notes/add_task_note_form.dart';

import 'package:src/models/notes/note.dart';

void func(Note note) {}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

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

  testWidgets('Create task note with incorrect fields test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(const LocalizationsInjector(
      child: AddTaskNoteForm(),
    ));

    await widgetTester.pumpAndSettle();

    final saveButton = find.byKey(const Key('saveTaskNoteButton'));

    Finder scrollable = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100,
        scrollable: scrollable);

    await widgetTester.tap(saveButton);

    await widgetTester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Content is required'), findsOneWidget);
  });

  testWidgets('Create task note normally', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(const LocalizationsInjector(
      child: AddTaskNoteForm(taskId: 1, callback: func),
    ));

    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(
        find.byKey(const Key('titleNoteField')), 'Test title');
    await widgetTester.enterText(
        find.byKey(const Key('contentNoteField')), 'Test content');

    expect(find.text('Test title'), findsOneWidget);
    expect(find.text('Test content'), findsOneWidget);

    final saveButton = find.byKey(const Key('saveTaskNoteButton'));

    Finder scrollable = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100,
        scrollable: scrollable);

    await widgetTester.tap(saveButton);

    await widgetTester.pumpAndSettle();

    expect(find.text('Title is required'), findsNothing);
    expect(find.text('Content is required'), findsNothing);
    expect(find.text('Test title'), findsNothing);
    expect(find.text('Test content'), findsNothing);
  });

  testWidgets('Load correct task note information test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(LocalizationsInjector(
      child: AddTaskNoteForm(
        note: Note(
          id: 1,
          title: 'Test title',
          content: 'Test content',
          date: DateTime.now(),
        ),
      ),
    ));

    await widgetTester.pumpAndSettle();

    expect(find.text('Test title'), findsOneWidget);
    expect(find.text('Test content'), findsOneWidget);
  });

  testWidgets('Edit task note test', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(LocalizationsInjector(
      child: AddTaskNoteForm(
        note: Note(
          id: 1,
          title: 'Test title',
          content: 'Test content',
          date: DateTime.now(),
        ),
      ),
    ));

    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(
        find.byKey(const Key('titleNoteField')), 'Test title edited');
    await widgetTester.enterText(
        find.byKey(const Key('contentNoteField')), 'Test content edited');

    expect(find.text('Test title edited'), findsOneWidget);
    expect(find.text('Test content edited'), findsOneWidget);
  });

  testWidgets('Delete task note test', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final noteTaskSuperDaoMock = serviceLocator.get<NoteTaskNoteSuperDao>();
    when(noteTaskSuperDaoMock
            .deleteNoteTaskNoteSuperEntity(MockNoteTaskNoteSuperEntity()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
      child: AddTaskNoteForm(
        taskId: 1,
        note: Note(
          id: 1,
          title: 'Test title',
          content: 'Test content',
          date: DateTime.now(),
        ),
      ),
    ));

    await widgetTester.pumpAndSettle();

    final deleteButton = find.byKey(const Key('deleteTaskNoteButton'));

    Finder scrollable = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(deleteButton, 100,
        scrollable: scrollable);

    await widgetTester.tap(deleteButton);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('cancelConfirmationButton')), findsOneWidget);
    expect(find.byKey(const Key('deleteConfirmationButton')), findsOneWidget);

    await widgetTester.tap(find.byKey(const Key('deleteConfirmationButton')));

    await widgetTester.pumpAndSettle();

    expect(find.text('Test title'), findsNothing);
    expect(find.text('Test content'), findsNothing);
  });
}
