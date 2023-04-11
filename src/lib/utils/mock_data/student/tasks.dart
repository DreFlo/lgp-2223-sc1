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
      xp: 30)
];
