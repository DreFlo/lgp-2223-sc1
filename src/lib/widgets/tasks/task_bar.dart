import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class TaskBar extends StatefulWidget {
  final String title, dueDate;
  final bool taskStatus;

  const TaskBar(
      {Key? key,
      required this.title,
      required this.dueDate,
      required this.taskStatus})
      : super(key: key);

  @override
  State<TaskBar> createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  late bool taskStatus;

  @override
  initState() {
    taskStatus = widget.taskStatus;

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
                        ))
                  ],
                )
              ],
            )
          ]),
        ));
  }
}
