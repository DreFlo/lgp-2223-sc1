// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/user.dart';
import 'package:src/pages/gamification/gained_xp_toast.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/tasks/task_bar.dart';

import '../../../utils/locations_injector.dart';
import '../../../utils/service_locator_test_util.dart';
import '../../../utils/service_locator_test_util.mocks.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  testWidgets('test if XP gain is accused', (WidgetTester widgetTester) async {
    final user = User(
        userName: 'Emil', password: 'test', xp: 300, level: 2, imagePath: '');

    final mockUserDao = serviceLocator.get<UserDao>();
    when(mockUserDao.findUserById(1)).thenAnswer((_) => Stream.value(user));

    final mockTaskStudentTimeslotDao =
        serviceLocator.get<TaskStudentTimeslotDao>();
    when(mockTaskStudentTimeslotDao.findStudentTimeslotIdByTaskId(1))
        .thenAnswer((_) => Future.value(<int>[]));

    int id = 1;
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: Scaffold(body:TaskBar(
            key: const Key("task_1"),
            taskStatus: false,
            deleteTask: () {},
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
            editTask: (Task t) {},
            onSelected: (Task n) {},
            onUnselected: (Task n) {}))));

    var task = find.byKey(Key('task_$id'), skipOffstage: false);
    expect(task, findsOneWidget);

    var button = find.byType(InkWell, skipOffstage: false).at(1);
    await widgetTester.tap(button, warnIfMissed: false);
    expect(find.byType(GainedXPToast, skipOffstage: false), findsOneWidget);
  });
}
