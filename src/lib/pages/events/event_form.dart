import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/media_media_timeslot.dart';
import 'package:src/models/timeslot/task_student_timeslot.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/services/local_notifications_service.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/formatters.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/validators.dart';
import 'package:src/widgets/events/buttons/delete_button.dart';
import 'package:src/widgets/events/buttons/module_button.dart';
import 'package:src/widgets/events/buttons/save_button.dart';
import 'package:src/widgets/events/dates/end_date_picker.dart';
import 'package:src/widgets/events/dates/start_date_picker.dart';
import 'package:src/widgets/events/edit_texts/edit_description.dart';
import 'package:src/widgets/events/edit_texts/edit_title.dart';
import 'package:src/widgets/events/lists/media_list.dart';
import 'package:src/widgets/events/lists/tasks_list.dart';
import 'package:src/widgets/modal.dart';

class Activity {
  final int id;
  final String title;
  final String description;

  Activity({required this.id, required this.title, required this.description});
}

class EventForm extends StatefulWidget {
  final int? id;
  final ScrollController scrollController;
  final EventType? type;
  final Function()? callback;

  const EventForm(
      {Key? key,
      required this.scrollController,
      this.id,
      this.type,
      this.callback})
      : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final GlobalKey buttonKey = GlobalKey();

  bool initialized = false;
  Map<String, String> errors = {};
  Color _moduleColor = studentColor;

