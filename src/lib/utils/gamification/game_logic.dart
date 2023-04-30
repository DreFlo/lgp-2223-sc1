import 'package:flutter/material.dart';
import 'package:src/pages/gamification/gained_xp_toast.dart';
import 'package:src/utils/enums.dart';

import 'package:src/models/user.dart';
import 'package:src/utils/gamification/levels.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/gamification/user_stats.dart';


import 'package:src/utils/gamification/show_snack_bar.dart';

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

void markTaskAsDone(Task task) async {
  Task newTask = Task(
      id: task.id,
      name: task.name,
      description: task.description,
      deadline: task.deadline,
      finished: true,
      priority: task.priority,
      xp: task.xp);
  await serviceLocator<TaskDao>().updateTask(newTask);
}

GameState check(List<Task> tasks, User user, bool differentModules) {
  for (Task t in tasks) {
    markTaskAsDone(t);
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

void checkNonEventNonTask(Task task, context) async {
  markTaskAsDone(task);

  int points = getImmediatePoints();

  User user = await getUser();

  User newUser = User(
      id: user.id,
      userName: user.userName,
      password: user.password,
      xp: user.xp + points,
      level: user.level,
      imagePath: user.imagePath);

  await updateUser(newUser);

  if (checkLevelUp(user.xp + points, user.level)) {
    
    //return GameState.levelUp;
    //show level up screen
  } else {
    int value = levels[user.level + 1]!;
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
    //return GameState.progress;
  }
}

//}



//Note for Friday meeting or whenever we can talk to André: show the formula + ask what do we need to store in xpMultiplier
