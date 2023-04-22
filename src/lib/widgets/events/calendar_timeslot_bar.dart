import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class CalendarTimeslotBar extends StatelessWidget {
  final String timeslotTitle;
  final Color timeslotColor;

  const CalendarTimeslotBar(
      {Key? key, required this.timeslotColor, required this.timeslotTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: timeslotColor,
        ),
        padding:
            const EdgeInsets.only(bottom: 5, top: 5, left: 7.5, right: 7.5),
        child: Text(timeslotTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
            style: TextStyle(
                color: (timeslotColor == studentColor
                    ? Colors.black
                    : Colors.white),
                fontSize: 10,
                fontWeight: FontWeight.w600)));
  }
}
