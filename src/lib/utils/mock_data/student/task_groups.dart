import 'package:src/models/student/task_group.dart';
import 'package:src/utils/enums.dart';

final mockTaskGroups = [
  TaskGroup(
      id: 1,
      name: 'Setup database seeding',
      description: 'Put mock data in the database',
      priority: Priority.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
      subjectId: 1),
  TaskGroup(
      id: 2,
      name: 'Stupid',
      description: 'Stupid mc stupid face',
      priority: Priority.high,
      deadline: DateTime.now(),
      subjectId: 1),
  TaskGroup(
      id: 3,
      name: 'Have dinner',
      description: 'Cook a meal',
      priority: Priority.high,
      deadline: DateTime.now()),
  TaskGroup(
      id: 4,
      name: 'Chores',
      description: 'Do the house chores',
      priority: Priority.high,
      deadline: DateTime.now()),
];
