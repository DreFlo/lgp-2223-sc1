import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/pages/events/event_show.dart';

import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';

class MyEventCard extends StatefulWidget {
  final TimeslotMediaTimeslotSuperEntity? mediaEvent;
  final TimeslotStudentTimeslotSuperEntity? studentEvent;
  final String module;
  final Function() callback;

  const MyEventCard(
      {Key? key,
      this.mediaEvent,
      this.studentEvent,
      required this.module,
      required this.callback})
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

  String formatDate(DateTime date) {
    // Use Today; Tomorrow and in X days (using start date for the calculation)
    Map<int, String> suffixes = {
      1: 'st',
      2: 'nd',
      3: 'rd',
    };

    String ordinalDay = (date.day >= 11 && date.day <= 13)
        ? 'th'
        : suffixes[date.day % 10] ?? 'th';

    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

    bool isToday = DateTime.now().day == date.day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year;
    bool isTomorrow = tomorrow.day == date.day &&
        tomorrow.month == date.month &&
        tomorrow.year == date.year;
    int daysDifference = date.difference(DateTime.now()).inDays;

    if (isToday) {
      return 'Today at ${DateFormat("ha").format(date).replaceAll('AM', 'am').replaceAll('PM', 'pm')}';
    }
    if (isTomorrow) {
      return 'Tomorrow at ${DateFormat("ha").format(date).replaceAll('AM', 'am').replaceAll('PM', 'pm')}';
    }
    if (daysDifference > 0 && daysDifference < 7) {
      return DateFormat("EEEE - ha")
          .format(date)
          .replaceAll('AM', 'am')
          .replaceAll('PM', 'pm');
    }
    return DateFormat("MMM d'$ordinalDay' - ha")
        .format(date)
        .replaceAll('AM', 'am')
        .replaceAll('PM', 'pm');
  }

  @override
  Widget build(BuildContext context) {
    Object? item = widget.mediaEvent ?? widget.studentEvent;
    String title = '';
    String date = '';

    if (item is TimeslotMediaTimeslotSuperEntity) {
      title = item.title;
      date = formatDate(item.startDateTime);
    } else if (item is TimeslotStudentTimeslotSuperEntity) {
      title = item.title;
      date = formatDate(item.startDateTime);
    }

    return GestureDetector(
        onTap: () {
          int id = 0;
          EventType type = EventType.leisure;
          if (item is TimeslotMediaTimeslotSuperEntity) {
            id = item.id!;
          } else if (item is TimeslotStudentTimeslotSuperEntity) {
            id = item.id!;
            type = EventType.student;
          }

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
                      builder: (context, scrollController) => EventShow(
                            scrollController: scrollController,
                            id: id,
                            type: type,
                            callback: widget.callback,
                          ))));
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
              const SizedBox(width: 19),
              SizedBox(
                  width: 131,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 5),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  )),
            ]),
            Container(
                margin: const EdgeInsets.only(right: 15),
                child: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 17))
          ]),
        ));
  }
}
