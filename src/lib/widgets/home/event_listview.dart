import 'package:flutter/material.dart';

import '../../models/student/task.dart';
import 'event_card.dart';

class MyEventListView extends StatefulWidget {
  final List<Task> items;

  const MyEventListView({Key? key, required this.items}) : super(key: key);

  @override
  State<MyEventListView> createState() => _MyEventListViewState();
}

class _MyEventListViewState extends State<MyEventListView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            for (var item in widget.items)
              MyEventCard(
                  name: item.name,
                  deadline: item.deadline,
                  module: item.description)
          ],
        ));
  }
}
