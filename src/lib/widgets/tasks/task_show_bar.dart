import 'package:flutter/material.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/task_show.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';
import 'package:src/utils/gamification/game_logic.dart';

class TaskShowBar extends StatefulWidget {
  final void Function(Task t)? editTask;
  final void Function()? deleteTask;
  final TaskGroup taskGroup;
  final Task task;

  const TaskShowBar({
    Key? key,
    required this.taskGroup,
    required this.task,
    this.editTask,
    this.deleteTask,
  }) : super(key: key);

  @override
  State<TaskShowBar> createState() => _TaskShowBarState();
}

class _TaskShowBarState extends State<TaskShowBar> {
  late bool taskStatus;

  late TaskGroup taskGroup;
  late Task task;
  bool selected = false;

  @override
  initState() {
    taskStatus = widget.task.finished;
    taskGroup = widget.taskGroup;
    task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
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
                      builder: (context, scrollController) => //SizedBox()
                          TaskShow(
                            scrollController: scrollController,
                            taskGroup: taskGroup,
                            task: task,
                            callback: widget.editTask,
                            deleteCallback: widget.deleteTask,
                          ))));
        },
        child: Container(
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
                flex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () async {
                            if (!taskStatus) {
                              //it's currently false, going to become true, when it gets to setState
                              //gain xp
                              checkNonEventNonTask(task, context, true);
                            } else {
                              //lose xp
                              removePoints(getImmediatePoints(), task);
                            }

                            setState(() {
                              taskStatus = !taskStatus;
                            });
                          },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (taskStatus
                                      ? Colors.white
                                      : Colors.green)),
                              child: Icon(Icons.check_rounded,
                                  color: (!taskStatus
                                      ? Colors.white
                                      : Colors.green)),
                            )),
                      ],
                    )
                  ],
                ))
          ]),
        ));
  }
}
