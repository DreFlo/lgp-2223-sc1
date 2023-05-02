import 'package:flutter/material.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/pages/gamification/no_progress_in_timeslot_modal.dart';
import 'package:src/pages/gamification/progress_in_timeslot_modal.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/tasks/timeslot_task_bar.dart';

import 'package:src/models/student/task.dart';

//This will be the modal that will appear when the user finishes a student timeslot
class StudentTimeslotFinishedModal extends StatefulWidget {
  final TimeslotStudentTimeslotSuperEntity timeslot;
  final List<Task> tasks;

  const StudentTimeslotFinishedModal(
      {Key? key, required this.timeslot, required this.tasks})
      : super(key: key);

  @override
  State<StudentTimeslotFinishedModal> createState() =>
      _StudentTimeslotFinishedModalState();
}

class _StudentTimeslotFinishedModalState
    extends State<StudentTimeslotFinishedModal> {
  late List<TimeslotTaskBar> tasksState;

  List<Widget> getTasks() {
    tasksState = [];

    List<Widget> tasks = [];

    for (int i = 0; i < widget.tasks.length; i++) {
      var task = TimeslotTaskBar(task: widget.tasks[i]);

      tasks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [task],
        ),
      );

      tasksState.add(task);

      if (i != widget.tasks.length - 1) tasks.add(const SizedBox(height: 10));
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppLocalizations.of(context).event_finished_1,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              widget.timeslot.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: leisureColor,
                fontSize: 35,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
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
                behavior: const ScrollBehavior(),
                child: ListView(shrinkWrap: true, children: getTasks()))),
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
              List<Task> tasksDone = [];
              int taskAlreadyDone = 0;
              for (TimeslotTaskBar t in tasksState) {
                if (t.taskStatus) {
                  tasksDone.add(t.task);
                } else {
                  if (t.task.finished) {
                    taskAlreadyDone++;
                  }
                }
              }

              if (tasksDone.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          backgroundColor: modalBackground,
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: NoProgressInTimeslotModal(
                            tasksDone: tasksDone,
                            studentTimeslot: widget.timeslot,
                          )));
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          backgroundColor: modalBackground,
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ProgressInTimeslotModal(
                            modules: const [
                              Module.student,
                              Module.fitness,
                              Module.personal,
                              Module.leisure
                            ],
                            taskCount: widget.tasks.length,
                            finishedTaskCount:
                                tasksDone.length + taskAlreadyDone,
                            tasksDone: tasksDone,
                            studentTimeslot: widget.timeslot,
                          )));
                });
              }
            },
            child: Text(AppLocalizations.of(context).confirm,
                style: Theme.of(context).textTheme.headlineSmall),
          )),
        ]),
      ]),
    );
  }
}
