import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/widgets/tasks/timeslot_task_bar.dart';

import '../../models/student/task.dart';
import '../../models/timeslot/timeslot.dart';

class TimeslotFinishedModal extends StatefulWidget {
  final Timeslot timeslot;
  final List<Task> tasks;

  const TimeslotFinishedModal(
      {Key? key, required this.timeslot, required this.tasks})
      : super(key: key);

  @override
  State<TimeslotFinishedModal> createState() => _TimeslotFinishedModalState();
}

class _TimeslotFinishedModalState extends State<TimeslotFinishedModal> {
  List<Widget> getTasks() {
    List<Widget> tasks = [];

    for (int i = 0; i < widget.tasks.length; i++) {
      tasks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeslotTaskBar(
                title: widget.tasks[i].name,
                dueDate: widget.tasks[i].deadline.toString(),
                taskStatus: false)
          ],
        ),
      );

      if (i != widget.tasks.length - 1) tasks.add(const SizedBox(height: 10));
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppLocalizations.of(context).event_finished_1,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget.timeslot.title,
              style: const TextStyle(
                  color: leisureColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppLocalizations.of(context).event_finished_2,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            AppLocalizations.of(context).event_finished_3,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          )
        ]),
        const SizedBox(height: 30),
        SizedBox(
            height: 300,
            child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: ListView(children: getTasks(), shrinkWrap: true))),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50))),
            onPressed: () {
              //TODO: Use Game class :)
              //TODO: show emil modal <3
            },
            child: Text(AppLocalizations.of(context).confirm,
                style: Theme.of(context).textTheme.headlineSmall),
          )),
        ]),
      ]),
    );
  }
}
