import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/authentication_dao.dart';
import 'package:src/daos/log_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/user.dart';
import 'package:src/models/user_badge.dart';
import 'package:src/pages/gamification/gained_xp_toast.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/tasks/task_show_bar.dart';

import '../../../utils/locations_injector.dart';
import '../../../utils/service_locator_test_util.dart';

void callback() {}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  testWidgets('test if XP gain is accused', (WidgetTester widgetTester) async {
        final user = User(
        id:1, 
        name: 'Emil',
        email: 'emil@gmail.com',
        password: 'test',
        xp: 200,
        level: 1,
        imagePath: '');

    final mockUserDao = serviceLocator.get<UserDao>();
    when(mockUserDao.findUserById(1)).thenAnswer((_) => Stream.value(user));

    final mockAuthenticationDao = serviceLocator.get<AuthenticationDao>();
    when(mockAuthenticationDao.getLoggedInUser()).thenAnswer((_) => user);
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


    final mockTaskStudentTimeslotDao =
        serviceLocator.get<TaskStudentTimeslotDao>();
    when(mockTaskStudentTimeslotDao.findStudentTimeslotIdByTaskId(1))
        .thenAnswer((_) => Future.value(<int>[]));

    int id = 1;
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: Scaffold(
            body: TaskShowBar(
      key: const Key("task_1"),
      taskGroup: TaskGroup(
          name: 'Install flutter packages',
          description: 'Run flutter pub get',
          id: 1,
          subjectId: 1,
          deadline: DateTime.now(),
          priority: Priority.high),
      task: Task(
          name: 'Install flutter packages',
          description: 'Run flutter pub get',
          priority: Priority.high,
          deadline: DateTime.now().subtract(const Duration(days: 1)),
          taskGroupId: 1,
          subjectId: 1,
          xp: 10,
          id: 1,
          finished: false),
      callback: callback,
    ))));

    var task = find.byKey(Key('task_$id'), skipOffstage: false);
    expect(task, findsOneWidget);

    var button = find.byType(InkWell, skipOffstage: false).at(1);
    await widgetTester.tap(button, warnIfMissed: false);
    await widgetTester.pumpAndSettle(const Duration(milliseconds: 750));
    expect(find.byType(GainedXPToast, skipOffstage: false), findsOneWidget);
  });
}
