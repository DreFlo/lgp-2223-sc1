import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/formatters.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/events/bars/activity_bar_show.dart';
import 'package:src/widgets/highlight_text.dart';
import 'package:src/widgets/modal.dart';
import 'package:src/pages/events/event_form.dart';

import 'dart:math' as math;

class EventShow extends StatefulWidget {
  final int id;
  final ScrollController scrollController;
  final EventType type;
  final Function() callback;

  const EventShow(
      {Key? key,
      required this.scrollController,
      required this.id,
      required this.type,
      required this.callback})
      : super(key: key);

  @override
  State<EventShow> createState() => _EventShowState();
}

class _EventShowState extends State<EventShow> {
  bool initialized = false;
  Color _moduleColor = studentColor;

  late String title;
  late String description;
  late List<Activity> activities = [];
  late DateTime startDate;
  late DateTime endDate;

  @override
  initState() {
    super.initState();
  }

  Future<int> onInitEvent() async {
    if (initialized) {
      return 0;
    }

    Timeslot? timeslot =
        await serviceLocator<TimeslotDao>().findTimeslotById(widget.id).first;

    if (timeslot == null) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      return 0;
    }

    title = timeslot.title;
    description = timeslot.description;
    startDate = timeslot.startDateTime;
    endDate = timeslot.endDateTime;

    if (widget.type == EventType.student) {
      _moduleColor = studentColor;
      initStudentEventActivities();
    } else if (widget.type == EventType.leisure) {
      _moduleColor = leisureColor;
      initMediaEventActivities();
    }

    initialized = true;
    return 1;
  }

  void initMediaEventActivities() async {
    List<Media> media = await serviceLocator<MediaMediaTimeslotDao>()
        .findMediaByMediaTimeslotId(widget.id);

    setState(() {
      activities = media
          .map((e) =>
              Activity(id: e.id!, title: e.name, description: e.description))
          .toList();
    });
  }

  void initStudentEventActivities() async {
    List<Task> tasks = await serviceLocator<TaskStudentTimeslotDao>()
        .findTaskByStudentTimeslotId(widget.id);

    setState(() {
      activities = tasks
          .map((e) => Activity(
              id: e.id!,
              title: e.name,
              description: '(${formatDeadline(e.deadline)}) ${e.description}'))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: onInitEvent(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Modal(
              title: AppLocalizations.of(context).event,
              icon: Icons.event,
              scrollController: widget.scrollController,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const SizedBox(width: 7.5),
                  showModule(),
                  const SizedBox(width: 15),
                  Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Flexible(
                            flex: 10,
                            child: Text(title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)))
                      ])),
                ]),
                const SizedBox(height: 30),
                showDate(true, startDate),
                const SizedBox(height: 30),
                showDate(false, endDate),
                const SizedBox(height: 30),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).description,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF71788D),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ]),
                const SizedBox(height: 7.5),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Flexible(
                      flex: 10,
                      child: Text(description,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)))
                ]),
                const SizedBox(height: 30),
                Row(children: [
                  Text(
                    AppLocalizations.of(context).activities,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF71788D),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ]),
                const SizedBox(height: 7.5),
                showActivities(),
                const SizedBox(height: 30),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ElevatedButton(
                        key: const Key('editEventButton'),
                        onPressed: () {
                          edit();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.86, 55),
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context).edit,
                            style: Theme.of(context).textTheme.headlineSmall))
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget showModule() {
    return SizedBox(
        height: 25,
        width: 25,
        child: Flexible(
            flex: 1,
            child: AspectRatio(
                aspectRatio: 1,
                child: Transform.rotate(
                    angle: -math.pi / 4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0),
                        alignment: const Alignment(0, 0),
                        backgroundColor:
                            MaterialStateProperty.all(_moduleColor),
                      ),
                      onPressed: () {},
                      child: null,
                    )))));
  }

  Widget showDate(bool start, DateTime date) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Flexible(
          flex: 1,
          child: Column(children: [
            Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF414554),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_sharp,
                  color: Color(0xFF71788D),
                  size: 20,
                ))
          ])),
      const SizedBox(width: 15),
      Flexible(
          flex: 5,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(children: [
              Text(
                  start
                      ? AppLocalizations.of(context).start
                      : AppLocalizations.of(context).end,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  highlightColor: lightGray,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HighlightText(
                          start
                              ? dateFormat.format(startDate)
                              : dateFormat.format(endDate),
                          key: const Key('projectDeadline'))
                    ],
                  ),
                )
              ],
            )
          ]))
    ]);
  }

  Widget showActivities() {
    if (activities.isEmpty) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(AppLocalizations.of(context).no_activities,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal)));
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: activities
              .map((e) => ActivityBarShow(
                    title: e.title,
                    description: e.description,
                  ))
              .toList());
    }
  }

  void edit() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF22252D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        builder: (context) => Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 50),
            child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.75,
                minChildSize: 0.75,
                maxChildSize: 0.75,
                builder: (context, scrollController) => EventForm(
                      scrollController: scrollController,
                      id: widget.id,
                      type: widget.type,
                      callback: onEdit,
                    ))));
  }

  void onEdit() {
    setState(() {
      initialized = false;
      widget.callback();
    });
  }
}
