// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

import '../../widgets/events/choose_activity_bar.dart';

class ChooseActivity {
  final int id;
  final String title;
  final String description;
  bool isSelected;

  ChooseActivity(
      {required this.id,
      required this.title,
      required this.description,
      required this.isSelected});
}

class ChooseActivityForm extends StatefulWidget {
  final String title;
  final String noActivityText;
  final List<ChooseActivity> activities;
  final ScrollController scrollController;
  final Function(int, String, String) addActivityCallback;

  const ChooseActivityForm(
      {Key? key,
      required this.scrollController,
      required this.title,
      required this.noActivityText,
      required this.activities,
      required this.addActivityCallback})
      : super(key: key);

  @override
  State<ChooseActivityForm> createState() => _ChooseActivityFormState();
}

class _ChooseActivityFormState extends State<ChooseActivityForm> {
  TextEditingController controller = TextEditingController();

  late List<ChooseActivity>? activities;

  List<Widget> getActivities() {
    List<Widget> activitiesList = [];

    for (int i = 0; i < activities!.length; i++) {
      ChooseActivity activity = activities![i];
      activitiesList.add(ChooseActivityBar(activity: activity));
      if (i != activities!.length - 1) {
        activitiesList.add(const SizedBox(height: 15));
      }
    }

    if (activities == null || activities!.isEmpty) {
      activitiesList.add(Text(widget.noActivityText,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal)));
    }

    return activitiesList;
  }

  @override
  initState() {
    activities = widget.activities;
    activities ??= [];

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
                      const Icon(Icons.live_tv_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(widget.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ])
                  ]))
            ]),
            const SizedBox(height: 30),
            ...getActivities(),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  for (ChooseActivity activity in activities!) {
                    if (activity.isSelected) {
                      widget.addActivityCallback(
                          activity.id, activity.title, activity.description);
                    }
                  }
                  Navigator.pop(context);
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
