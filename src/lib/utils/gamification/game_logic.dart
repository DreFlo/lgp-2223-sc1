import 'package:flutter/material.dart';
import 'package:src/pages/gamification/gained_xp_toast.dart';
import 'package:src/pages/gamification/level_up_toast.dart';
import 'package:src/utils/enums.dart';

import 'package:src/models/user.dart';
import 'package:src/utils/gamification/levels.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/gamification/user_stats.dart';

//timeslot has a lot of tasks -> combos
class Timeslot {
  late int id;
  late List<int> taskId;
}

//class Game {
int getTaskComboPoints(List<Task> tasks) {
  double points = 0;

  // Base points.
  points += basePoints * tasks.length;

  // Task points.
  points += taskComboMultiplier * taskComboPoints * tasks.length;

  return points.floor();
}

int getImmediatePoints() {
  return (basePoints * nonEventTaskMultiplier).floor();
}

int getModuleComboPoints(List<Task> tasks) {
  double points = 0;

  points += moduleComboPoints * moduleComboMultiplier * tasks.length;

  return points.floor();
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

GameState check(List<Task> tasks, User user, bool differentModules) {
  for (Task t in tasks) {
    markTaskAsDoneOrNot(t, true, 0);
  }

  int points = 0;
  var lastTimeslot = DateTime.now();
  //TODO: get last "done" timeslot from DB with a query -> last one with finished set to true

  var taskCount = tasks.length;
  if (taskCount == 0) {
    // Illegal function call.
    throw Error();
  }

  if (lastTimeslot.difference(DateTime.now()).inDays == 0) {
    // We may have a module combo.

    //Check if second/third... timeslot of the day is for a different module than the timeslot that came first -> if true, get ModuleComboPoints
    //bool differentModules = true;

    if (differentModules) {
      points = getTaskComboPoints(tasks) + getModuleComboPoints(tasks);
    } else {
      points = getTaskComboPoints(tasks);
    }
  } else {
    //First timeslot of the day
    points = getTaskComboPoints(tasks);
  }

  //TODO: update user XP.
  //(points) => {};

  if (checkLevelUp(user.xp, user.level)) {
    return GameState.levelUp;
  } else {
    return GameState.progress;
  }
}

Future<GameState> checkNonEventNonTask(Task task, context) async {
  int points = getImmediatePoints();

  markTaskAsDoneOrNot(task, true, points);

  
  User user = await getUser();

  if (checkLevelUp(user.xp + points, user.level)) {
    User newUser = User(
        id: user.id,
        userName: user.userName,
        password: user.password,
        xp: user.xp + points,
        level: user.level + 1,
        imagePath: user.imagePath);

    await updateUser(newUser);

    var snackBar = SnackBar(
      content: LevelUpToast(oldLevel: user.level, newLevel: user.level + 1),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    // Step 3
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return GameState.levelUp;
    //show level up screen
  } else {
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
    //return null;
    //show progress screen
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

  //should we show a screen for losing a level/xp?
}

//}

//Note for Friday meeting or whenever we can talk to André: show the formula + ask what do we need to store in xpMultiplier
