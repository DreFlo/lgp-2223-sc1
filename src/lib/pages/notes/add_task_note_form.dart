// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/note_task_note_super_entity.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';

class AddTaskNoteForm extends StatefulWidget {
  final int? id;
  final int? taskId;
  final Function? callback;
  final Note? note;

  const AddTaskNoteForm(
      {Key? key, this.id, this.taskId, this.callback, this.note})
      : super(key: key);

  @override
  State<AddTaskNoteForm> createState() => _AddTaskNoteFormState();
}

class _AddTaskNoteFormState extends State<AddTaskNoteForm> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Map<String, String> errors = {};
  bool init = false;

  Future<int> fillTaskFields() async {
    if (init) {
      return 0;
    }

    if (widget.id != null) {
      Note? note =
          await serviceLocator<NoteDao>().findNoteById(widget.id!).first;

      titleController.text = note!.title;
      contentController.text = note.content;
    } else if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    } else {
      titleController.clear();
      contentController.clear();
    }

    init = true;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fillTaskFields(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
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
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          flex: 10,
                          child: TextField(
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
                              ))),
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
              ),
              errors.containsKey('title')
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18, top: 5),
                      child: Text(errors['title']!,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)))
                  : const SizedBox(height: 0),
              Row(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 18, top: 10),
                    child: Text(
                      AppLocalizations.of(context).add_note,
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
                        child: TextField(
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 10,
                            controller: contentController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: textField,
                              helperStyle:
                                  Theme.of(context).textTheme.labelSmall,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ))))
              ]),
              errors.containsKey('content')
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18, top: 5.0),
                      child: Text(errors['content']!,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)))
                  : const SizedBox(height: 0),
              Padding(
                  padding: const EdgeInsets.only(left: 18, top: 30),
                  child: ElevatedButton(
                      onPressed: () async {
                        validate();

                        if (errors.isEmpty) {
                          if (widget.callback != null &&
                              widget.taskId == null) {
                            Note note;
                            if (widget.note != null) {
                              note = Note(
                                  id: widget.note!.id,
                                  title: titleController.text,
                                  content: contentController.text,
                                  date: DateTime.now());
                            } else {
                              note = Note(
                                  title: titleController.text,
                                  content: contentController.text,
                                  date: DateTime.now());
                            }
                            widget.callback!(note);
                          } else if (widget.id != null) {
                            NoteTaskNoteSuperEntity note =
                                NoteTaskNoteSuperEntity(
                                    id: widget.id!,
                                    title: titleController.text,
                                    content: contentController.text,
                                    date: DateTime.now(),
                                    taskId: widget.taskId!);

                            await serviceLocator<NoteTaskNoteSuperDao>()
                                .updateNoteTaskNoteSuperEntity(note);
                          } else {
                            NoteTaskNoteSuperEntity note =
                                NoteTaskNoteSuperEntity(
                                    title: titleController.text,
                                    content: contentController.text,
                                    date: DateTime.now(),
                                    taskId: widget.taskId!);

                            await serviceLocator<NoteTaskNoteSuperDao>()
                                .insertNoteTaskNoteSuperEntity(note);
                          }

                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.90, 55),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context).save,
                          style: Theme.of(context).textTheme.headlineSmall))),
              const SizedBox(height: 150)
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  validate() {
    errors = {};

    if (titleController.text.isEmpty) {
      errors['title'] = 'Title is required';
    }

    if (contentController.text.isEmpty) {
      errors['content'] = 'Content is required';
    }

    setState(() {});
  }
}
