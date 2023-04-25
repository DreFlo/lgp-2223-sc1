import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/media_media_timeslot.dart';
import 'package:src/models/timeslot/task_student_timeslot.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/pages/events/choose_activity_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/formatters.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/events/activity_bar.dart';

class Activity {
  final int id;
  final String title;
  final String description;

  Activity({required this.id, required this.title, required this.description});
}

class EventForm extends StatefulWidget {
  final int? id;
  final ScrollController scrollController;

  const EventForm({Key? key, required this.scrollController, this.id})
      : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey buttonKey = GlobalKey();
  Color _moduleColor = studentColor;

  late String? title, description;
  late Priority? priority;
  late List<Activity> activities;
  DateTime? startDate, endDate;
  DateTime defaultStartDate = DateTime.now();
  DateTime defaultEndDate = DateTime.now().add(const Duration(hours: 1));

  Map<String, String> errors = {};

  validate() {
    errors = {};
    if (titleController.text == "") {
      errors['title'] = AppLocalizations.of(context).event_title_error;
    }
    if (startDate!.isAfter(endDate!)) {
      errors['date'] = AppLocalizations.of(context).event_date_error;
    }
    if (activities.isEmpty) {
      errors['activities'] =
          AppLocalizations.of(context).event_activities_error;
    }
  }

  void addActivityCallback(int id, String title, String description) {
    setState(() {
      activities.add(Activity(id: id, title: title, description: description));
    });
  }

  void removeActivityCallback(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  String setDefaultDate() {
    endDate = DateTime.now().add(const Duration(hours: 1));
    return formatEventTime(endDate!);
  }

  Future<List<ChooseActivity>> getMediaActivities() async {
    // TODO(eventos): findUnfinishedMedia()??
    List<ChooseActivity> mediaActivities = [];
    List<Media> media = await serviceLocator<MediaDao>().findAllMedia();

    for (Media m in media) {
      if (activities.every((element) => element.id != m.id)) {
        mediaActivities.add(ChooseActivity(
          id: m.id!,
          title: m.name,
          description: m.description,
          isSelected: false,
        ));
      }
    }

    return mediaActivities;
  }

  Future<List<ChooseActivity>> getTasksActivities() async {
    // TODO(eventos): findUnfinishedTasks()??

    List<ChooseActivity> tasksActivities = [];
    List<Task> tasks = await serviceLocator<TaskDao>().findAllTasks();

    for (Task t in tasks) {
      if (activities.every((element) => element.id != t.id)) {
        tasksActivities.add(ChooseActivity(
          id: t.id!,
          title: t.name,
          description: formatDeadline(t.deadline),
          isSelected: false,
        ));
      }
    }

    return tasksActivities;
  }

  FutureBuilder<List<ChooseActivity>> futureChooseActivityForm(
      BuildContext context,
      ScrollController scrollController,
      String title,
      String noActivityText,
      Future<List<ChooseActivity>> activities) {
    return FutureBuilder<List<ChooseActivity>>(
      future: activities,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChooseActivityForm(
              scrollController: scrollController,
              title: title,
              noActivityText: noActivityText,
              activities: snapshot.data!,
              addActivityCallback: addActivityCallback);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  FutureBuilder<List<ChooseActivity>> futureChooseMediaActivityForm(
      BuildContext context, ScrollController scrollController) {
    return futureChooseActivityForm(
        context,
        scrollController,
        AppLocalizations.of(context).choose_media,
        AppLocalizations.of(context).no_media,
        getMediaActivities());
  }

  FutureBuilder<List<ChooseActivity>> futureChooseTasksActivityForm(
      BuildContext context, ScrollController scrollController) {
    return futureChooseActivityForm(
        context,
        scrollController,
        AppLocalizations.of(context).choose_tasks,
        AppLocalizations.of(context).no_tasks,
        getTasksActivities());
  }

  List<Widget> getActivities() {
    List<Widget> activitiesList = [];

    for (int i = 0; i < activities.length; i++) {
      activitiesList.add(ActivityBar(
          id: activities[i].id,
          title: activities[i].title,
          description: activities[i].description,
          removeActivityCallback: () => removeActivityCallback(i)));
      if (i != activities.length - 1) {
        activitiesList.add(const SizedBox(height: 15));
      }
    }

    if (activities.isEmpty) {
      activitiesList.add(Text(AppLocalizations.of(context).no_activities,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal)));
      if (errors.containsKey('activities')) {
        activitiesList.add(Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 10.0),
            child: Text(errors['activities']!,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w400))));
      }
    }

