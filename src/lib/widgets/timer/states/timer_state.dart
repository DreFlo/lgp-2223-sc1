import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:src/pages/timer/timer_form.dart';
import 'package:src/pages/timer/timer_page.dart';
import 'package:src/utils/gamification/game_logic.dart';

abstract class TimerState {
  Timer? timer;
  final TimerSettings settings;
  final TimerTracker tracker;
  final BuildContext context;
  final void Function(void Function()) setState;
  final void Function(TimerState) changeState;

  TimerState(
      {required this.timer,
      required this.settings,
      required this.tracker,
      required this.context,
      required this.setState,
      required this.changeState}) {
    init();
  }

  Widget getTimerWidget();

  Widget getButtonWidget();

  String mode(); // focus or break

  bool isRunning(); // paused or running

  void init() {}

  void start() {}

  void pause() {}

  void onTimeUp() {}

  void leave() {
    // TODO(gamification): user left pomodoro - give feedback
    timer?.cancel();
    Navigator.pop(context);
  }

  void finish(BuildContext context) {   
    getPomodoroXP(settings.focusTime, settings.sessions,
        settings.shortBreak, context);
    timer?.cancel();
    Navigator.pop(context);
  }
}
