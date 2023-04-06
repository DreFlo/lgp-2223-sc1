import 'package:flutter/material.dart';

import '../../models/student/task.dart';
import '../../utils/enums.dart';
import 'my_task_card.dart';

class MyTaskListView extends StatefulWidget {
  const MyTaskListView({Key? key}) : super(key: key);

  @override
  State<MyTaskListView> createState() => _MyTaskListViewState();
}

class _MyTaskListViewState extends State<MyTaskListView> {
  // TODO - get tasks from database
  // TODO - change logic when we have events (leisure) - for now everything is tasks and description is being used to distinguish between modules
  List<Task> items = [
    Task(
        id: 1,
        name: 'Ginásio',
        description: 'Student',
        deadline: DateTime(2023, 3, 31, 5),
        priority: Priority.high,
        taskGroupId: 1),
    Task(
        id: 1,
        name: 'Kirby & The Forgotten Land',
        description: 'Leisure',
        deadline: DateTime(2023, 4, 3, 10),
        priority: Priority.medium,
        taskGroupId: 1),
    Task(
        id: 1,
        name: 'Caminhar',
        description: 'Personal',
        deadline: DateTime(2023, 4, 4, 5),
        priority: Priority.low,
        taskGroupId: 1),
    Task(
        id: 1,
        name: 'Treino 5 Minutos',
        description: 'Fitness',
        deadline: DateTime(2023, 4, 5, 8),
        priority: Priority.high,
        taskGroupId: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            for (var item in items)
              MyTaskCard(
                  name: item.name,
                  deadline: item.deadline,
                  module: item.description)
          ],
        ));
  }
}
