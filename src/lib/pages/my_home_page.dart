import 'package:flutter/material.dart';
import 'package:src/widgets/home/homepage_horizontal_scrollview.dart';
import 'package:src/widgets/home/profile_pic.dart';
import 'package:src/widgets/home/event_listview.dart';
import 'package:src/widgets/home/welcome_message.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';

import 'package:src/widgets/home/badge_placeholder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<TimeslotMediaTimeslotSuperEntity> mediaEvents = [];
  bool loadedAllData = false;
  List<TimeslotStudentTimeslotSuperEntity> studentEvents = [];
  String name = "Joaquim Almeida"; // TODO Get name from database

  @override
  void initState() {
    super.initState();
    loadEventsDB();
  }

  void loadEventsDB() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, 0, 0, 0);
    mediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllTimeslotMediaTimeslot(start);
    studentEvents = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
        .findAllTimeslotStudentTimeslot(start);
    setState(() {
      mediaEvents = mediaEvents;
      studentEvents = studentEvents;
      loadedAllData = true;
    });
  }

  showWidget() {
    switch (_selectedIndex) {
      case 1:
        return MyEventListView(studentEvents: studentEvents);
      case 2:
        return MyEventListView(mediaEvents: mediaEvents);
      default:
        return MyEventListView(
            studentEvents: studentEvents, mediaEvents: mediaEvents);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Padding(
              padding: EdgeInsets.only(right: 36, top: 36),
              child: ProfilePic()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 36, top: 90),
                  child: WelcomeMessage(name: name)),
              const BadgePlaceholder(),
              HorizontalScrollView(
                nItems: studentEvents.length + mediaEvents.length,
                selectedIndex: _selectedIndex,
                setSelectedIndex: (int index) =>
                    setState(() => _selectedIndex = index),
              ),
              loadedAllData ? Expanded(child: showWidget()) : Container()
            ],
          ),
        ],
      ),
    );
  }
}