    return activitiesList;
  }

  List<PopupMenuItem> getModuleColorsMenuItems() {
    List<PopupMenuItem> modulesMenuItems = [];

    modulesMenuItems.add(PopupMenuItem(
        value: studentColor,
        child: Text(
          AppLocalizations.of(context).student,
          style: Theme.of(context).textTheme.bodyMedium,
        )));

    modulesMenuItems.add(PopupMenuItem(
      value: leisureColor,
      child: Text(
        AppLocalizations.of(context).leisure,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ));

    return modulesMenuItems;
  }

  DateTime formatDateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, date.hour, date.minute);
  }

  void saveMediaEvent() async {
    // TODO(eventos): correct xp formula and get user logged id

    TimeslotMediaTimeslotSuperEntity mediaTimeslot =
        TimeslotMediaTimeslotSuperEntity(
      title: title!,
      description: description!,
      startDateTime: formatDateTime(startDate!),
      endDateTime: formatDateTime(endDate!),
      xpMultiplier: 2,
      userId: 1,
    );

    int id = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .insertTimeslotMediaTimeslotSuperEntity(mediaTimeslot);

    List<MediaMediaTimeslot> mediaMediaTimeslots = activities
        .map((activity) =>
            MediaMediaTimeslot(mediaId: activity.id, mediaTimeslotId: id))
        .toList();

    await serviceLocator<MediaMediaTimeslotDao>()
        .insertMediaMediaTimeslots(mediaMediaTimeslots);
  }

  void saveStudentEvent() async {
    // TODO(eventos): correct xp formula and get user logged id

    TimeslotStudentTimeslotSuperEntity studentTimeslot =
        TimeslotStudentTimeslotSuperEntity(
      title: title!,
      description: description!,
      startDateTime: formatDateTime(startDate!),
      endDateTime: formatDateTime(endDate!),
      xpMultiplier: 2,
      userId: 1,
    );

    int id = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
        .insertTimeslotStudentTimeslotSuperEntity(studentTimeslot);

    List<TaskStudentTimeslot> taskStudentTimeslots = activities
        .map((activity) =>
            TaskStudentTimeslot(taskId: activity.id, studentTimeslotId: id))
        .toList();

    await serviceLocator<TaskStudentTimeslotDao>()
        .insertTaskStudentTimeslots(taskStudentTimeslots);
  }

  @override
  initState() {
    if (widget.id != null) {
      // TODO: get event info from database
    } else {
      title = '';
      startDate = null;
      endDate = null;
      description = '';
      activities = [];
    }

    titleController.text = title!;

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
                      const Icon(Icons.event, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context).event,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ])
                  ]))
            ]),
            const SizedBox(height: 15),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(width: 7.5),
              Flexible(
                  flex: 1,
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Transform.rotate(
                          angle: -math.pi / 4,
                          child: ElevatedButton(
                            key: buttonKey,
                            style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(0),
                              alignment: const Alignment(0, 0),
                              backgroundColor:
                                  MaterialStateProperty.all(_moduleColor),
                            ),
                            onPressed: () {
                              final RenderBox button = buttonKey.currentContext!
                                  .findRenderObject() as RenderBox;
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject() as RenderBox;
                              final RelativeRect position =
                                  RelativeRect.fromRect(
                                Rect.fromPoints(
                                  button.localToGlobal(Offset.zero,
                                      ancestor: overlay),
                                  button.localToGlobal(
                                      button.size.bottomRight(Offset.zero),
                                      ancestor: overlay),
                                ),
                                Offset.zero & overlay.size,
                              );
                              showMenu(
                                context: context,
                                position: position,
                                color: const Color(0xFF17181C),
                                items: getModuleColorsMenuItems(),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    if (value != _moduleColor) {
                                      _moduleColor = value;
                                      activities = [];
                                    }
                                  });
                                }
                              });
                            },
                            child: const Text('Change color'),
                          )))),
              const SizedBox(width: 15),
              Flexible(
                  flex: 10,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                            controller: titleController,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF414554))),
                              hintText: AppLocalizations.of(context).title,
                              hintStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF71788D),
                                  fontWeight: FontWeight.w400),
                            )),
                        errors.containsKey('title')
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 5.0),
                                child: Text(errors['title']!,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)))
                            : const SizedBox(height: 0),
                      ])),
              const SizedBox(width: 5),
              Flexible(
                  flex: 1,
                  child: IconButton(
                      color: Colors.white,
                      splashRadius: 0.01,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        titleController.clear();
                      }))
            ]),
            const SizedBox(height: 30),
            InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: endDate != null ? endDate! : DateTime(2100),
                  );

                  if (pickedDate != null) {
                    Future.delayed(Duration.zero, () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        setState(() {
                          final dateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute);

                          startDate = dateTime;
                        });
                      }
                    });
                  }
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(AppLocalizations.of(context).start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              formatEventTime(startDate ??
                                                  defaultStartDate),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          errors.containsKey('date')
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Text(errors['date']!,
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400)))
                                              : const SizedBox(height: 0),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ]))
                    ])),
            const SizedBox(height: 10),
            InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          startDate != null ? startDate! : DateTime.now(),
                      firstDate:
                          startDate != null ? startDate! : DateTime.now(),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    Future.delayed(Duration.zero, () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime:
                            startDate != null && pickedDate == startDate
                                ? TimeOfDay(
                                    hour: startDate?.hour ?? 0,
                                    minute: startDate?.minute ?? 0)
                                : const TimeOfDay(hour: 0, minute: 0),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          final dateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute);

                          endDate = dateTime;
                        });
                      }
                    });
                  }
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(AppLocalizations.of(context).end,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              formatEventTime(
                                                  endDate ?? defaultEndDate),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          errors.containsKey('date')
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Text(errors['date']!,
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400)))
                                              : const SizedBox(height: 0),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ]))
                    ])),
            const SizedBox(height: 30),
            Row(children: [
              Text(AppLocalizations.of(context).description,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 7.5),
            Row(children: [
              Flexible(
                  flex: 1,
                  child: TextField(
                    controller: descriptionController,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF17181C),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    maxLines: 5,
                    onChanged: (input) {
                      description = input;
                    },
                  ))
            ]),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(AppLocalizations.of(context).activities,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
              IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.playlist_add_rounded),
                color: const Color(0xFF71788D),
                iconSize: 20,
                splashRadius: 0.1,
                constraints: const BoxConstraints(maxWidth: 20, maxHeight: 20),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFF22252D),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                          child: DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.60,
                              minChildSize: 0.60,
                              maxChildSize: 0.60,
                              builder: (context, scrollController) =>
                                  _moduleColor == studentColor
                                      ? futureChooseTasksActivityForm(
                                          context, scrollController)
                                      : futureChooseMediaActivityForm(
                                          context, scrollController))));
                },
              ),
            ]),
            const SizedBox(height: 7.5),
            ...getActivities(),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  startDate = startDate ?? defaultStartDate;
                  endDate = endDate ?? defaultEndDate;

                  // TODO: botão de delete se não mandar id, unico parametro é id
                  validate();
                  if (errors.isNotEmpty) {
                    widget.scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                    setState(() {});
                    return;
                  }

                  _moduleColor == studentColor
                      ? saveStudentEvent
                      : saveMediaEvent;
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
