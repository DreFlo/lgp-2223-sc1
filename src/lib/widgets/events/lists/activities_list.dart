import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/events/choose_activity_form.dart';
import 'package:src/pages/events/event_form.dart';
import 'package:src/widgets/events/bars/activity_bar.dart';

abstract class ActivitiesList extends StatefulWidget {
  final List<Activity> activities;
  final void Function(int) removeActivity;
  final void Function(Activity) addActivity;
  final Map<String, String> errors;

  const ActivitiesList(
      {Key? key,
      required this.activities,
      required this.addActivity,
      required this.removeActivity,
      required this.errors})
      : super(key: key);

  @override
  State<ActivitiesList> createState() => _ActivitiesListState();

  Future<List<ChooseActivity>> getActivities();

  ChooseActivityForm getChooseActivityForm(BuildContext context,
      ScrollController scrollController, List<ChooseActivity> snapshot);
}

class _ActivitiesListState extends State<ActivitiesList> {
  Future<List<ChooseActivity>> activities = Future.value([]);

  @override
  initState() {
    super.initState();
  }

  FutureBuilder<List<ChooseActivity>> futureChooseActivityForm(
      BuildContext context,
      ScrollController scrollController,
      Future<List<ChooseActivity>> activities) {
    return FutureBuilder<List<ChooseActivity>>(
      future: activities,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.getChooseActivityForm(
              context, scrollController, snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<Widget> getActivityWidgets() {
    List<Widget> activitiesList = [];

    for (int i = 0; i < widget.activities.length; i++) {
      activitiesList.add(ActivityBar(
          id: widget.activities[i].id,
          title: widget.activities[i].title,
          description: widget.activities[i].description,
          removeActivityCallback: () => widget.removeActivity(i)));
      if (i != widget.activities.length - 1) {
        activitiesList.add(const SizedBox(height: 15));
      }
    }

    if (widget.activities.isEmpty) {
      activitiesList.add(Text(AppLocalizations.of(context).no_activities,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal)));
    }

    if (widget.errors.containsKey('activities')) {
      activitiesList.add(Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 10.0),
          child: Text(widget.errors['activities']!,
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w400))));
    }

    return activitiesList;
  }

  @override
  Widget build(BuildContext context) {
    activities = widget.getActivities();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(AppLocalizations.of(context).activities,
            style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF71788D),
                fontSize: 16,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center),
        IconButton(
          key: const Key('addActivitiesButton'),
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
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    child: DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.60,
                        minChildSize: 0.60,
                        maxChildSize: 0.60,
                        builder: (context, scrollController) =>
                            futureChooseActivityForm(
                                context, scrollController, activities))));
          },
        ),
      ]),
      const SizedBox(height: 7.5),
      ...getActivityWidgets(),
    ]);
  }
}
