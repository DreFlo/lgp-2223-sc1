import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/widgets/timer/countdown_timer.dart';
import 'package:src/widgets/timer/outlined_button.dart';
import 'package:src/widgets/timer/states/break_paused_state.dart';
import 'package:src/widgets/timer/states/focus_paused_state.dart';
import 'package:src/widgets/timer/states/timer_state.dart';

class FocusRunningState extends TimerState {
  FocusRunningState(
      {required super.timer,
      required super.settings,
      required super.tracker,
      required super.context,
      required super.setState,
      required super.changeState});

  @override
  String mode() {
    return AppLocalizations.of(context).focus;
  }

  @override
  bool isRunning() {
    return true;
  }

  @override
  init() {
    setState(
      () {
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          tracker.seconds > 0 ? updateTimer() : onTimeUp();
        });
      },
    );
  }

  void updateTimer() {
    setState(() {
      tracker.decrementSeconds();
    });
  }

  @override
  void pause() {
    changeState(FocusPausedState(
        timer: timer,
        settings: settings,
        tracker: tracker,
        context: context,
        setState: setState,
        changeState: changeState));
  }

  @override
  void onTimeUp() {
    if (tracker.currentSession < settings.sessions) {
      // TODO(notifications): sent notification to user (It is BREAK time!)
      if (tracker.currentSession != 1) {
        getPomodoroXP(settings.focusTime, tracker.currentSession,
            settings.sessions, settings.shortBreak, context, false);
      }
      changeState(BreakPausedState(
          timer: timer,
          settings: settings,
          tracker: tracker,
          context: context,
          setState: setState,
          changeState: changeState,
          reset: true));
    } else {
      finish(context);
    }
  }

  @override
  Widget getTimerWidget() {
    return CountdownTimer(seconds: tracker.seconds, focus: true);
  }

  @override
  Widget getButtonWidget() {
    return MyOutlinedButton(
      onPressed: pause,
      title: AppLocalizations.of(context).pause,
    );
  }
}
