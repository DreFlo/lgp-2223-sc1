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
        child: MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: primaryColor,
                onPrimary: Colors.white,
                background: appBackground,
                onBackground: lightGray,
              ),
            ),
            home: MonthView(
              showBorder: false,
              initialMonth: DateTime.now(),
              controller: eventController,
              headerStyle: const HeaderStyle(
                leftIcon: Icon(Icons.calendar_month),
                decoration: BoxDecoration(color: appBackground),
                headerTextStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              headerStringBuilder: (date, {secondaryDate}) {
                return "${date.month.toString}/${date.year}";
              },
              },
              // to provide custom UI for month cells.
              cellBuilder: (date, timeslots, isToday, isInMonth) {
                return Container(
                    alignment: Alignment.topCenter,
                    foregroundDecoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 0),
                    ),
                    decoration: BoxDecoration(
                      color: (isInMonth ? lightGray : grayButton),
                      border: Border.all(width: 0, color: Colors.transparent),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: (isToday ? primaryColor : Colors.white),
                          fontSize: 12,
                          fontWeight:
                              (isToday ? FontWeight.w600 : FontWeight.w500)),
                    ));
              },
              minMonth: DateTime(1990),
              maxMonth: DateTime(2050),
              cellAspectRatio: 1,
              onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
              onCellTap: (events, date) {
                // Implement callback when user taps on a cell.
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DayView(
                          controller: eventController,
                          // eventTileBuilder: (date, events, boundry, start, end) {
                          //   // Return your widget to display as event tile.
                          //   return Container();
                          // },
                          // fullDayEventBuilder: (events, date) {
                          //   // Return your widget to display full day event view.
                          //   return Container();
                          // },
                          showVerticalLine:
                              true, // To display live time line in day view.
                          showLiveTimeLineInAllDays:
                              true, // To display live time line in all pages in day view.
                          minDay: DateTime(1990),
                          maxDay: DateTime(2050),
                          initialDay: DateTime(2021),
                          heightPerMinute:
                              1, // height occupied by 1 minute time span.
                          eventArranger:
                              SideEventArranger(), // To define how simultaneous events will be arranged.
                          onEventTap: (events, date) => print(events),
                          onDateLongPress: (date) => print(date),
                        )));
              },
              startDay: WeekDays.monday, // To change the first day of the week.
              // This callback will only work if cellBuilder is null.
              onEventTap: (event, date) => print(event),
              onDateLongPress: (date) => print(date),
            )));
  }
}
