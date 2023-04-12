import 'package:src/utils/enums.dart';

import '../../models/user.dart';
import 'levels.dart';

class Task {
  late int id;
  late Module module;
}

//timeslot has a lot of tasks -> combos
class Timeslot {
  late int id;
  late List<int> taskId;
}

class Game {
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
    if (userPoints >= levels[currentLevel]!) {
      return true;
    }

    return false;
  }

  void markTaskAsDone(Task task) {
    //TODO: update task status in the DB.
  }

  GameState check(List<Task> tasks, User user) {
    for (Task t in tasks) {
      markTaskAsDone(t);
    }

    int points = 0;
    var lastTimeslot = DateTime.now();
    //TODO: get last "done" timeslot from DB with a query.

    var taskCount = tasks.length;
    if (taskCount == 0) {
      // Illegal function call.
      throw Error();
    }

    if (lastTimeslot.difference(DateTime.now()).inDays == 0) {
      // We may have a module combo.

      //Check if second/third... timeslot of the day is for a different module than the timeslot that came first -> if true, get ModuleComboPoints
      bool differentModules = true;

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

    if (checkLevelUp(user.xp, user.level)) {
      return GameState.levelUp;
    } else {
      return GameState.progress;
    }
  }

  GameState checkNonEvent(Task task, User user) {
    markTaskAsDone(task);

    int points = getImmediatePoints();

    //TODO: update user XP.

    if (checkLevelUp(user.xp, user.level)) {
      return GameState.levelUp;
    } else {
      return GameState.progress;
    }
  }
}

//Note for Friday meeting or whenever we can talk to André: show the formula + ask what do we need to store in xpMultiplier
