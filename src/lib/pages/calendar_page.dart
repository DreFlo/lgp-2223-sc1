import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/themes/colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  EventController<Timeslot> eventController = EventController<Timeslot>();

  @override
  initState() {
    super.initState();
    //TODO: Get events from database.
    var databaseTimeslots = [
      Timeslot(
          id: 1,
          title: "Test",
          description: "Test",
          startDateTime: DateTime.now(),
          endDateTime: DateTime.now().add(Duration(hours: 1)),
          userId: 1,
          xpMultiplier: 2),
      Timeslot(
          id: 2,
          title: "Test2",
          description: "Test",
          startDateTime: DateTime.now().add(Duration(days: 1)),
          endDateTime:
              DateTime.now().add(Duration(days: 1)).add(Duration(hours: 1)),
          userId: 1,
          xpMultiplier: 2),
    ];

    for (var timeslot in databaseTimeslots) {
      eventController.add(CalendarEventData(
          title: timeslot.title,
          date: timeslot.startDateTime,
          startTime: timeslot.startDateTime,
          endTime: timeslot.endDateTime,
          color: leisureColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Timeslot>(
        controller: eventController,
        child: MonthView(
          controller: eventController,
          // to provide custom UI for month cells.
          minMonth: DateTime(1990),
          maxMonth: DateTime(2050),
          initialMonth: DateTime(2021),
          cellAspectRatio: 1,
          onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
          onCellTap: (events, date) {
            // Implement callback when user taps on a cell.
            
          },
          startDay: WeekDays.monday, // To change the first day of the week.
          // This callback will only work if cellBuilder is null.
          onEventTap: (event, date) => print(event),
          onDateLongPress: (date) => print(date),
        ));
  }
}
