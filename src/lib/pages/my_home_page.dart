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

import '../models/student/task.dart';
import '../utils/enums.dart';
import '../widgets/home/badge_placeholder.dart';

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

  // TODO - get tasks from database
  // TODO - change logic when we have events (leisure) - for now everything is tasks and description is being used to distinguish between modules

  //These should be events and not tasks -> get from DB 
  List<Task> items = [
    Task(
        id: 1,
        name: 'Ginásio',
        description: 'Student',
        deadline: DateTime(2023, 3, 31, 5),
        priority: Priority.high,
        taskGroupId: 1,
        subjectId: 1,
        xp: 0,
        finished: false),
    Task(
        id: 1,
        name: 'Kirby & The Forgotten Land',
        description: 'Leisure',
        deadline: DateTime(2023, 4, 3, 10),
        priority: Priority.medium,
        taskGroupId: 1,
        subjectId: 1,
        xp: 0,
        finished: false),
    Task(
        id: 1,
        name: 'Caminhar',
        description: 'Personal',
        deadline: DateTime(2023, 4, 4, 5),
        priority: Priority.low,
        taskGroupId: 1,
        subjectId: 1,
        xp: 0,
        finished: false),
    Task(
        id: 1,
        name: 'Treino 5 Minutos',
        description: 'Fitness',
        deadline: DateTime(2023, 4, 5, 8),
        priority: Priority.high,
        taskGroupId: 1,
        subjectId: 1,
        xp: 0,
        finished: false),
  ];

  @override 
  void initState() {
    super.initState();
    loadMediaEventsDB();
    loadStudentEventsDB();
  }

  void loadMediaEventsDB() async {
    mediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllTimeslotMediaTimeslot();
    setState(() {
      mediaEvents = mediaEvents;
    });
  }

  void loadStudentEventsDB() async {
    studentEvents = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
        .findAllTimeslotStudentTimeslot();
    setState(() {
      studentEvents = studentEvents;
    });
  }

  List<Task> filterItems() {
    switch (_selectedIndex) {
      case 1:
        return items
            .where((element) => element.description == 'Student')
            .toList();
      case 2:
        return items
            .where((element) => element.description == 'Leisure')
            .toList();
      case 3:
        return items
            .where((element) => element.description == 'Fitness')
            .toList();
      case 4:
        return items
            .where((element) => element.description == 'Personal')
            .toList();
      default:
        return items;
    }
  }

    showWidget() {
    switch (_selectedIndex) {
      case 1:
        return MyEventListView(
        studentEvents: studentEvents);
      case 2:
        return MyEventListView(
        mediaEvents: mediaEvents);
      default:
        return MyEventListView(studentEvents: studentEvents, mediaEvents: mediaEvents);
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
                nItems: items.length,
                selectedIndex: _selectedIndex,
                setSelectedIndex: (int index) =>
                    setState(() => _selectedIndex = index),
              ),
              Expanded(
                child: showWidget(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
