// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:src/models/media/media.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';

class TimeslotMediaBar extends StatefulWidget {
  final Media media;
  bool taskStatus = false;

  TimeslotMediaBar({Key? key, required this.media}) : super(key: key);

  @override
  State<TimeslotMediaBar> createState() => _TimeslotMediaBarState();
}

class _TimeslotMediaBarState extends State<TimeslotMediaBar> {
  @override
  initState() {
    if (widget.media.status == Status.done) {
      widget.taskStatus = true;
    } else {
      widget.taskStatus = false;
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
            Text(widget.media.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600))
          ]),
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
                          color: (widget.taskStatus ? Colors.white : Colors.green)),
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
