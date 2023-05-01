import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/widgets/timer/countdown_timer.dart';
import 'package:src/widgets/timer/outlined_button.dart';
import 'package:src/widgets/timer/states/break_running_state.dart';
import 'package:src/widgets/timer/states/timer_state.dart';

class BreakPausedState extends TimerState {
  final bool reset;

  BreakPausedState(
      {required super.timer,
      required super.settings,
      required super.tracker,
      required super.context,
      required super.setState,
      required super.changeState,
      this.reset = false});

  @override
  String mode() {
    return AppLocalizations.of(context).break_;
  }

  @override
  bool isRunning() {
    return false;
  }

  @override
  init() {
    setState(() {
      timer?.cancel();
      if (reset) {
        tracker.setSeconds(settings.shortBreak * 60);
      }
    });
  }

  @override
  void start() {
    changeState(BreakRunningState(
        timer: timer,
        settings: settings,
        tracker: tracker,
        context: context,
        setState: setState,
        changeState: changeState));
  }

  @override
  Widget getTimerWidget() {
    return CountdownTimer(seconds: tracker.seconds, focus: false);
  }

  @override
  Widget getButtonWidget() {
    return MyOutlinedButton(
      onPressed: start,
      title: AppLocalizations.of(context).start_,
    );
  }
}
