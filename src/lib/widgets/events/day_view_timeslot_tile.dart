import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:src/themes/colors.dart';

class DayViewTimeslotTile extends StatelessWidget {
  final CalendarEventData event;

  const DayViewTimeslotTile({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 1, right: 5),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: event.color,
            ),
            child: Wrap(spacing: 5, runSpacing: 5, children: [
              Row(children: [
                Expanded(
                    child: Text(event.title,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: (event.color == studentColor
                                ? Colors.black
                                : Colors.white),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)))
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: Text(
                        "${DateFormat('hh:mm').format(event.startTime!)} - ${DateFormat('hh:mm').format(event.endTime!)}",
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: (event.color == studentColor
                                ? Colors.black
                                : Colors.white),
                            fontSize: 14,
                            fontWeight: FontWeight.w400)))
              ])
            ])));
  }
}
