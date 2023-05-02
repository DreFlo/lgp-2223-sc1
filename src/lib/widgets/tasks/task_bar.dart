import 'package:flutter/material.dart';
import 'package:src/models/student/task.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';

class TaskBar extends StatefulWidget {
  final bool taskStatus;

  final Task task;
  final void Function(Task n) onSelected, onUnselected, editTask;
  final void Function() deleteTask;

  final int? taskGroupId;

  const TaskBar({
    Key? key,
    required this.taskStatus,
    required this.task,
    required this.onSelected,
    required this.onUnselected,
    required this.editTask,
    required this.deleteTask,
    this.taskGroupId,
  }) : super(key: key);

  @override
  State<TaskBar> createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  late bool taskStatus;

  late Task task;
  late void Function(Task n) onSelected, onUnselected, editTask;
  late void Function() deleteTask;
  late int? taskGroupId;
  bool selected = false;

  @override
  initState() {
    taskStatus = widget.task.finished;

    task = widget.task;
    onUnselected = widget.onUnselected;
    onSelected = widget.onSelected;
    editTask = widget.editTask;
    deleteTask = widget.deleteTask;
    taskGroupId = widget.taskGroupId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF22252D),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
          builder: (context) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 50),
              child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.75,
                  minChildSize: 0.75,
                  maxChildSize: 0.75,
                  builder: (context, scrollController) => TaskForm(
                        id: task.id,
                        taskGroupId: taskGroupId,
                        callback: editTask,
                        deleteCallback: deleteTask,
                        scrollController: scrollController,
                      ))));
    }, child: Builder(builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? grayButton : lightGray),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              flex: 6,
              child: Column(children: [
                Row(children: [
                  Expanded(
                    child: Text(task.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: selected ? Colors.black : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  )
                ]),
                Row(children: [
                  Text(DateFormatter.format(task.deadline),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 127, 127, 127),
                          fontSize: 16,
                          fontWeight: FontWeight.normal))
                ])
              ])),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                                    (taskStatus ? Colors.white : Colors.green)),
                            child: Icon(Icons.check_rounded,
                                color: (!taskStatus
                                    ? Colors.white
                                    : Colors.green)),
                          )),
                      const SizedBox(width: 10),
                      InkWell(
                          onTap: () {
                            if (selected) {
                              onUnselected(task);
                            } else {
                              onSelected(task);
                            }
                            setState(() {
                              selected = !selected;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: primaryColor),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          )),
                    ],
                  )
                ],
              ))
        ]),
      );
    }));
  }
}