  String title = '';
  String description = '';
  List<Activity> activities = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(hours: 1));

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  void addActivity(Activity activity) {
    setState(() {
      activities.add(activity);
    });
  }

  void removeActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  void clearActivities() {
    setState(() {
      activities = [];
    });
  }

  void setModuleColor(Color color) {
    setState(() {
      _moduleColor = color;
    });
  }

  void setStartDate(DateTime date) {
    setState(() {
      startDate = date;
    });
  }

  void setEndDate(DateTime date) {
    setState(() {
      endDate = date;
    });
  }

  Future<int> onInitEvent() async {
    if (initialized) {
      return 0;
    }

    if (widget.id != null) {
      Timeslot? timeslot = await serviceLocator<TimeslotDao>()
          .findTimeslotById(widget.id!)
          .first;

      title = timeslot!.title;
      description = timeslot.description;
      startDate = timeslot.startDateTime;
      endDate = timeslot.endDateTime;

      if (widget.type == null || widget.type == EventType.student) {
        _moduleColor = studentColor;
        initStudentEventActivities();
      } else if (widget.type == EventType.leisure) {
        _moduleColor = leisureColor;
        initMediaEventActivities();
      }
    }

    titleController.text = title;
    descriptionController.text = description;
    initialized = true;
    return 1;
  }

  void initMediaEventActivities() async {
    List<Media> media = await serviceLocator<MediaMediaTimeslotDao>()
        .findMediaByMediaTimeslotId(widget.id!);

    setState(() {
      activities = media
          .map((e) =>
              Activity(id: e.id!, title: e.name, description: e.description))
          .toList();
    });
  }

  void initStudentEventActivities() async {
    List<Task> tasks = await serviceLocator<TaskStudentTimeslotDao>()
        .findTaskByStudentTimeslotId(widget.id!);

    setState(() {
      activities = tasks
          .map((e) => Activity(
              id: e.id!,
              title: e.name,
              description: '(${formatDeadline(e.deadline)}) ${e.description}'))
          .toList();
    });
  }

  TimeslotMediaTimeslotSuperEntity getMediaTimeslot() {
    return TimeslotMediaTimeslotSuperEntity(
        id: widget.id,
        title: titleController.text,
        description: descriptionController.text,
        startDateTime: startDate,
        endDateTime: endDate,
        xpMultiplier: 0,
        userId: serviceLocator<AuthenticationService>().getLoggedInUserId(),
        finished: false);
  }

  TimeslotStudentTimeslotSuperEntity getStudentTimeslot() {
    return TimeslotStudentTimeslotSuperEntity(
      id: widget.id,
      title: titleController.text,
      description: descriptionController.text,
      startDateTime: startDate,
      endDateTime: endDate,
      userId: serviceLocator<AuthenticationService>().getLoggedInUserId(),
      xpMultiplier: 0,
      finished: false,
    );
  }

  void onSaveCallback() async {
    errors = validateEventForm(
        context, titleController.text, startDate, endDate, activities);
    if (errors.isNotEmpty) {
      widget.scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      setState(() {});
      return;
    }

    _moduleColor == studentColor
        ? await saveStudentEvent()
        : await saveMediaEvent();

    if (widget.callback != null) {
      widget.callback!();
    }

    // To test notification scheduling change schedule time
    // TODO: Figure out ids
    if (_moduleColor == studentColor) {
      TimeslotStudentTimeslotSuperEntity studentTimeslot = getStudentTimeslot();
      if (context.mounted) {
        serviceLocator<LocalNotificationService>().scheduleNotification(
            DateTime.now().microsecondsSinceEpoch % 1000000,
            '🟡${studentTimeslot.title} ${AppLocalizations.of(context).starting}',
            studentTimeslot.startDateTime,
            studentTimeslot.description);
        serviceLocator<LocalNotificationService>().scheduleNotification(
            DateTime.now().microsecondsSinceEpoch % 9999999,
            '🟡${studentTimeslot.title} ${AppLocalizations.of(context).ending}',
            studentTimeslot.endDateTime,
            studentTimeslot.description);
      }
    } else if (_moduleColor == leisureColor) {
      TimeslotMediaTimeslotSuperEntity mediaTimeslot = getMediaTimeslot();
      if (context.mounted) {
        serviceLocator<LocalNotificationService>().scheduleNotification(
            DateTime.now().microsecondsSinceEpoch % 1000000,
            '🔴${mediaTimeslot.title} ${AppLocalizations.of(context).starting}',
            mediaTimeslot.startDateTime,
            mediaTimeslot.description);
        serviceLocator<LocalNotificationService>().scheduleNotification(
            DateTime.now().microsecondsSinceEpoch % 9999999,
            '🔴${mediaTimeslot.title} ${AppLocalizations.of(context).ending}',
            mediaTimeslot.endDateTime,
            mediaTimeslot.description);
      }
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> saveMediaEvent() async {
    TimeslotMediaTimeslotSuperEntity mediaTimeslot = getMediaTimeslot();

    int id;
    if (widget.id == null) {
      id = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
          .insertTimeslotMediaTimeslotSuperEntity(mediaTimeslot);
    } else {
      id = widget.id!;
      await serviceLocator<TimeslotMediaTimeslotSuperDao>()
          .updateTimeslotMediaTimeslotSuperEntity(mediaTimeslot);

      await serviceLocator<MediaMediaTimeslotDao>()
          .deleteMediaMediaTimeslotByMediaTimeslotId(id);
    }

    List<MediaMediaTimeslot> mediaMediaTimeslots = activities
        .map((activity) =>
            MediaMediaTimeslot(mediaId: activity.id, mediaTimeslotId: id))
        .toList();

    if (mediaMediaTimeslots.isNotEmpty) {
      await serviceLocator<MediaMediaTimeslotDao>()
          .insertMediaMediaTimeslots(mediaMediaTimeslots);
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget();
    }
  }

  Future<void> saveStudentEvent() async {
    TimeslotStudentTimeslotSuperEntity studentTimeslot = getStudentTimeslot();

    int id;
    if (widget.id == null) {
      id = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
          .insertTimeslotStudentTimeslotSuperEntity(studentTimeslot);
    } else {
      id = widget.id!;
      await serviceLocator<TimeslotStudentTimeslotSuperDao>()
          .updateTimeslotStudentTimeslotSuperEntity(studentTimeslot);

      await serviceLocator<TaskStudentTimeslotDao>()
          .deleteTaskStudentTimeslotByStudentTimeslotId(id);
    }

    List<TaskStudentTimeslot> taskStudentTimeslots = activities
        .map((activity) =>
            TaskStudentTimeslot(taskId: activity.id, studentTimeslotId: id))
        .toList();

    if (taskStudentTimeslots.isNotEmpty) {
      await serviceLocator<TaskStudentTimeslotDao>()
          .insertTaskStudentTimeslots(taskStudentTimeslots);
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget();
    }
  }

  void onDeleteCallback() async {
    if (widget.id != null) {
      _moduleColor == studentColor
          ? await deleteStudentEvent()
          : await deleteMediaEvent();

      if (widget.callback != null) {
        widget.callback!();
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> deleteMediaEvent() async {
    await serviceLocator<MediaMediaTimeslotDao>()
        .deleteMediaMediaTimeslotByMediaTimeslotId(widget.id!);

    TimeslotMediaTimeslotSuperEntity mediaTimeslot = getMediaTimeslot();
    await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .deleteTimeslotMediaTimeslotSuperEntity(mediaTimeslot);

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(); //streak
    }
  }

  Future<void> deleteStudentEvent() async {
    await serviceLocator<TaskStudentTimeslotDao>()
        .deleteTaskStudentTimeslotByStudentTimeslotId(widget.id!);

    TimeslotStudentTimeslotSuperEntity studentTimeslot = getStudentTimeslot();
    await serviceLocator<TimeslotStudentTimeslotSuperDao>()
        .deleteTimeslotStudentTimeslotSuperEntity(studentTimeslot);

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(); //streak
    }
  }

  callBadgeWidget() {
    unlockBadgeForUser(3, context);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: onInitEvent(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Modal(
                title: widget.id == null
                    ? AppLocalizations.of(context).new_event
                    : AppLocalizations.of(context).edit_event,
                icon: Icons.event,
                scrollController: widget.scrollController,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ModuleButton(
                              buttonKey: buttonKey,
                              moduleColor: _moduleColor,
                              setModuleColor: setModuleColor,
                              clearActivities: clearActivities,
                              disabled: widget.id != null,
                            ),
                            const VerticalDivider(),
                            EditTitle(
                                key: const Key('titleField'),
                                titleController: titleController,
                                errors: errors)
                          ])),
                  const SizedBox(height: 30),
                  StartDatePicker(
                      startDate: startDate,
                      endDate: endDate,
                      setStartDate: setStartDate,
                      errors: errors),
                  const SizedBox(height: 30),
                  EndDatePicker(
                      endDate: endDate,
                      startDate: startDate,
                      setEndDate: setEndDate,
                      errors: errors),
                  const SizedBox(height: 30),
                  EditDescription(
                      key: const Key('descriptionField'),
                      descriptionController: descriptionController),
                  const SizedBox(height: 10),
                  _moduleColor == studentColor
                      ? TasksList(
                          activities: activities,
                          addActivity: addActivity,
                          removeActivity: removeActivity,
                          errors: errors)
                      : MediaList(
                          activities: activities,
                          addActivity: addActivity,
                          removeActivity: removeActivity,
                          errors: errors),
                  const SizedBox(height: 30),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                          flex: 1,
                          child: SaveButton(
                              key: const Key('saveEventButton'),
                              onSaveCallback: onSaveCallback)),
                      if (widget.id != null) ...[
                        const SizedBox(width: 20),
                        Flexible(
                            flex: 1,
                            child: DeleteButton(
                                key: const Key('deleteEventButton'),
                                onDeleteCallback: onDeleteCallback))
                      ]
                    ],
                  )
                ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
