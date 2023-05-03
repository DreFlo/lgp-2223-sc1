import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/pages/notes/add_task_note_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/highlight_text.dart';
import 'dart:math' as math;

class TaskNoteShow extends StatefulWidget {
  final void Function(Note n)? callback;
  final void Function()? deleteCallback;
  final int taskId;
  final Note note;

  const TaskNoteShow({
    Key? key,
    required this.taskId,
    required this.note,
    this.callback,
    this.deleteCallback,
  }) : super(key: key);

  @override
  State<TaskNoteShow> createState() => _TaskNoteShowState();
}

class _TaskNoteShowState extends State<TaskNoteShow> {
  Map<String, String> errors = {};
  bool init = false;
  late Note note;
  @override
  initState() {
    super.initState();
    note = widget.note;
    init = true;
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
      Container(
          width: MediaQuery.of(context).size.width * 0.90,
          padding: const EdgeInsets.only(left: 18),
          child: Column(children: [
            Text(AppLocalizations.of(context).add_general_note_callout,
                softWrap: true,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left),
            const SizedBox(height: 10),
          ])),
      const SizedBox(height: 15),
      getTitle(context),
      const SizedBox(height: 30),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18, top: 10),
            child: Text(
              AppLocalizations.of(context).description,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: 200,
                child: HighlightText(note.content,
                    key: const Key('contentNoteField'))))
      ]),
      displayEndButtons(),
      const SizedBox(height: 150)
    ]);
  }

  Widget getTitle(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(width: 20),
      Flexible(
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
                            MaterialStateProperty.all(studentColor)),
                    onPressed: () {},
                    child: Container(
                        decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    )),
                  )))),
      const SizedBox(width: 30),
      Flexible(
          flex: 10,
          child: Text(
            note.title,
            key: const Key('titleNoteField'),
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
            maxLines: 1,
          )),
    ]);
  }

  Widget displayEndButtons() {
    return Padding(
        padding: const EdgeInsets.only(left: 40, top: 30),
        child: ElevatedButton(
            key: const Key('taskNoteEditButton'),
            onPressed: () async {
              edit(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.80, 55),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: Text(AppLocalizations.of(context).edit,
                style: Theme.of(context).textTheme.headlineSmall)));
  }

  edit(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF22252D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        builder: (builder) => SingleChildScrollView(
            child: AddTaskNoteForm(
                note: note,
                taskId: widget.taskId,
                callback: editNote,
                deleteNoteCallback: deleteNote)));
  }

  editNote(Note n) {
    setState(() {
      note = n;
    });
    if (widget.callback != null) {
      widget.callback!(n);
    }
  }

  deleteNote(Note n) {
    Navigator.pop(context);
    if (widget.deleteCallback != null) {
      widget.deleteCallback!();
    }
  }
}
