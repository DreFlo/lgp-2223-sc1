import 'package:flutter/material.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/pages/gamification/media_timeslot_finished_modal.dart';
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
  List<TimeslotMediaTimeslotSuperEntity> finishedMediaEvents = [];
  Map<int, List<Task>> tasksFinishedEventMap = {};
  Map<int, List<Media>> mediasFinishedEventMap = {};
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
    finishedMediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllFinishedTimeslotMediaTimeslot(now);
    tasksFinishedEventMap = await getTasks();
    mediasFinishedEventMap = await getMedias();
    setState(() {
      mediaEvents = mediaEvents;
      studentEvents = studentEvents;
      finishedStudentEvents = finishedStudentEvents;
      tasksFinishedEventMap = tasksFinishedEventMap;
      mediasFinishedEventMap = mediasFinishedEventMap;
      loadedAllData = true;
      checkEventDone();
    });
  }

  Future<Map<int, List<Media>>> getMedias() async {
    Map<int, List<Media>> mediasFinishedTimeslotMap = {};
    List<int> mediaIds = [];
    List<Media> medias = [];
    for (int i = 0; i < finishedMediaEvents.length; i++) {
      mediaIds = [];
      mediaIds = await serviceLocator<MediaMediaTimeslotDao>()
          .findMediaIdByMediaTimeslotId(finishedMediaEvents[i].id ?? 0);
      medias = [];
      for (int i = 0; i < mediaIds.length; i++) {
        medias.add(await serviceLocator<MediaDao>()
            .findMediaById(mediaIds[i])
            .first as Media);
      }
      mediasFinishedTimeslotMap[finishedMediaEvents[i].id ?? 0] = medias;
    }
    return mediasFinishedTimeslotMap;
  }

  Future<Map<int, List<Task>>> getTasks() async {
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

  void showFinishedTimeslot(context, TimeslotStudentTimeslotSuperEntity? studentTimeslot,
      List<Task> tasks, TimeslotMediaTimeslotSuperEntity? mediaTimeslot, List<Media> medias ) {
    Widget timeslot = Container();
    if (studentTimeslot != null){
      timeslot = StudentTimeslotFinishedModal(
          timeslot: studentTimeslot, tasks: tasks);
    } else if(mediaTimeslot != null){
      timeslot = MediaTimeslotFinishedModal(
          timeslot: mediaTimeslot, medias: medias);
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
            backgroundColor: modalBackground,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: timeslot));
  }

  void checkEventDone() {
    for (int i = 0; i < finishedStudentEvents.length; i++) {
      showFinishedTimeslot(context, finishedStudentEvents[i],
          tasksFinishedEventMap[finishedStudentEvents[i].id ?? 0] ?? [], null, []);
    }
    for (int i = 0; i < finishedMediaEvents.length; i++) {
      showFinishedTimeslot(context, null, [], finishedMediaEvents[i],
          mediasFinishedEventMap[finishedMediaEvents[i].id ?? 0] ?? []);
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
