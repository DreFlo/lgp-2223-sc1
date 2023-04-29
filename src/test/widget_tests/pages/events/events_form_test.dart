import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/pages/events/event_form.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/formatters.dart';
import 'package:src/utils/service_locator.dart';

import '../../../utils/model_mocks_util.mocks.dart';
import '../../../utils/service_locator_test_util.dart';
import '../../widget_tests_utils.dart';

void main() {
  Task task = Task(
      id: 1,
      name: 'name',
      description: 'description',
      priority: Priority.low,
      deadline: DateTime(2025, 1, 1),
      taskGroupId: 1,
      subjectId: 1,
      xp: 1,
      finished: false);
  List<Task> tasks = [
    Task(
        id: 2,
        name: 'name',
        description: 'description',
        priority: Priority.low,
        deadline: DateTime(2025, 1, 1),
        taskGroupId: 1,
        subjectId: 1,
        xp: 1,
        finished: false),
    Task(
        id: 3,
        name: 'name',
        description: 'description',
        priority: Priority.low,
        deadline: DateTime(2025, 1, 1),
        taskGroupId: 1,
        subjectId: 1,
        xp: 1,
        finished: false)
  ];
  Timeslot timeslot = Timeslot(
      id: 1,
      title: 'title',
      description: 'description',
      startDateTime: DateTime(2025, 1, 1, 1, 1),
      endDateTime: DateTime(2025, 1, 1, 2, 1),
      xpMultiplier: 1,
      userId: 1,
      finished: false);
  Timeslot updatedTimeslot = Timeslot(
      id: 1,
      title: 'updated title',
      description: 'updated description',
      startDateTime: DateTime(2025, 1, 1, 1, 1),
      endDateTime: DateTime(2025, 1, 1, 2, 1),
      xpMultiplier: 1,
      userId: 1,
      finished: false);

  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  saveEvent(WidgetTester widgetTester) async {
    Finder saveButton = find.byKey(const Key('saveEventButton'));
    Finder scroll = find.byType(Scrollable).last;
    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveEventButton'), skipOffstage: false));
    await widgetTester.pumpAndSettle();
  }

  testWidgets('Create event with incorrect fields test',
      (WidgetTester widgetTester) async {
    final mockTaskDao = serviceLocator.get<TaskDao>();
    when(mockTaskDao.findTasksActivities(1)).thenAnswer((_) async => []);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventForm(scrollController: ScrollController())));
    await widgetTester.pumpAndSettle();

    // Save event
    await saveEvent(widgetTester);

    expect(find.text('The event title cannot be empty.'), findsOneWidget);
    expect(find.text('The event must have at least one activity.'),
        findsOneWidget);
  });

  /*testWidgets('Create event test', (WidgetTester widgetTester) async {
    final mockTaskDao = serviceLocator.get<TaskDao>();
    when(mockTaskDao.findTasksActivities(any)).thenAnswer((_) async {
      return tasks;
    });

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventForm(scrollController: ScrollController())));
    await widgetTester.pumpAndSettle();

    Finder scroll = find.byType(Scrollable).last;

    // Enter title
    await widgetTester.enterText(find.byKey(const Key('titleField')), 'title');
    await widgetTester.pumpAndSettle();
    expect(find.text('title'), findsOneWidget);

    // Choose activities
    await widgetTester.tap(find.byKey(const Key('addActivitiesButton')));
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byKey(const Key('activityCheckbox')).first);
    Finder saveActivitiesButton = find.byKey(const Key('saveActivitiesButton'));
    await widgetTester.scrollUntilVisible(saveActivitiesButton, 100,
        scrollable: scroll);
    await widgetTester.tap(
        find.byKey(const Key('saveActivitiesButton'), skipOffstage: false));
    await widgetTester.pumpAndSettle();

    // Save event
    await saveEvent(widgetTester);

    expect(find.text('The event title cannot be empty.'), findsNothing);
    expect(
        find.text('The event must have at least one activity.'), findsNothing);
  });`*/

  testWidgets('Load correct event information test',
      (WidgetTester widgetTester) async {
    final mockEventDao = serviceLocator.get<TimeslotDao>();
    when(mockEventDao.findTimeslotById(1))
        .thenAnswer((_) => Stream.value(timeslot));

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventForm(scrollController: ScrollController(), id: 1)));
    await widgetTester.pumpAndSettle();

    expect(find.text(timeslot.title), findsOneWidget);
    expect(find.text(timeslot.description), findsOneWidget);
    expect(find.text(formatEventTime(timeslot.startDateTime)), findsOneWidget);
    expect(find.text(formatEventTime(timeslot.endDateTime)), findsOneWidget);
  });

  testWidgets('Edit Event test - atomic properties',
      (WidgetTester widgetTester) async {
    final mockTaskStudentTimeslotDao =
        serviceLocator.get<TaskStudentTimeslotDao>();
    when(mockTaskStudentTimeslotDao.findTaskByStudentTimeslotId(1))
        .thenAnswer((_) async => [task]);

    final mockEventDao = serviceLocator.get<TimeslotDao>();
    when(mockEventDao.findTimeslotById(1))
        .thenAnswer((_) => Stream.value(timeslot));
    when(mockEventDao.updateTimeslot(updatedTimeslot))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text(updatedTimeslot.title), findsNothing);
    expect(find.text(updatedTimeslot.description), findsNothing);

    // Update title and description
    await widgetTester.enterText(
        find.byKey(const Key('titleField')), updatedTimeslot.title);
    await widgetTester.enterText(
        find.byKey(const Key('descriptionField')), updatedTimeslot.description);
    expect(find.text(updatedTimeslot.title), findsOneWidget);
    expect(find.text(updatedTimeslot.description), findsOneWidget);

    // Save event
    await saveEvent(widgetTester);

    expect(find.text(updatedTimeslot.title), findsNothing);
    expect(find.text(updatedTimeslot.description), findsNothing);
  });

  testWidgets('Edit Event test - remove tasks',
      (WidgetTester widgetTester) async {
    final mockTaskStudentTimeslotDao =
        serviceLocator.get<TaskStudentTimeslotDao>();
    when(mockTaskStudentTimeslotDao.findTaskByStudentTimeslotId(1))
        .thenAnswer((_) async => tasks);

    final mockEventDao = serviceLocator.get<TimeslotDao>();
    when(mockEventDao.findTimeslotById(1))
        .thenAnswer((_) => Stream.value(timeslot));

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventForm(scrollController: ScrollController(), id: 1)));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('activityRemove')), findsNWidgets(2));

    // Remove task
    await widgetTester.tap(find.byKey(const Key('activityRemove')).first);
    await widgetTester.pumpAndSettle();
    expect(find.byKey(const Key('activityRemove')), findsOneWidget);

    // Save event
    await saveEvent(widgetTester);

    expect(find.byKey(const Key('activityRemove')), findsNothing);
  });

  testWidgets('Delete subject test', (WidgetTester widgetTester) async {
    final mockEventDao = serviceLocator.get<TimeslotDao>();
    when(mockEventDao.findTimeslotById(1))
        .thenAnswer((_) => Stream.value(timeslot));

    when(mockEventDao.deleteTimeslot(MockTimeslot()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventForm(scrollController: ScrollController(), id: 1)));
    await widgetTester.pumpAndSettle();

    expect(find.text(timeslot.title), findsOneWidget);
    expect(find.text(timeslot.description), findsOneWidget);

    // Delete event
    final deleteButton = find.byKey(const Key('deleteEventButton'));
    Finder scroll = find.byType(Scrollable).last;
    await widgetTester.scrollUntilVisible(deleteButton, 100,
        scrollable: scroll);
    await widgetTester.tap(deleteButton);
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('cancelDeleteButton')), findsOneWidget);
    expect(find.byKey(const Key('deleteButton')), findsOneWidget);

    // Confirm delete
    await widgetTester.tap(find.byKey(const Key('deleteButton')));
    await widgetTester.pumpAndSettle();

    expect(find.text(timeslot.title), findsNothing);
    expect(find.text(timeslot.description), findsNothing);
  });
}
