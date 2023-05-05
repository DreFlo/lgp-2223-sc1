// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:src/models/student/task.dart';
import 'package:src/themes/colors.dart';

class TimeslotTaskBar extends StatefulWidget {
  final Task task;
  bool taskStatus = false;

  TimeslotTaskBar({Key? key, required this.task}) : super(key: key);

  @override
  State<TimeslotTaskBar> createState() => _TimeslotTaskBarState();
}

class _TimeslotTaskBarState extends State<TimeslotTaskBar> {
  late bool taskStatus;

  String getDateText() {
    return "${widget.task.deadline.day.toString()}/${widget.task.deadline.month.toString()}/${widget.task.deadline.year.toString()}";
  }

  @override
  void initState() {
    if (widget.task.finished) {
      taskStatus = true;
    } else {
      taskStatus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: lightGray),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(widget.task.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(getDateText(),
                style: const TextStyle(
                    color: Color.fromARGB(255, 127, 127, 127),
                    fontSize: 10,
                    fontWeight: FontWeight.normal))
          ])
        ]),
        const SizedBox(width: 20),
        Column(
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      return setState(() {
                        taskStatus = !taskStatus;
                        widget.taskStatus = taskStatus;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (widget.taskStatus
                              ? Colors.white
                              : Colors.green)),
                      child: const Icon(Icons.check_rounded, size: 20),
                    ))
              ],
            )
          ],
        )
      ]),
    );
  }
}
