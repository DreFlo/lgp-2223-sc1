import 'package:flutter/material.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/gamification/game_logic.dart';

class ProgressInTimeslotModal extends StatefulWidget {
  final int taskCount;
  final int finishedTaskCount;
  final List<Media>? mediasDone;
  final List<Task>? tasksDone;
  final TimeslotMediaTimeslotSuperEntity? mediaTimeslot;
  final TimeslotStudentTimeslotSuperEntity? studentTimeslot;
  final List<Module> modules;

  const ProgressInTimeslotModal(
      {Key? key,
      required this.taskCount,
      required this.finishedTaskCount,
      required this.modules,
      this.mediasDone,
      this.tasksDone,
      this.mediaTimeslot,
      this.studentTimeslot})
      : super(key: key);

  @override
  State<ProgressInTimeslotModal> createState() =>
      _ProgressInTimeslotModalState();
}

class _ProgressInTimeslotModalState extends State<ProgressInTimeslotModal> {
  late LinearGradient gradient;

  @override
  initState() {
    List<Color> colors = [];

    for (Module m in widget.modules) {
      switch (m) {
        case Module.student:
          colors.add(studentColor);
          break;
        case Module.leisure:
          colors.add(leisureColor);
          break;
        case Module.fitness:
          colors.add(fitnessColor);
          break;
        case Module.personal:
          colors.add(personalColor);
          break;
      }
    }

    gradient = LinearGradient(colors: colors, stops: getStops(colors.length));

    super.initState();
  }

  getStops(int colors) {
    double step = 1 / colors;
    List<double> stops = [];

    for (int i = 0; i < colors; i++) {
      stops.add(i * step);
    }

    return stops;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppLocalizations.of(context).event_progress_1,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => gradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              child: Text(
                  "${widget.finishedTaskCount} ${AppLocalizations.of(context).event_progress_2}",
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic)))
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
              "${AppLocalizations.of(context).event_progress_3} ${widget.taskCount} ${AppLocalizations.of(context).event_progress_4}",
              softWrap: false,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))
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
          Text(AppLocalizations.of(context).event_progress_5,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center)
        ]),
        const SizedBox(height: 30),
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
            child: Text(AppLocalizations.of(context).lets_go,
                style: Theme.of(context).textTheme.headlineSmall),
          )),
        ]),
      ]),
    );
  }
}
