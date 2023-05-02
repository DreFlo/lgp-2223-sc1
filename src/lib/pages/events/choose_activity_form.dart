import 'package:flutter/material.dart';
import 'package:src/pages/events/event_form.dart';
import 'package:src/widgets/events/bars/choose_activity_bar.dart';
import 'package:src/widgets/events/buttons/save_button.dart';
import 'package:src/widgets/modal.dart';

class ChooseActivity extends Activity {
  bool isSelected;

  ChooseActivity(
      {required super.id,
      required super.title,
      required super.description,
      required this.isSelected});
}

class ChooseActivityForm extends StatefulWidget {
  final String title;
  final String noActivitiesMsg;
  final IconData icon;
  final List<ChooseActivity> activities;
  final ScrollController scrollController;
  final void Function(Activity) addActivityCallback;

  const ChooseActivityForm(
      {Key? key,
      required this.title,
      required this.noActivitiesMsg,
      required this.icon,
      required this.scrollController,
      required this.activities,
      required this.addActivityCallback})
      : super(key: key);

  @override
  State<ChooseActivityForm> createState() => _ChooseActivityFormState();
}

class _ChooseActivityFormState extends State<ChooseActivityForm> {
  List<Widget> getActivities() {
    List<Widget> activitiesList = [];

    for (int i = 0; i < widget.activities.length; i++) {
      ChooseActivity activity = widget.activities[i];
      activitiesList.add(ChooseActivityBar(activity: activity));
      if (i != widget.activities.length - 1) {
        activitiesList.add(const SizedBox(height: 15));
      }
    }

    if (widget.activities.isEmpty) {
      activitiesList.add(Text(widget.noActivitiesMsg,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal)));
    }

    return activitiesList;
  }

  onSaveCallback() {
    for (ChooseActivity activity in widget.activities) {
      if (activity.isSelected) {
        widget.addActivityCallback(Activity(
            id: activity.id,
            title: activity.title,
            description: activity.description));
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 70.0), // Add bottom padding
          child: Modal(
            scrollController: widget.scrollController,
            title: widget.title,
            icon: widget.icon,
            children: [
              const SizedBox(height: 30),
              ...getActivities(),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SaveButton(
              key: const Key('saveActivitiesButton'),
              onSaveCallback: onSaveCallback,
            ),
          ),
        ),
      ],
    );
  }
}
