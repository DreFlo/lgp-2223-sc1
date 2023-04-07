import 'package:flutter/material.dart';
import 'package:src/pages/my_dashboard.dart';
import 'package:src/widgets/dashboard/my_dashboard_card.dart';

class MyDashBoardGridView extends StatefulWidget {
  final List<Project> items;

  const MyDashBoardGridView({Key? key, required this.items}) : super(key: key);

  @override
  State<MyDashBoardGridView> createState() => _MyDashBoardGridViewState();
}

class _MyDashBoardGridViewState extends State<MyDashBoardGridView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 23, right: 23),
        child: GridView.builder(
          itemCount: widget.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.81,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Project item = widget.items[index];
            return MyDashboardCard(
                title: item.title,
                module: item.module,
                subject: item.subject,
                institution: item.institution,
                nTasks: item.nTasks);
          },
        ));
  }
}
