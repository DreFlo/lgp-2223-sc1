import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';
import 'package:src/models/timeslot/media_media_timeslot.dart';
import 'package:src/models/timeslot/task_student_timeslot.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/validators.dart';
import 'package:src/widgets/events/buttons/delete_button.dart';
import 'package:src/widgets/events/edit_texts/edit_description.dart';
import 'package:src/widgets/events/edit_texts/edit_title.dart';
import 'package:src/widgets/events/dates/end_date_picker.dart';
import 'package:src/widgets/events/buttons/module_button.dart';
import 'package:src/widgets/events/buttons/save_button.dart';
import 'package:src/widgets/events/dates/start_date_picker.dart';
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

  const EventForm({Key? key, required this.scrollController, this.id})
      : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final GlobalKey buttonKey = GlobalKey();

  Map<String, String> errors = {};
  Color _moduleColor = studentColor;

  String title = '';
  String description = '';
  List<Activity> activities = [];
  DateTime defaultStartDate = DateTime.now();
  DateTime defaultEndDate = DateTime.now().add(const Duration(hours: 1));

  DateTime? startDate;
  DateTime? endDate;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  initState() {
    if (widget.id != null) {
      // TODO(eventos): get event info from database
    }

    super.initState();
  }

  addActivity(Activity activity) {
    setState(() {
      activities.add(activity);
    });
  }

  removeActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  clearActivities() {
    setState(() {
      activities = [];
    });
  }

  setModuleColor(Color color) {
    setState(() {
      _moduleColor = color;
    });
  }

  setStartDate(DateTime date) {
    setState(() {
      startDate = date;
    });
  }

  setEndDate(DateTime date) {
    setState(() {
      endDate = date;
    });
  }

  void onSaveCallback() {
    startDate ??= defaultStartDate;
    endDate ??= defaultEndDate;

    errors = validateEventForm(
        context, titleController.text, startDate, endDate, activities);
    if (errors.isNotEmpty) {
      widget.scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      setState(() {});
      return;
    }
    _moduleColor == studentColor ? saveStudentEvent() : saveMediaEvent();

    Navigator.pop(context);
  }

  void saveMediaEvent() async {
    // TODO(eventos): correct xp formula and get user logged id

    TimeslotMediaTimeslotSuperEntity mediaTimeslot =
        TimeslotMediaTimeslotSuperEntity(
      title: titleController.text,
      description: descriptionController.text,
      startDateTime: startDate ?? defaultStartDate,
      endDateTime: endDate ?? defaultEndDate,
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
      title: titleController.text,
      description: descriptionController.text,
      startDateTime: startDate ?? defaultStartDate,
      endDateTime: endDate ?? defaultEndDate,
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
  Widget build(BuildContext context) {
    return Modal(
        title: widget.id == null
            ? AppLocalizations.of(context).new_event
            : AppLocalizations.of(context).edit_event,
        icon: Icons.event,
        scrollController: widget.scrollController,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(width: 7.5),
            ModuleButton(
                buttonKey: buttonKey,
                moduleColor: _moduleColor,
                setModuleColor: setModuleColor,
                clearActivities: clearActivities),
            const SizedBox(width: 15),
            EditTitle(titleController: titleController, errors: errors)
          ]),
          const SizedBox(height: 30),
          StartDatePicker(
              startDate: startDate ?? defaultStartDate,
              endDate: endDate ?? defaultEndDate,
              setStartDate: setStartDate,
              errors: errors),
          const SizedBox(height: 10),
          EndDatePicker(
              endDate: endDate ?? defaultEndDate,
              startDate: startDate ?? defaultStartDate,
              setEndDate: setEndDate,
              errors: errors),
          const SizedBox(height: 30),
          EditDescription(descriptionController: descriptionController),
          const SizedBox(height: 30),
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
                  flex: 1, child: SaveButton(onSaveCallback: onSaveCallback)),
              if (widget.id != null) ...[
                const SizedBox(width: 20),
                const Flexible(flex: 1, child: DeleteButton())
              ]
            ],
          )
        ]);
  }
}
