import 'package:flutter/material.dart';
import 'package:src/pages/dashboard.dart';
import 'package:src/widgets/dashboard/dashboard_card.dart';

class DashBoardGridView extends StatefulWidget {
  final List<Project> items;

  const DashBoardGridView({Key? key, required this.items}) : super(key: key);

  @override
  State<DashBoardGridView> createState() => _DashBoardGridViewState();
}

class _DashBoardGridViewState extends State<DashBoardGridView> {
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
            return DashboardCard(
                title: item.title,
                module: item.module,
                subject: item.subject,
                institution: item.institution,
                nTasks: item.nTasks);
          },
        ));
  }
}
