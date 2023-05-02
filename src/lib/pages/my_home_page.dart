import 'package:flutter/material.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/pages/gamification/student_timeslot_finished_modal.dart';
import 'package:src/themes/colors.dart';
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
  List<TimeslotStudentTimeslotSuperEntity> finishedStudentEvents = [];
  List<Task> tasksFinishedEvent = [];
  Map<int, List<Task>> tasksFinishedEventMap = {};
  List<int> tasksIdsFinishedEvent = [];
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
    finishedStudentEvents =
        await serviceLocator<TimeslotStudentTimeslotSuperDao>()
            .findAllFinishedTimeslotStudentTimeslot(now);
    tasksFinishedEventMap = await getTaskIds();
    setState(() {
      mediaEvents = mediaEvents;
      studentEvents = studentEvents;
      finishedStudentEvents = finishedStudentEvents;
      tasksFinishedEventMap = tasksFinishedEventMap;
      loadedAllData = true;
      checkEventDone();
    });
  }

  Future<List<int>> getMediaIds(int id) async {
    return await serviceLocator<MediaMediaTimeslotDao>()
        .findMediaIdByMediaTimeslotId(id);
  }

  Future<Map<int, List<Task>>> getTaskIds() async {
    Map<int, List<Task>> tasksFinishedTimeslotMap = {};
    List<int> taskIds = [];
    List<Task> tasks = [];
    for (int i = 0; i < finishedStudentEvents.length; i++) {
      taskIds = [];
      taskIds = await serviceLocator<TaskStudentTimeslotDao>()
          .findTaskIdByStudentTimeslotId(finishedStudentEvents[i].id ?? 0);
      tasks = [];
      for (int i = 0; i < taskIds.length; i++) {
        tasks.add(await serviceLocator<TaskDao>().findTaskById(taskIds[i]).first
            as Task);
      }
      tasksFinishedTimeslotMap[finishedStudentEvents[i].id ?? 0] = tasks;
    }
    return tasksFinishedTimeslotMap;
  }

  void showFinishedStudentTimeslot(context, studentTimeslot, tasks) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
            backgroundColor: modalBackground,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: StudentTimeslotFinishedModal(
                timeslot: studentTimeslot, tasks: tasks)));
  }

  void checkEventDone()  {
    for(int i= 0; i<finishedStudentEvents.length; i++){
        showFinishedStudentTimeslot(context, finishedStudentEvents[i], tasksFinishedEventMap[finishedStudentEvents[i].id ?? 0] ?? []);
    }
  }

  showWidget() {
    switch (_selectedIndex) {
      case 0:
        return MyEventListView(
            studentEvents: studentEvents, mediaEvents: mediaEvents);
      case 1:
        return MyEventListView(studentEvents: studentEvents);
      case 2:
        return MyEventListView(mediaEvents: mediaEvents);
      default:
        return const MyEventListView(studentEvents: [], mediaEvents: []);
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
