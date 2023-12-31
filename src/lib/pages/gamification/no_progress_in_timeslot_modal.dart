import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/utils/gamification/game_logic.dart';

class NoProgressInTimeslotModal extends StatefulWidget {
  final List<Media>? mediasDone;
  final List<Task>? tasksDone;
  final TimeslotMediaTimeslotSuperEntity? mediaTimeslot;
  final TimeslotStudentTimeslotSuperEntity? studentTimeslot;

  const NoProgressInTimeslotModal(
      {Key? key,
      this.mediasDone,
      this.tasksDone,
      this.mediaTimeslot,
      this.studentTimeslot})
      : super(key: key);

  @override
  State<NoProgressInTimeslotModal> createState() =>
      _NoProgressInTimeslotModalState();
}

class _NoProgressInTimeslotModalState extends State<NoProgressInTimeslotModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Text(AppLocalizations.of(context).event_no_progress_1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Text(AppLocalizations.of(context).event_no_progress_2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium))
        ]),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Image(
              height: 250,
              width: 250,
              image: AssetImage('assets/images/emil.png'))
        ]),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Text(AppLocalizations.of(context).event_no_progress_3,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)))
        ]),
        const SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50))),
            onPressed: () async {
              check(widget.tasksDone, widget.mediasDone, widget.mediaTimeslot,
                  widget.studentTimeslot, context);
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: Text(AppLocalizations.of(context).thank_you_emil,
                style: Theme.of(context).textTheme.headlineSmall),
          )),
        ]),
      ]),
    );
  }
}
