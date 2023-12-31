import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/service_locator.dart';
import '../utils/service_locator_test_util.dart';
import '../utils/locations_injector.dart';
import 'package:mockito/mockito.dart';
import 'package:src/pages/dashboard.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/utils/enums.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('DashBoardGridView displays data from the database',
      (WidgetTester tester) async {
    // Mock the data you expect to receive from the database.

    final task = Task(
        name: 'My Task',
        description: 'Do something',
        priority: Priority.high,
        xp: 1,
        finished: false,
        deadline: DateTime.now());
    final taskGroup = TaskGroup(
        name: 'My Task Group',
        description: 'Do something',
        priority: Priority.high,
        deadline: DateTime.now());

    final mockTaskDao = serviceLocator.get<TaskDao>();
    when(mockTaskDao.findTasksWithoutTaskGroup())
        .thenAnswer((_) async => [task]);

    final mockTaskGroupDao = serviceLocator.get<TaskGroupDao>();
    when(mockTaskGroupDao.findAllTaskGroups())
        .thenAnswer((_) async => [taskGroup]);

    await tester.pumpWidget(const LocalizationsInjector(child: Dashboard()));

    await tester.pumpAndSettle();
    expect(find.text('My Task'), findsOneWidget);
    expect(find.text('My Task Group'), findsOneWidget);
  });
}
