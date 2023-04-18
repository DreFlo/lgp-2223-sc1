// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/models/student/task.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/themes/colors.dart';

class TaskBar extends StatefulWidget {
  final String title, dueDate;
  final bool taskStatus;

  final Task task;
  final Function onSelected, onUnselected, editTask;
  final int? taskGroupId;

  const TaskBar(
      {Key? key,
      required this.title,
      required this.dueDate,
      required this.taskStatus,
      required this.task,
      required this.onSelected,
      required this.onUnselected,
      required this.editTask,
      this.taskGroupId})
      : super(key: key);

  @override
  State<TaskBar> createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  late bool taskStatus;

  late Task task;
  late Function onSelected, onUnselected, editTask;
  late int? taskGroupId;
  bool selected = false;

  @override
  initState() {
    taskStatus = widget.taskStatus;

    task = widget.task;
    onUnselected = widget.onUnselected;
    onSelected = widget.onSelected;
    editTask = widget.editTask;
    taskGroupId = widget.taskGroupId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          //TODO: Open task form filled out.
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: lightGray),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(widget.dueDate,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 127, 127, 127),
                        fontSize: 16,
                        fontWeight: FontWeight.normal))
              ])
            ]),
            Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            taskStatus = !taskStatus;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  (taskStatus ? Colors.green : Colors.white)),
                          child: const Icon(Icons.check_rounded, size: 20),
                        )),
                    ElevatedButton(
                        child: const Icon(Icons.delete),
                        onPressed: () {
                          if (selected) {
                            onUnselected(task);
                          } else {
                            onSelected(task);
                          }
                          setState(() {
                            selected = !selected;
                          });
                        }),
                    ElevatedButton(
                        child: const Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: const Color(0xFF22252D),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30.0)),
                              ),
                              builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  child: DraggableScrollableSheet(
                                      expand: false,
                                      initialChildSize: 0.75,
                                      minChildSize: 0.75,
                                      maxChildSize: 0.75,
                                      builder: (context, scrollController) =>
                                          TaskForm(
                                            task: task,
                                            taskGroupId: taskGroupId,
                                            callback: editTask,
                                            scrollController: scrollController,
                                          ))));
                        })
                  ],
                )
              ],
            )
          ]),
        ));
  }
}
