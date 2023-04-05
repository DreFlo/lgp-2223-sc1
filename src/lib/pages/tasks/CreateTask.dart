// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:emojis/emojis.dart';

class CreateTask extends StatefulWidget {
  final String title, dueDate, projectTitle, institution, subject, description;
  final Priority priority;
  final List<String> notes;

  const CreateTask(
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
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
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
      const SizedBox(height: 100)
    ]);
  }
}
