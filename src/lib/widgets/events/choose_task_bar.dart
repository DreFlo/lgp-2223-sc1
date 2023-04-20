// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:src/pages/events/choose_task_form.dart';
import 'package:src/themes/colors.dart';

class ChooseTaskBar extends StatefulWidget {
  final ChooseTask task;

  const ChooseTaskBar(
      {Key? key,
        required this.task})
      : super(key: key);

  @override
  State<ChooseTaskBar> createState() => _ChooseTaskBarState();
}

class _ChooseTaskBarState extends State<ChooseTaskBar> {

  formatDeadline(DateTime deadline) {
    Map<int, String> suffixes = {
      1: 'st',
      2: 'nd',
      3: 'rd',
    };

    String ordinalDay = (deadline.day >= 11 && deadline.day <= 13)
        ? 'th'
        : suffixes[deadline.day % 10] ?? 'th';

    return DateFormat("MMM d'$ordinalDay' - ha")
        .format(deadline)
        .replaceAll('AM', 'am')
        .replaceAll('PM', 'pm');
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
                Text(widget.task.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(formatDeadline(widget.task.deadline),
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
                            widget.task.isSelected = !widget.task.isSelected;
                          });
                        },
                        child: widget.task.isSelected
                            ? const Icon(Icons.check_box,
                            color: Colors.white, size: 30)
                            : const Icon(Icons.check_box_outline_blank,
                            color: Colors.white, size: 30)
                        )
                  ],
                )
              ],
            )
          ]),
        ));
  }
}
