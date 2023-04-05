// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:emojis/emojis.dart';

class CreateForm extends StatefulWidget {
  final String title, dueDate, projectTitle, institution, subject, description;
  final Priority priority;
  final List<String> notes;

  const CreateForm(
      {Key? key,
      required this.title,
      required this.dueDate,
      required this.projectTitle,
      required this.institution,
      required this.subject,
      required this.priority,
      required this.description,
      required this.notes})
      : super(key: key);

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  late String title, dueDate, projectTitle, institution, subject, description;
  late Priority priority;
  late List<String> notes;

  @override
  initState() {
    title = widget.title;
    dueDate = widget.dueDate;
    projectTitle = widget.projectTitle;
    institution = widget.institution;
    subject = widget.subject;
    description = widget.description;
    priority = widget.priority;
    notes = widget.notes;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: [
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
      Padding(
          padding: EdgeInsets.only(left: 18),
          child: Row(children: [
            ElevatedButton(
                onPressed: () {
                  //TODO: Change the form.
                },
                child: Wrap(children: [
                  Icon(Icons.task),
                  Text(AppLocalizations.of(context).task,
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.start)
                ]))
          ])),
      const SizedBox(height: 100)
    ]);
  }
}
