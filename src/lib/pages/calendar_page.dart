import 'dart:async';

import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';
import 'package:src/widgets/events/calendar_timeslot_bar.dart';
import 'package:src/widgets/events/day_view_timeslot_tile.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

final GlobalKey key = GlobalKey();

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

  checkMediaEventMultipleDays() {
    for (var i = 0; i < mediaEvents.length; i++) {
      if (mediaEvents[i].startDateTime.day != mediaEvents[i].endDateTime.day) {
        final TimeslotMediaTimeslotSuperEntity subEvent =
            TimeslotMediaTimeslotSuperEntity(
                title: mediaEvents[i].title,
                description: mediaEvents[i].description,
                startDateTime: mediaEvents[i].startDateTime,
                endDateTime: DateTime(
                    mediaEvents[i].startDateTime.year,
                    mediaEvents[i].startDateTime.month,
                    mediaEvents[i].startDateTime.day,
                    23,
                    59,
                    59),
                xpMultiplier: mediaEvents[i].xpMultiplier,
                userId: mediaEvents[i].userId);
        DateTime oldEndDateTime = mediaEvents[i].endDateTime;
        mediaEvents.removeAt(i);
        mediaEvents.insert(i, subEvent);
        final TimeslotMediaTimeslotSuperEntity newEvent =
            TimeslotMediaTimeslotSuperEntity(
                title: mediaEvents[i].title,
                description: mediaEvents[i].description,
                startDateTime: DateTime(oldEndDateTime.year,
                    oldEndDateTime.month, oldEndDateTime.day, 0, 0, 0),
                endDateTime: oldEndDateTime,
                xpMultiplier: mediaEvents[i].xpMultiplier,
                userId: mediaEvents[i].userId);
        mediaEvents.add(newEvent);
      }
    }
  }

  checkStudentEventMultipleDays() {
    for (var i = 0; i < studentEvents.length; i++) {
      if (studentEvents[i].startDateTime.day !=
          studentEvents[i].endDateTime.day) {
        final TimeslotStudentTimeslotSuperEntity subEvent =
            TimeslotStudentTimeslotSuperEntity(
                title: studentEvents[i].title,
                description: studentEvents[i].description,
                startDateTime: studentEvents[i].startDateTime,
                endDateTime: DateTime(
                    studentEvents[i].startDateTime.year,
                    studentEvents[i].startDateTime.month,
                    studentEvents[i].startDateTime.day,
                    23,
                    59,
                    59),
                xpMultiplier: studentEvents[i].xpMultiplier,
                userId: studentEvents[i].userId);
        DateTime oldEndDateTime = studentEvents[i].endDateTime;
        studentEvents.removeAt(i);
        studentEvents.insert(i, subEvent);
        final TimeslotStudentTimeslotSuperEntity newEvent =
            TimeslotStudentTimeslotSuperEntity(
                title: studentEvents[i].title,
                description: studentEvents[i].description,
                startDateTime: DateTime(oldEndDateTime.year,
                    oldEndDateTime.month, oldEndDateTime.day, 0, 0, 0),
                endDateTime: oldEndDateTime,
                xpMultiplier: studentEvents[i].xpMultiplier,
                userId: studentEvents[i].userId);
        studentEvents.add(newEvent);
      }
    }
  }

  void loadEventsDB() async {
    mediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllTimeslotMediaTimeslot();
    studentEvents = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
        .findAllTimeslotStudentTimeslot();
    checkMediaEventMultipleDays();
    checkStudentEventMultipleDays();
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
    String title = '';
    DateTime startTime = DateTime.now(), endTime = DateTime.now();
    if (loadedAllData) {
      for (var timeslot in items) {
        if (timeslot is TimeslotMediaTimeslotSuperEntity) {
          title = timeslot.title;
          startTime = timeslot.startDateTime;
          endTime = timeslot.endDateTime;
        } else if (timeslot is TimeslotStudentTimeslotSuperEntity) {
          title = timeslot.title;
          startTime = timeslot.startDateTime;
          endTime = timeslot.endDateTime;
        }
        Color eventColor = timeslot is TimeslotMediaTimeslotSuperEntity
            ? leisureColor
            : timeslot is TimeslotStudentTimeslotSuperEntity
                ? studentColor
                : primaryColor;
        eventController.add(CalendarEventData(
            title: title,
            date: startTime,
            startTime: startTime,
            endTime: endTime,
            color: eventColor));
      }
      // Manually complete the future when the data is ready
      _eventsAddedCompleter.complete();
    }
  }

  final Completer<void> _eventsAddedCompleter = Completer<void>();

  List<Widget> getTimeslots(List<CalendarEventData<Object?>> timeslots) {
    List<Widget> timeslotWidgets = [];

    for (var timeslot in timeslots) {
      timeslotWidgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: InkWell(
              child: CalendarTimeslotBar(
                  timeslotTitle: timeslot.title, timeslotColor: timeslot.color),
              onTap: () async {
                //TODO: Open timeslot form.
              })));
    }

    return timeslotWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _eventsAddedCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MonthView(
            showBorder: false,
            useAvailableVerticalSpace: true,
            initialMonth: DateTime.now(),
            controller: eventController,
            headerStyle: HeaderStyle(
              headerPadding: const EdgeInsets.symmetric(vertical: 10),
              leftIcon: const Icon(Icons.calendar_month, color: Colors.white),
              rightIcon: InkWell(
                  child: const Icon(Icons.view_week, color: Colors.white),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeekView()));
                  }),
              decoration: const BoxDecoration(color: appBackground),
              headerTextStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            headerStringBuilder: (date, {secondaryDate}) {
              return "${DateFormat.MMMM().format(date)} ${date.year}";
            },
            weekDayBuilder: (day) {
              return Container(
                  color: appBackground,
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(DateFormat.EEEE().format(DateTime(day))[0],
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)));
            },
            cellBuilder: (date, timeslots, isToday, isInMonth) {
              return Container(
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.topLeft,
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 0),
                  ),
                  decoration: BoxDecoration(
                    color: (isInMonth ? lightGray : grayButton),
                    border: Border.all(width: 0, color: Colors.transparent),
                  ),
                  child: Wrap(spacing: 10, children: [
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: (isToday ? primaryColor : Colors.white),
                          fontSize: 12,
                          fontWeight:
                              (isToday ? FontWeight.w600 : FontWeight.w500)),
                    ),
                    ...getTimeslots(timeslots)
                  ]));
            },
            cellAspectRatio: 0.5,
            onCellTap: (events, date) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Material(
                  color: appBackground,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DayView(
                        heightPerMinute: 2.0,
                        initialDay: date,
                        liveTimeIndicatorSettings:
                            const HourIndicatorSettings(color: primaryColor),
                        showVerticalLine: true,
                        controller: eventController,
                        backgroundColor: lightGray,
                        dateStringBuilder: (date, {secondaryDate}) {
                          return DateFormat('EEEE, MMMM d yyyy')
                              .format(date)
                              .toString();
                        },
                        timeLineBuilder: (date) {
                          return Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                DateFormat('h:mm a').format(date),
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ));
                        },
                        verticalLineOffset: 10,
                        headerStyle: HeaderStyle(
                          headerPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          leftIcon: InkWell(
                              child:
                                  const Icon(Icons.close, color: Colors.white),
                              onTap: () {
                                Navigator.pop(context);
                              }),
                          rightIconVisible: false,
                          decoration: const BoxDecoration(color: appBackground),
                          headerTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        eventTileBuilder: (date, events, boundary,
                                startDuration, endDuration) =>
                            InkWell(
                                onTap: () {
                                  //TODO: open event form
                                },
                                child:
                                    DayViewTimeslotTile(event: events.single))),
                  ),
                ),
              ));
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
