import 'package:flutter/material.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/timeslot/media_timeslot_dao.dart';
import 'package:src/daos/timeslot/student_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/pages/gamification/gained_xp_toast.dart';
import 'package:src/pages/gamification/level_up_toast.dart';
import 'package:src/utils/enums.dart';

import 'package:src/models/user.dart';
import 'package:src/utils/gamification/levels.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/gamification/user_stats.dart';

int getTaskComboPoints() {
  double points = 0;

  // Base points.
  points += basePoints;

  // Task points.
  points += taskComboMultiplier * taskComboPoints;

  return points.floor();
}

int getImmediatePoints() {
  return (basePoints * nonEventTaskMultiplier).floor();
}

int getTaskGroupBonusPoints() {
  double points = taskGroupPoints * taskGroupMultiplier;

  return points.floor();
}

int getModuleComboPoints() {
  double points = moduleComboPoints * moduleComboMultiplier;

  return points.floor();
}

Future<List<EventType>> getLastTimeslotTypes() async {
  List<EventType> lastTimeslotType = [];

  // Get most recently finished timeslots
  List<Timeslot> timeslots =
      await serviceLocator<TimeslotDao>().findAllFinishedTimeslots(true);
  timeslots.sort((a, b) => b.endDateTime.isBefore(a.endDateTime) ? -1 : 1);

  // Check if there's any timeslots that finished today
  List<int> timeslotsTodayIds = [];
  for (int i = 0; i < timeslots.length; i++) {
    if (timeslots[i].endDateTime.difference(DateTime.now()).inDays == 0) {
      timeslotsTodayIds.add(timeslots[i].id!);
    } else {
      break;
    }
  }

  // Get all the types of timeslots that finished today
  for (int i = 0; i < timeslotsTodayIds.length; i++) {
    Stream studentStream = serviceLocator<StudentTimeslotDao>()
        .findStudentTimeslotById(timeslotsTodayIds[i]);
    bool isStudentStreamEmpty = await studentStream.isEmpty;

    Stream mediaStream = serviceLocator<MediaTimeslotDao>()
        .findMediaTimeslotById(timeslotsTodayIds[i]);
    bool isMediaStreamEmpty = await mediaStream.isEmpty;

    if (!isStudentStreamEmpty) {
      lastTimeslotType.add(EventType.student);
    } else if (!isMediaStreamEmpty) {
      lastTimeslotType.add(EventType.leisure);
    }
  }

  return lastTimeslotType;
}

int getLevel(int points, int currentLevel) {
  int level = currentLevel;

  while (points >= levels[level + 1]!) {
    if (level == 10) {
      break;
    }
    level++;
  }

  return level;
}

bool checkLevelUp(int userPoints, int currentLevel) {
  if (currentLevel + 1 > levels.length) {
    return false;
  }

  if (userPoints >= levels[currentLevel + 1]!) {
    return true;
  }

  return false;
}

void markTaskAsDoneOrNot(Task task, bool finished, int xp) async {
  Task newTask = Task(
      id: task.id,
      name: task.name,
      description: task.description,
      deadline: task.deadline,
      finished: finished,
      priority: task.priority,
      taskGroupId: task.taskGroupId,
      xp: xp);
  await serviceLocator<TaskDao>().updateTask(newTask);
}

void markMediaAsDoneOrNot(Media media, bool finished, int xp) async {
  Media newMedia = Media(
      id: media.id,
      name: media.name,
      description: media.description,
      linkImage: media.linkImage,
      status: Status.done,
      favorite: media.favorite,
      genres: media.genres,
      release: media.release,
      participants: media.participants,
      type: media.type,
      xp: xp);
  await serviceLocator<MediaDao>().updateMedia(newMedia);
}

void markTimeslotAsDoneOrNot(
    TimeslotMediaTimeslotSuperEntity? mediaTimeslot,
    TimeslotStudentTimeslotSuperEntity? studentTimeslot,
    bool finished,
    int points) async {
  Timeslot newTimeslot;
  if (mediaTimeslot != null) {
    newTimeslot = Timeslot(
        id: mediaTimeslot.id,
        title: mediaTimeslot.title,
        description: mediaTimeslot.description,
        startDateTime: mediaTimeslot.startDateTime,
        endDateTime: mediaTimeslot.endDateTime,
        finished: finished,
        xpMultiplier: points,
        userId: mediaTimeslot.userId);
  } else {
    newTimeslot = Timeslot(
        id: studentTimeslot!.id,
        title: studentTimeslot.title,
        description: studentTimeslot.description,
        startDateTime: studentTimeslot.startDateTime,
        endDateTime: studentTimeslot.endDateTime,
        finished: finished,
        xpMultiplier: points,
        userId: studentTimeslot.userId);
  }

  await serviceLocator<TimeslotDao>().updateTimeslot(newTimeslot);
}

