import 'package:src/models/student/task.dart';
import 'package:src/utils/enums.dart';

final mockTasks = [
  Task(
      name: 'Setup database seeding',
      description: 'Put mock data in the database',
      priority: Priority.high,
      deadline: DateTime.now(),
      taskGroupId: 1,
      subjectId: 1,
      xp: 0,
      finished: false),
  Task(
      name: 'Dentist appointment',
      description: 'Get braces',
      priority: Priority.high,
      deadline: DateTime.now(),
      xp: 0,
      finished: true),
  Task(
      name: 'Stupid 1',
      description: 'Get braces',
      priority: Priority.high,
      deadline: DateTime(2021, 10, 10),
      xp: 0,
      taskGroupId: 2,
      subjectId: 1,
      finished: true),
  Task(
      name: 'Dentist appointment',
      description: 'Get braces',
      priority: Priority.high,
      deadline: DateTime(2021, 10, 10),
      xp: 0,
      taskGroupId: 2,
      subjectId: 1,
      finished: true),
];
