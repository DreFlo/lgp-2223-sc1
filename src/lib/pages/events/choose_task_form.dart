// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/events/choose_task_bar.dart';

class ChooseTask {
  final int id;
  final String name;
  final DateTime deadline;
  bool isSelected;

  ChooseTask(
      {required this.id,
      required this.name,
      required this.deadline,
      required this.isSelected});
}

class ChooseTaskForm extends StatefulWidget {
  final List<ChooseTask> tasks;
  final ScrollController scrollController;
  final Function(int, String, String) addActivityCallback;

  const ChooseTaskForm(
      {Key? key,
      required this.scrollController,
      required this.tasks,
      required this.addActivityCallback})
      : super(key: key);

  @override
  State<ChooseTaskForm> createState() => _ChooseTaskFormState();
}

class _ChooseTaskFormState extends State<ChooseTaskForm> {
  TextEditingController controller = TextEditingController();

  late List<ChooseTask>? tasks;

  List<Widget> getTasks() {
    List<Widget> tasksList = [];

    for (int i = 0; i < tasks!.length; i++) {
      ChooseTask task = tasks![i];
      tasksList.add(ChooseTaskBar(task: task));
      if (i != tasks!.length - 1) {
        tasksList.add(const SizedBox(height: 15));
      }
    }

    if (tasks == null || tasks!.isEmpty) {
      tasksList.add(Text(AppLocalizations.of(context).no_tasks,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal)));
    }

    return tasksList;
  }

  formatDeadline(DateTime deadline) {
    Map<int, String> suffixes = {
      1: 'st',
      2: 'nd',
      3: 'rd',
    };

    String ordinalDay = (deadline.day >= 11 && deadline.day <= 13)
        ? 'th'
        : suffixes[deadline.day % 10] ?? 'th';

    return DateFormat("MMM d'$ordinalDay' - ha")
        .format(deadline)
        .replaceAll('AM', 'am')
        .replaceAll('PM', 'pm');
  }

  @override
  initState() {
    tasks = widget.tasks;
    tasks ??= [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Wrap(spacing: 10, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Container(
                    width: 115,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF414554),
                    ),
                  ))
            ]),
            Row(children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF17181C),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  child: Wrap(children: [
                    Row(children: [
                      const Icon(Icons.task, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context).choose_tasks,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ])
                  ]))
            ]),
            const SizedBox(height: 30),
            ...getTasks(),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  //TODO: Add selected tasks to event
                  for (ChooseTask task in tasks!) {
                    if (task.isSelected)
                      widget.addActivityCallback(
                          task.id, task.name, formatDeadline(task.deadline));
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.95, 55),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).save,
                    style: Theme.of(context).textTheme.headlineSmall))
          ]),
        ));
  }
}
