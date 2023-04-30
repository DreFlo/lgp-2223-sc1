// ignore: unused_import
import 'dart:math';
import 'package:src/utils/enums.dart';

import 'package:src/utils/gamification/levels.dart';

class Task {
  late int id;
  late Module module;
}

//timeslot has a lot of tasks -> combos
class Timeslot {
  late int id;
  late List<int> taskId;
}

class Points {
  int getPoints(List<Task> tasks) {
    int taskCount = tasks.length;

    if (taskCount <= 0) {
      // Illegal call to function.
      throw Error();
    }

    switch (taskCount) {
      case 1:
        return getImmediatePoints();
      default:
        return getTaskComboPoints(tasks);
    }
  }

  int getTaskComboPoints(List<Task> tasks) {
    double points = 0;

    // Base points.
    points += basePoints * tasks.length;

    // Task points.
    points += taskComboMultiplier * taskComboPoints * tasks.length;

    return points.floor();
  }

  int getImmediatePoints() {
    return basePoints;
  }

  int getModuleComboPoints(List<Task> tasks) {
    double points = 0;

    points += moduleComboPoints * moduleComboMultiplier * tasks.length;

    return points.floor();
  }

  bool checkLevelUp(int userPoints, int currentLevel) {
    if (userPoints >= levels[currentLevel]!) {
      return true;
    }

    return false;
  }

  void markTaskAsDone(Task task) {
    //TODO: update task status in the DB.
  }
}

//Note for Friday meeting or whenever we can talk to André: show the formula + ask what do we need to store in xpMultiplier
