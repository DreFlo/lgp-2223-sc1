import 'package:src/models/student/task.dart';
import 'package:src/utils/enums.dart';

final mockTasks = [
  Task(
      name: 'Install flutter packages',
      description: 'Run flutter pub get',
      priority: Priority.high,
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      taskGroupId: 1,
      subjectId: 1,
      xp: 10),
  Task(
      name: 'Setup database seeding',
      description: 'Put mock data in the database',
      priority: Priority.high,
      deadline: DateTime.now(),
      taskGroupId: 1,
      subjectId: 1,
      xp: 30),
  Task(
      name: 'Frontend setup',
      description: 'Create the frontend of the app',
      priority: Priority.high,
      deadline: DateTime.now().add(const Duration(hours: 1)),
      taskGroupId: 1,
      subjectId: 1,
      xp: 30),
];
