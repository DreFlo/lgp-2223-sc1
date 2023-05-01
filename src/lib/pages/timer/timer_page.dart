import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/timer/timer_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/timer/sessions_progress.dart';
import 'package:src/widgets/timer/states/focus_paused_state.dart';
import 'package:src/widgets/timer/states/timer_state.dart';

class TimerTracker {
  int currentSession;
  int seconds;

  TimerTracker({required this.currentSession, required this.seconds});

  void setSeconds(int value) {
    seconds = value;
  }

  void incrementSession() {
    currentSession++;
  }

  void decrementSeconds() {
    seconds--;
  }
}

class TimerPage extends StatefulWidget {
  final TimerSettings settings;

  const TimerPage({Key? key, required this.settings}) : super(key: key);

  @override
  State<TimerPage> createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  late TimerState state;
  late TimerTracker tracker;
  Timer? _timer;

  @override
  void initState() {
    tracker = TimerTracker(currentSession: 1, seconds: 0);
    state = FocusPausedState(
        timer: _timer,
        settings: widget.settings,
        tracker: tracker,
        context: context,
        setState: setState,
        changeState: changeState,
        reset: true);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void changeState(TimerState newState) {
    setState(() {
      state = newState;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  AppLocalizations.of(context).timer,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  state.mode(),
                  style: const TextStyle(
                    color: primaryColor,
                    fontFamily: 'Poppins',
                    fontSize: 35,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            state.getTimerWidget(),
            Column(
              children: [
                SessionsProgress(
                    sessions: widget.settings.sessions,
                    currentSession: tracker.currentSession),
                const SizedBox(height: 40),
                state.getButtonWidget(),
                const SizedBox(height: 5),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context).leave,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.white54)))
              ],
            )
          ])),
    );
  }
}
