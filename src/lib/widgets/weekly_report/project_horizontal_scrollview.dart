import 'package:flutter/material.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/weekly_report/project_card.dart';

class ProjectHorizontalScrollview extends StatelessWidget {
  final List<TaskGroup> contributedTaskGroups;

  const ProjectHorizontalScrollview(
      {super.key, required this.contributedTaskGroups});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            height: 130,
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: grayButton,
                    boxShadow: const [
                      BoxShadow(
                        color: studentColor,
                        offset: Offset(-5, -5),
                      ),
                    ],
                  ),
                  child: ProjectCard(
                    taskGroup: contributedTaskGroups[0],
                  ),
                ),
                Container(
                  width: 100,
                  height: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: grayButton,
                    boxShadow: const [
                      BoxShadow(
                        color: studentColor,
                        offset: Offset(-5, -5),
                      ),
                    ],
                  ),
                  child: ProjectCard(
                    taskGroup: contributedTaskGroups[0],
                  ),
                ),
                for (int i = 0; i < contributedTaskGroups.length; i++)
                  Container(
                    width: 100,
                    height: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: grayButton,
                      boxShadow: const [
                        BoxShadow(
                          color: studentColor,
                          offset: Offset(-5, -5),
                        ),
                      ],
                    ),
                    child: ProjectCard(
                      taskGroup: contributedTaskGroups[i],
                    ),
                  )
              ],
            )));
  }
}
