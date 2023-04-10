import 'package:src/models/student/task_group.dart';
import 'package:src/utils/enums.dart';

final mockTaskGroups = [
  TaskGroup(
    id: 1,
    name: 'Setup database seeding',
    description: 'Put mock data in the database',
    priority: Priority.high,
    deadline: DateTime.now().add(const Duration(days: 1)),
  )
];
