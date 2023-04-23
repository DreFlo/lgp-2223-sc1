import 'dart:async';

import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
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

  checkMultipleDays(List events, String eventType) {
    for (var i = 0; i < events.length; i++) {
      if (events[i].startDateTime.day != events[i].endDateTime.day) {
        final subEvent = eventType == 'media'
            ? TimeslotMediaTimeslotSuperEntity(
                title: events[i].title,
                description: events[i].description,
                startDateTime: events[i].startDateTime,
                endDateTime: DateTime(
                    events[i].startDateTime.year,
                    events[i].startDateTime.month,
                    events[i].startDateTime.day,
                    23,
                    59,
                    59),
                xpMultiplier: events[i].xpMultiplier,
                userId: events[i].userId)
            : TimeslotStudentTimeslotSuperEntity(
                title: events[i].title,
                description: events[i].description,
                startDateTime: events[i].startDateTime,
                endDateTime: DateTime(
                    events[i].startDateTime.year,
                    events[i].startDateTime.month,
                    events[i].startDateTime.day,
                    23,
                    59,
                    59),
                xpMultiplier: events[i].xpMultiplier,
                userId: events[i].userId);

        DateTime oldEndDateTime = events[i].endDateTime;
        events.removeAt(i);
        events.insert(i, subEvent);

        final newEvent = eventType == 'media'
            ? TimeslotMediaTimeslotSuperEntity(
                title: events[i].title,
                description: events[i].description,
                startDateTime: DateTime(oldEndDateTime.year,
                    oldEndDateTime.month, oldEndDateTime.day, 0, 0, 0),
                endDateTime: oldEndDateTime,
                xpMultiplier: events[i].xpMultiplier,
                userId: events[i].userId)
            : TimeslotStudentTimeslotSuperEntity(
                title: events[i].title,
                description: events[i].description,
                startDateTime: DateTime(oldEndDateTime.year,
                    oldEndDateTime.month, oldEndDateTime.day, 0, 0, 0),
                endDateTime: oldEndDateTime,
                xpMultiplier: events[i].xpMultiplier,
                userId: events[i].userId);

        events.add(newEvent);
      }
    }
  }

  void loadEventsDB() async {
    mediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllTimeslotMediaTimeslot();
    studentEvents = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
        .findAllTimeslotStudentTimeslot();
    checkMultipleDays(mediaEvents, 'media');
    checkMultipleDays(studentEvents, 'student');

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

  List<Widget> getTimeslots(List<CalendarEventData<Object?>> timeslots) {
    List<Widget> timeslotWidgets = [];

    for (var timeslot in timeslots) {
      timeslotWidgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: InkWell(
              child: CalendarTimeslotBar(
                  timeslotTitle: timeslot.title, timeslotColor: timeslot.color),
              onTap: () {
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
          return Container(
              alignment: Alignment.center,
              child: CalendarControllerProvider<Object>(
                controller: eventController,
                child: MonthView(
                  showBorder: false,
                  useAvailableVerticalSpace: true,
                  initialMonth: DateTime.now(),
                  controller: eventController,
                  headerStyle: const HeaderStyle(
                    headerPadding: EdgeInsets.symmetric(vertical: 10),
                    leftIcon: Icon(Icons.calendar_month, color: Colors.white),
                    rightIconVisible: false,
                    decoration: BoxDecoration(color: appBackground),
                    headerTextStyle: TextStyle(
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
                          border:
                              Border.all(color: Colors.transparent, width: 0),
                        ),
                        decoration: BoxDecoration(
                          color: (isInMonth ? lightGray : grayButton),
                          border:
                              Border.all(width: 0, color: Colors.transparent),
                        ),
                        child: Wrap(spacing: 10, children: [
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: (isToday ? primaryColor : Colors.white),
                                fontSize: 12,
                                fontWeight: (isToday
                                    ? FontWeight.w600
                                    : FontWeight.w500)),
                          ),
                          ...getTimeslots(timeslots)
                        ]));
                  },
                  cellAspectRatio: 0.5,
                  onCellTap: (events, date) {
                    //print(events);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Material(
                        color: appBackground,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: DayView(
                              initialDay: date,
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
                              heightPerMinute: 1.5,
                              headerStyle: const HeaderStyle(
                                headerPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                                leftIcon: Icon(Icons.calendar_month,
                                    color: Colors.white),
                                rightIconVisible: false,
                                decoration: BoxDecoration(color: appBackground),
                                headerTextStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              eventTileBuilder: (date, events, boundary,
                                      startDuration, endDuration) =>
                                      InkWell(
                                        onTap: () {
                                          //TODO: Open timeslot form.
                                        },
                                        child: 
                                  DayViewTimeslotTile(event: events.single))),
                        ),
                      ),
                    ));
                  },
                ),
              ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
