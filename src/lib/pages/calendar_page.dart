import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  EventController<Object> eventController = EventController<Object>();
  List<TimeslotMediaTimeslotSuperEntity> mediaEvents = [];
  bool loadedAllData = false;
  List<TimeslotStudentTimeslotSuperEntity> studentEvents = [];

  @override
  initState() {
    super.initState();
    loadEventsDB();
  }

  void loadEventsDB() async {
    mediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllTimeslotMediaTimeslot();
    studentEvents = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
        .findAllTimeslotStudentTimeslot();
    setState(() {
      mediaEvents = mediaEvents;
      studentEvents = studentEvents;
      loadedAllData = true;
    });
    addEventToCalendar();
  }

  List get items {
    if (loadedAllData) {
      final List combined = [];
      if (mediaEvents.isNotEmpty) {
        combined.addAll(mediaEvents);
      }
      if (studentEvents.isNotEmpty) {
        combined.addAll(studentEvents);
      }

      return combined;
    }
    return [];
  }

  Future<void> addEventToCalendar() async {
    if (loadedAllData) {
      for (var timeslot in items) {
        Color eventColor = timeslot is TimeslotMediaTimeslotSuperEntity
            ? leisureColor
            : timeslot is TimeslotStudentTimeslotSuperEntity
                ? studentColor
                : primaryColor;
        eventController.add(CalendarEventData(
            title: timeslot.title,
            date: timeslot.startDateTime,
            startTime: timeslot.startDateTime,
            endTime: timeslot.endDateTime,
            color: eventColor));
      }
      // Manually complete the future when the data is ready
      _eventsAddedCompleter.complete();
    }
  }

  final Completer<void> _eventsAddedCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _eventsAddedCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CalendarControllerProvider<Object>(
            controller: eventController,
            child: MonthView(
              controller: eventController,
              // to provide custom UI for month cells.
              minMonth: DateTime(1990),
              maxMonth: DateTime(2050),
              initialMonth: DateTime.now(),
              cellAspectRatio: 1,
              onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
              onCellTap: (events, date) {
                // Implement callback when user taps on a cell.
              },
              startDay: WeekDays.monday, // To change the first day of the week.
              // This callback will only work if cellBuilder is null.
              onEventTap: (event, date) => print(event),
              onDateLongPress: (date) => print(date),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
