import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';

import 'package:src/themes/colors.dart';

class MyEventCard extends StatefulWidget {
  final TimeslotMediaTimeslotSuperEntity? mediaEvent;
  final TimeslotStudentTimeslotSuperEntity? studentEvent;
  final String module;

  const MyEventCard(
      {Key? key, this.mediaEvent, this.studentEvent, required this.module})
      : super(key: key);

  @override
  State<MyEventCard> createState() => _MyEventCardState();
}

class _MyEventCardState extends State<MyEventCard> {
  final Map<String, Color> moduleColors = {
    'Student': studentColor,
    'Leisure': leisureColor,
    'Personal': personalColor,
    'Fitness': fitnessColor,
  };

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

  String getDate(item) { //maybe just use Margarida's function? It looks so pretty but don't need time
    String startDate =
          "${item.startDateTime.day.toString()}/${item.startDateTime.month.toString()}";
    String endDate =
          "${item.endDateTime.day.toString()}/${item.endDateTime.month.toString()}";
    return "$startDate-$endDate";
  }

  @override
  Widget build(BuildContext context) {
     dynamic item = widget.mediaEvent ?? widget.studentEvent;
    return GestureDetector(
        onTap: () {
          // TODO - Navigate to task page
        },
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 33),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: grayButton,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(
                      left: 25, right: 19, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: moduleColors[widget.module],
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200, // Set width of Text widget to 200
                    child: Text(item.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    //formatDeadline(item.startDateTime),
                    getDate(item),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ]),
            Container(
                margin: const EdgeInsets.only(right: 26),
                child: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 17))
          ]),
        ));
  }
}
