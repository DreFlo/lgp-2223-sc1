import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/timer/timer_page.dart';
import 'package:src/widgets/modal.dart';
import 'package:src/widgets/timer/start_button.dart';
import 'package:src/widgets/timer/timer_form_field.dart';

class TimerSettings {
  final int focusTime;
  final int shortBreak;
  final int sessions;

  TimerSettings(
      {required this.focusTime,
      required this.shortBreak,
      required this.sessions});
}

class TimerForm extends StatefulWidget {
  final ScrollController scrollController;

  const TimerForm({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<TimerForm> createState() => _TimerFormState();
}

class _TimerFormState extends State<TimerForm> {
  int focusTime = 30;
  int shortBreak = 10;
  int sessions = 4;

  @override
  initState() {
    super.initState();
  }

  void setFocusTime(int value) {
    setState(() {
      focusTime = value;
    });
  }

  void setShortBreak(int value) {
    setState(() {
      shortBreak = value;
    });
  }

  void setSessions(int value) {
    setState(() {
      sessions = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Modal(
        title: AppLocalizations.of(context).timer,
        icon: Icons.access_time_rounded,
        scrollController: widget.scrollController,
        children: [
          const SizedBox(height: 30),
          TimerFormField(
              scrollController: widget.scrollController,
              title: AppLocalizations.of(context).focus_time,
              icon: Icons.timer,
              currentValue: focusTime,
              minValue: 10,
              maxValue: 60,
              step: 5,
              unit: AppLocalizations.of(context).minutes_unit,
              onValueChanged: setFocusTime),
          const SizedBox(height: 25),
          TimerFormField(
              scrollController: widget.scrollController,
              title: AppLocalizations.of(context).short_break,
              icon: Icons.timelapse_rounded,
              currentValue: shortBreak,
              minValue: 5,
              maxValue: 30,
              step: 5,
              unit: AppLocalizations.of(context).minutes_unit,
              onValueChanged: setShortBreak),
          const SizedBox(height: 25),
          TimerFormField(
              scrollController: widget.scrollController,
              title: AppLocalizations.of(context).sessions,
              icon: Icons.restart_alt_rounded,
              currentValue: sessions,
              minValue: 1,
              maxValue: 10,
              step: 1,
              unit: AppLocalizations.of(context).sessions_unit,
              onValueChanged: setSessions),
          const SizedBox(height: 35),
          StartButton(onStartCallback: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimerPage(
                            settings: TimerSettings(
                          focusTime: focusTime,
                          shortBreak: shortBreak,
                          sessions: sessions,
                        ))));
          })
        ]);
  }
}
