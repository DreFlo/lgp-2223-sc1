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
    if (tracker.currentSession == 1) {
      timer?.cancel();
      Navigator.pop(context);
    } else {
      getPomodoroXP(settings.focusTime, tracker.currentSession,
          settings.sessions, settings.shortBreak, context, true);
      timer?.cancel();
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    }
  }

  void finish(BuildContext context) {
    getPomodoroXP(settings.focusTime, tracker.currentSession, settings.sessions,
        settings.shortBreak, context, true);
    timer?.cancel();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });
  }
}
