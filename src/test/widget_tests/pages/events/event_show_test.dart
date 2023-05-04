import 'package:flutter_test/flutter_test.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/pages/events/event_show.dart';
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

  testWidgets('Load student event show correctly test',
      (WidgetTester widgetTester) async {
    final timeslotDao = serviceLocator.get<TimeslotDao>();
    when(timeslotDao.findTimeslotById(1))
        .thenAnswer((_) => Stream.value(Timeslot(
              id: 1,
              title: 'ts_title',
              description: 'ts_description',
              startDateTime: DateTime.now(),
              endDateTime: DateTime.now().add(const Duration(days: 1)),
              xpMultiplier: 1,
              finished: false,
              userId: 1,
            )));

    final taskStudentTimeslotDao = serviceLocator.get<TaskStudentTimeslotDao>();
    when(taskStudentTimeslotDao.findTaskByStudentTimeslotId(1))
        .thenAnswer((_) async => [
              Task(
                  id: 1,
                  name: 'task_name',
                  description: 'task_description',
                  priority: Priority.high,
                  deadline: DateTime.now(),
                  xp: 1,
                  finished: false)
            ]);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventShow(
      id: 1,
      scrollController: ScrollController(),
      type: EventType.student,
      callback: callback,
    )));

    await widgetTester.pumpAndSettle();

    expect(find.text('ts_title', skipOffstage: false), findsOneWidget);
    expect(find.text('ts_description', skipOffstage: false), findsOneWidget);
    expect(find.text('task_name', skipOffstage: false), findsOneWidget);
    expect(find.textContaining('task_description', skipOffstage: false),
        findsOneWidget);
  });

  testWidgets('Load leisure event show correctly test',
      (WidgetTester widgetTester) async {
    final timeslotDao = serviceLocator.get<TimeslotDao>();
    when(timeslotDao.findTimeslotById(1))
        .thenAnswer((_) => Stream.value(Timeslot(
              id: 1,
              title: 'ts_title',
              description: 'ts_description',
              startDateTime: DateTime.now(),
              endDateTime: DateTime.now().add(const Duration(days: 1)),
              xpMultiplier: 1,
              finished: false,
              userId: 1,
            )));

    final mediaMediaTimeslotDao = serviceLocator.get<MediaMediaTimeslotDao>();
    when(mediaMediaTimeslotDao.findMediaByMediaTimeslotId(1))
        .thenAnswer((_) async => [
              Media(
                  id: 1,
                  name: 'media_name',
                  description: 'media_description',
                  xp: 1,
                  linkImage: 'link_image',
                  status: Status.planTo,
                  favorite: false,
                  genres: 'genres',
                  release: DateTime.now().add(const Duration(days: 1)),
                  participants: 'participants',
                  type: MediaDBTypes.movie)
            ]);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: EventShow(
      id: 1,
      scrollController: ScrollController(),
      type: EventType.leisure,
      callback: callback,
    )));

    await widgetTester.pumpAndSettle();

    expect(find.text('ts_title', skipOffstage: false), findsOneWidget);
    expect(find.text('ts_description', skipOffstage: false), findsOneWidget);
    expect(find.text('media_name', skipOffstage: false), findsOneWidget);
    expect(find.text('media_description', skipOffstage: false), findsOneWidget);
  });
}
