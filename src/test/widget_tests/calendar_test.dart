import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/service_locator.dart';
import '../utils/service_locator_test_util.dart';
import '../utils/locations_injector.dart';
import 'package:mockito/mockito.dart';
import 'package:src/pages/calendar_page.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('Calendar displays data from the database',
      (WidgetTester tester) async {
    // Create a mock of the TimeslotMediaTimeslotSuperDao
    final mediaEvent = TimeslotMediaTimeslotSuperEntity(
        title: 'My Media Event',
        description: 'Watch something',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        xpMultiplier: 1,
        id: 1,
        userId: 1);
    final studentEvent = TimeslotStudentTimeslotSuperEntity(
        title: 'My Student Event',
        description: 'Teach something',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        xpMultiplier: 1,
        id: 2,
        userId: 1);

    final mockMediaEventDao =
        serviceLocator.get<TimeslotMediaTimeslotSuperDao>();
    when(mockMediaEventDao.findAllTimeslotMediaTimeslot())
        .thenAnswer((_) async => [mediaEvent]);

    final mockStudentEventDao =
        serviceLocator.get<TimeslotStudentTimeslotSuperDao>();
    when(mockStudentEventDao.findAllTimeslotStudentTimeslot())
        .thenAnswer((_) async => [studentEvent]);

    await tester.pumpWidget(const LocalizationsInjector(child: CalendarPage()));
    await tester.pumpAndSettle();

    expect(find.text('My Media Event'), findsOneWidget);
    expect(find.text('My Student Event'), findsOneWidget);
  });
}
