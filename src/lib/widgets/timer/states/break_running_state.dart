import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/services/local_notifications_service.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/timer/countdown_timer.dart';
import 'package:src/widgets/timer/outlined_button.dart';
import 'package:src/widgets/timer/states/break_paused_state.dart';
import 'package:src/widgets/timer/states/focus_paused_state.dart';
import 'package:src/widgets/timer/states/timer_state.dart';

class BreakRunningState extends TimerState {
  BreakRunningState(
      {required super.timer,
      required super.tracker,
      required super.settings,
      required super.context,
      required super.setState,
      required super.changeState});

  @override
  String mode() {
    return AppLocalizations.of(context).break_;
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
    changeState(BreakPausedState(
        timer: timer,
        settings: settings,
        tracker: tracker,
        context: context,
        setState: setState,
        changeState: changeState));
  }

  @override
  void onTimeUp() {
    setState(() {
      timer?.cancel();
    });
    tracker.incrementSession();
    serviceLocator<LocalNotificationService>()
        .display(AppLocalizations.of(context).time_to_focus, AppLocalizations.of(context).emil_believes);
    changeState(FocusPausedState(
        timer: timer,
        settings: settings,
        tracker: tracker,
        context: context,
        setState: setState,
        changeState: changeState,
        reset: true));
  }

  @override
  Widget getTimerWidget() {
    return CountdownTimer(seconds: tracker.seconds, focus: false);
  }

  @override
  Widget getButtonWidget() {
    return MyOutlinedButton(
      onPressed: pause,
      title: AppLocalizations.of(context).pause,
    );
  }
}
