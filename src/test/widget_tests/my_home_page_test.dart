import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import '../utils/service_locator_test_util.dart';
import '../utils/locations_injector.dart';
import 'package:mockito/mockito.dart';
import 'package:src/pages/my_home_page.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';
import 'package:flutter/material.dart';

void disableOverflowErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final isOverflowError = exception is FlutterError &&
        !exception.diagnostics.any(
            (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));

    if (isOverflowError) {
      //print(details);
    } else {
      FlutterError.presentError(details);
    }
  };
}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('MyHomePage displays data from the database',
      (WidgetTester tester) async {
    // Mock the data you expect to receive from the database.
    disableOverflowErrors();
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, 0, 0, 0);

    final mediaEvent = TimeslotMediaTimeslotSuperEntity(
        title: 'My Media Event',
        description: 'Watch something',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        xpMultiplier: 1,
        finished: false,
        type: MediaTypes.movie,
        id: 1,
        userId: 1);

    final studentEvent = TimeslotStudentTimeslotSuperEntity(
        title: 'My Student Event',
        description: 'Do something',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        xpMultiplier: 1,
        finished: false,
        id: 1,
        userId: 1);

    final mockMediaEventDao =
        serviceLocator.get<TimeslotMediaTimeslotSuperDao>();
    when(mockMediaEventDao.findAllTimeslotMediaTimeslot(start))
        .thenAnswer((_) async => [mediaEvent]);

    final mockStudentEventDao =
        serviceLocator.get<TimeslotStudentTimeslotSuperDao>();
    when(mockStudentEventDao.findAllTimeslotStudentTimeslot(start))
        .thenAnswer((_) async => [studentEvent]);

    // Build the widget.
    await tester.pumpWidget(const LocalizationsInjector(child: MyHomePage()));

    // Wait for the data to be retrieved.
    await tester.pumpAndSettle();
    // Verify that the data is displayed.
    expect(find.text('My Media Event'), findsOneWidget);
    expect(find.text('My Student Event'), findsOneWidget);
  });
}
