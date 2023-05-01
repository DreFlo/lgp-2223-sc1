import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class TimeslotTaskBar extends StatefulWidget {
  final int taskId;
  final String title, dueDate;
  bool taskStatus;

  TimeslotTaskBar(
      {Key? key,
      required this.taskId,
      required this.title,
      required this.dueDate,
      required this.taskStatus})
      : super(key: key);

  @override
  State<TimeslotTaskBar> createState() => _TimeslotTaskBarState();
}

class _TimeslotTaskBarState extends State<TimeslotTaskBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: lightGray),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(widget.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(widget.dueDate,
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
                        widget.taskStatus = !widget.taskStatus;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (widget.taskStatus
                              ? Colors.green
                              : Colors.white)),
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
