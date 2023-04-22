// ignore_for_file: file_names, library_prefixes

import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:src/pages/events/choose_activity_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/events/activity_bar.dart';

import '../../utils/formatters.dart';

class Activity {
  final int
      id; // TODO(eventos): I put this here because I think it is useful for the backend, but idk, feel free to change
  final String title;
  final String description;

  Activity({required this.id, required this.title, required this.description});
}

class EventForm extends StatefulWidget {
  final String? title, startTime, endTime, description;
  final ScrollController scrollController;
  final List<Activity>? activities;

  const EventForm(
      {Key? key,
      required this.scrollController,
      this.title,
      this.startTime,
      this.endTime,
      this.description,
      this.activities})
      : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  TextEditingController controller = TextEditingController();

  final GlobalKey buttonKey = GlobalKey();
  Color _moduleColor = studentColor;

  late String? title, startTime, endTime, description;
  late Priority? priority;
  late List<Activity> activities;
  DateTime? startDate;
  TimeOfDay? startTimeOfDay;
  DateTime? endDate;
  TimeOfDay? endTimeOfDay;

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

  List<ChooseActivity> getMedia() {
    //TODO(eventos): Get media from database and transform to ChooseActivity.

    List<ChooseActivity> media = [];

    media.add(ChooseActivity(
      id: 1,
      title: "Media 1",
      description: 'TV Show',
      isSelected: false,
    ));

    media.add(ChooseActivity(
      id: 2,
      title: "Media 2",
      description: 'Movie',
      isSelected: false,
    ));

    media.add(ChooseActivity(
      id: 3,
      title: "Media 3",
      description: 'Book',
      isSelected: false,
    ));

    return media;
  }

  List<ChooseActivity> getTasks() {
    //TODO(eventos): Get tasks from database and transform to ChooseActivity.

    List<ChooseActivity> tasks = [];

    tasks.add(ChooseActivity(
      id: 1,
      title: "Task 1",
      description: formatDeadline(DateTime.now()),
      isSelected: false,
    ));

    tasks.add(ChooseActivity(
      id: 2,
      title: "Task 2",
      description: formatDeadline(DateTime.now()),
      isSelected: false,
    ));

    tasks.add(ChooseActivity(
      id: 3,
      title: "Task 3",
      description: formatDeadline(DateTime.now()),
      isSelected: false,
    ));

    return tasks;
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

  @override
  initState() {
    title = widget.title;
    startTime = widget.startTime;
    endTime = widget.endTime;
    description = widget.description;
    activities = widget.activities ?? [];

    controller.text = title!;

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
                          angle: -Math.pi / 4,
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
                  child: TextField(
                      controller: controller,
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
                            borderSide: BorderSide(color: Color(0xFF414554))),
                        hintText: AppLocalizations.of(context).title,
                        hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF71788D),
                            fontWeight: FontWeight.w400),
                      ))),
              const SizedBox(width: 5),
              Flexible(
                  flex: 1,
                  child: IconButton(
                      color: Colors.white,
                      splashRadius: 0.01,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.clear();
                      }))
            ]),
            const SizedBox(height: 30),
            InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: endDate != null ? endDate! : DateTime(2100));

                  if (pickedDate != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        String? day = pickedDate.day.toString().padLeft(2, '0'),
                            month = pickedDate.month.toString().padLeft(2, '0'),
                            year = pickedDate.year.toString(),
                            minute =
                                pickedTime.minute.toString().padLeft(2, '0');

                        // Convert start and end times to DateTime objects
                        final dateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute);

                        // Format hours with AM/PM
                        final hour = DateFormat('h').format(dateTime);
                        final amPm = DateFormat('a').format(dateTime);

                        startDate = pickedDate;
                        startTimeOfDay = pickedTime;
                        startTime = "$day/$month/$year $hour:$minute$amPm";
                      });
                    }
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
                                        children: [
                                          Text(startTime!,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal))
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
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: startDate != null && pickedDate == startDate
                          ? TimeOfDay(
                              hour: startTimeOfDay?.hour ?? 0,
                              minute: startTimeOfDay?.minute ?? 0)
                          : TimeOfDay(hour: 0, minute: 0),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        String? day = pickedDate.day.toString().padLeft(2, '0'),
                            month = pickedDate.month.toString().padLeft(2, '0'),
                            year = pickedDate.year.toString(),
                            minute =
                                pickedTime.minute.toString().padLeft(2, '0');

                        // Convert start and end times to DateTime objects
                        final dateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute);

                        // Format hours with AM/PM
                        final hour = DateFormat('h').format(dateTime);
                        final amPm = DateFormat('a').format(dateTime);

                        endDate = pickedDate;
                        endTime = "$day/$month/$year $hour:$minute$amPm";
                      });
                    }
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
                                        children: [
                                          Text(endTime!,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal))
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
                    controller: TextEditingController(text: description),
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
                                      ? ChooseActivityForm(
                                          scrollController: scrollController,
                                          activities: getTasks(),
                                          addActivityCallback:
                                              addActivityCallback)
                                      : ChooseActivityForm(
                                          scrollController: scrollController,
                                          activities: getMedia(),
                                          addActivityCallback:
                                              addActivityCallback))));
                },
              ),
            ]),
            const SizedBox(height: 7.5),
            ...getActivities(),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  //TODO(eventos): Save event on db
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
