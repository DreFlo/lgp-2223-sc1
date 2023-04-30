import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/timer/countdown_timer.dart';
import 'package:src/widgets/timer/outlined_button.dart';
import 'package:src/widgets/timer/sessions_progress.dart';

class TimerPage extends StatefulWidget {
  final int focusTime;
  final int shortBreak;
  final int longBreak;
  final int sessions;

  const TimerPage(
      {Key? key,
      required this.focusTime,
      required this.shortBreak,
      required this.longBreak,
      required this.sessions})
      : super(key: key);

  @override
  State<TimerPage> createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  int _seconds = 0;
  Timer? _timer;
  bool focus = true;
  bool isRunning = true;
  int currentSession = 1;

  int get initialSeconds =>
      focus ? widget.focusTime * 60 : widget.shortBreak * 60;

  @override
  void initState() {
    _seconds = widget.focusTime * 60;
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer?.cancel();
          if (focus) {
            _seconds = widget.shortBreak * 60;
            focus = false;
            startTimer();
          } else {
            if (currentSession < widget.sessions) {
              currentSession++;
              _seconds = widget.focusTime * 60;
              focus = true;
              startTimer();
            } else {
              // TODO: user completed pomodoro - give feedback
              Navigator.pop(context);
            }
          }
        }
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  leave() {
    // TODO: user left pomodoro - give feedback
    Navigator.pop(context);
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
                  focus
                      ? AppLocalizations.of(context).focus
                      : AppLocalizations.of(context).break_,
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
            CountdownTimerWidget(seconds: _seconds, focus: focus),
            Column(
              children: [
                SessionsProgress(
                    sessions: widget.sessions, currentSession: currentSession),
                const SizedBox(height: 40),
                isRunning
                    ? MyOutlinedButton(
                        onPressed: pauseTimer,
                        title: AppLocalizations.of(context).pause,
                      )
                    : MyOutlinedButton(
                        onPressed: startTimer,
                        title: AppLocalizations.of(context).resume,
                      ),
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
