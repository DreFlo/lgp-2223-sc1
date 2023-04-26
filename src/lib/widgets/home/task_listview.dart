import 'package:flutter/material.dart';

import 'package:src/models/student/task.dart';
import 'package:src/widgets/home/task_card.dart';

class MyTaskListView extends StatefulWidget {
  final List<Task> items;

  const MyTaskListView({Key? key, required this.items}) : super(key: key);

  @override
  State<MyTaskListView> createState() => _MyTaskListViewState();
}

class _MyTaskListViewState extends State<MyTaskListView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            for (var item in widget.items)
              MyTaskCard(
                  name: item.name,
                  deadline: item.deadline,
                  module: item.description)
          ],
        ));
  }
}