void updateUserShowLevelUpToast(User user, int points, context) async {
  int level = getLevel(user.xp + points, user.level);

  User newUser = User(
      id: user.id,
      userName: user.userName,
      password: user.password,
      xp: user.xp + points,
      level: level,
      imagePath: user.imagePath);

  await updateUser(newUser);

  var snackBar = SnackBar(
    content: LevelUpToast(oldLevel: user.level, newLevel: level),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
  // Step 3
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void updateUserShowGainedXPToast(User user, int points, context) async {
  int value = levels[user.level + 1]!;
  User newUser = User(
      id: user.id,
      userName: user.userName,
      password: user.password,
      xp: user.xp + points,
      level: user.level,
      imagePath: user.imagePath);

  await updateUser(newUser);

  var snackBar = SnackBar(
    duration: const Duration(seconds: 30),
    content: GainedXPToast(
      value: value,
      level: user.level,
      points: points,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
  // Step 3
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<bool> checkTaskFromEvent(Task task) async {
  Timeslot? event;
  List<int> eventsId = await serviceLocator<TaskStudentTimeslotDao>()
      .findStudentTimeslotIdByTaskId(task.id!);
  if (eventsId.isNotEmpty) {
    for (int i = 0; i < eventsId.length; i++) {
      event = await serviceLocator<TimeslotDao>()
          .findTimeslotById(eventsId[i])
          .first;
      if (!event!.finished &&
          event.startDateTime.isBefore(DateTime.now()) &&
          event.endDateTime.isAfter(DateTime.now())) {
        return true;
      }
    }
  }
  return false;
}

Future<GameState> check(
    List<Task>? tasks,
    List<Media>? medias,
    TimeslotMediaTimeslotSuperEntity? mediaTimeslot,
    TimeslotStudentTimeslotSuperEntity? studentTimeslot,
    context) async {
  EventType eventType =
      studentTimeslot != null ? EventType.student : EventType.leisure;
  int points = 0;
  bool differentModules = false;
  User user = await getUser();
  List<EventType> lastTimeslotInfo = await getLastTimeslotTypes();

  if (lastTimeslotInfo.isNotEmpty) {
    //there was a timeslot today

    // We may have a module combo.

    //Check if second/third... timeslot of the day is for a different module than the timeslot that came first -> if true, get ModuleComboPoints

    lastTimeslotInfo.contains(EventType.student) &&
            eventType == EventType.student
        ? differentModules = false
        : differentModules = true;
    lastTimeslotInfo.contains(EventType.leisure) &&
            eventType == EventType.leisure
        ? differentModules = false
        : differentModules = true;

    if (differentModules) {
      points = getTaskComboPoints() + getModuleComboPoints();
    } else {
      points = getTaskComboPoints();
    }
  } else {
    //First timeslot of the day
    points = getTaskComboPoints();
  }

  //Check which type of timeslot it is
  if (mediaTimeslot != null) {
    //have to focus on media
    if (medias!.isEmpty) {
      //Illegal function call
      throw Error();
    }

    for (Media m in medias) {
      markMediaAsDoneOrNot(m, true, points);
    }

    points = points * medias.length;
  } else if (studentTimeslot != null) {
    //have to focus on tasks
    if (tasks!.isEmpty) {
      //Illegal function call
      throw Error();
    }
    for (Task t in tasks) {
      markTaskAsDoneOrNot(t, true, points);
    }
    points = points * tasks.length;
  }

  //Update timeslot
  if (mediaTimeslot != null) {
    markTimeslotAsDoneOrNot(mediaTimeslot, null, true, points);
  } else if (studentTimeslot != null) {
    markTimeslotAsDoneOrNot(null, studentTimeslot, true, points);
  }

  if (checkLevelUp(user.xp + points, user.level)) {
    updateUserShowLevelUpToast(user, points, context);

    return GameState.levelUp;
  } else {
    updateUserShowGainedXPToast(user, points, context);

    return GameState.progress;
  }
}

Future<GameState> checkNonEventNonTask(
    Task task, context, bool fromTaskGroup) async {
  int points = getImmediatePoints();

  // need to check if task is part of an event; if event is not finished and if event is taking place rn
  // if so, give extra points due to event
  bool fromEvent = await checkTaskFromEvent(task);

  if (fromEvent) {
    points = getTaskComboPoints();
  }
  if (fromTaskGroup) {
    //gets bonus points for being part of a taskgroup
    points += getTaskGroupBonusPoints();
  }

  markTaskAsDoneOrNot(task, true, points);

  User user = await getUser();

  // Check if user could level up more than one level at a time
  // Check remove points again

  if (checkLevelUp(user.xp + points, user.level)) {
    updateUserShowLevelUpToast(user, points, context);

    return GameState.levelUp;
    //show level up screen
  } else {
    updateUserShowGainedXPToast(user, points, context);
    return GameState.progress;
  }
}

void removePoints(int points, Task task) async {
  //mark task as not done
  markTaskAsDoneOrNot(task, false, 0);
  User user = await getUser();
  int level = user.level;

  //check if user is gonna lose a level
  if (user.xp - points < levels[user.level]!) {
    //user is gonna lose a level
    level = user.level -
        1; //could he lose more than one level at a time? With just tasks I don't think so
  }
  User newUser = User(
      id: user.id,
      userName: user.userName,
      password: user.password,
      xp: user.xp - points,
      level: level,
      imagePath: user.imagePath);

  await updateUser(newUser);
}

void getPomodoroXP(int focusTime, int sessions, int shortBreak, context) async {
  int points = 6 * sessions;
  if (focusTime / shortBreak < 0.2) {
    points += longerWorkPoints;
  } else if (focusTime / shortBreak > 0.2) {
    points += longerBreakPoints;
  } else {
    points += basePoints;
  }

  User user = await getUser();

  if (checkLevelUp(user.xp + points, user.level)) {
    updateUserShowLevelUpToast(user, points, context);

    //show level up screen
  } else {
    updateUserShowGainedXPToast(user, points, context);
  }
}
