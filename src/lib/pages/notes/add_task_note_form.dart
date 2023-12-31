import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/note_task_note_super_entity.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';

class AddTaskNoteForm extends StatefulWidget {
  final int? taskId;
  final void Function(Note n)? callback, deleteNoteCallback;
  final Note? note;

  const AddTaskNoteForm(
      {Key? key,
      this.taskId,
      this.callback,
      this.note,
      this.deleteNoteCallback})
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

    if (widget.note != null) {
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
                              key: const Key('titleNoteField'),
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
                            key: const Key('contentNoteField'),
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
              displayEndButtons(),
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
      errors['title'] = AppLocalizations.of(context).title_error;
    }

    if (contentController.text.isEmpty) {
      errors['content'] = AppLocalizations.of(context).content_error;
    }

    setState(() {});
  }

  save(BuildContext context) async {
    validate();

    if (errors.isEmpty) {
      if (widget.taskId != null) {
        // Note for an existing task
        NoteTaskNoteSuperEntity note;
        Note simpleNote;
        DateTime now = DateTime.now();
        if (widget.note != null) {
          // Edit an already existing note
          note = NoteTaskNoteSuperEntity(
              id: widget.note!.id!,
              title: titleController.text,
              content: contentController.text,
              date: now,
              taskId: widget.taskId!);
          await serviceLocator<NoteTaskNoteSuperDao>()
              .updateNoteTaskNoteSuperEntity(note);

          bool badge = await insertLogAndCheckStreak();
          if (badge) {
            //show badge
            callBadgeWidget(); //streak
          }

          simpleNote = Note(
              id: widget.note!.id,
              title: titleController.text,
              content: contentController.text,
              date: now);
        } else {
          // Add a new note to an existing task
          note = NoteTaskNoteSuperEntity(
              title: titleController.text,
              content: contentController.text,
              date: now,
              taskId: widget.taskId!);

          int id = await serviceLocator<NoteTaskNoteSuperDao>()
              .insertNoteTaskNoteSuperEntity(note);

          bool badge = await insertLogAndCheckStreak();
          if (badge) {
            //show badge
            callBadgeWidget();
            //streak
          }

          simpleNote = Note(
              id: id,
              title: titleController.text,
              content: contentController.text,
              date: now);
        }
        if (widget.callback != null) {
          widget.callback!(simpleNote);
        } else {
          throw Exception(
              'Task note creator without task should have a callback');
        }
      } else {
        Note note = Note(
            title: titleController.text,
            content: contentController.text,
            date: DateTime.now());
        if (widget.callback != null) {
          widget.callback!(note);
        } else {
          throw Exception(
              'Task note creator without task should have a callback');
        }
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  delete(BuildContext context) async {
    NoteTaskNoteSuperEntity noteTaskNoteSuperEntity = NoteTaskNoteSuperEntity(
        id: widget.note!.id,
        title: widget.note!.title,
        content: widget.note!.content,
        date: widget.note!.date,
        taskId: widget.taskId!);

    await serviceLocator<NoteTaskNoteSuperDao>()
        .deleteNoteTaskNoteSuperEntity(noteTaskNoteSuperEntity);

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(); //streak
    }

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    if (widget.deleteNoteCallback != null) {
      widget.deleteNoteCallback!(widget.note!);
    }
  }

  Widget displayEndButtons() {
    if (widget.note == null || widget.taskId == null) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                key: const Key('saveTaskNoteButton'),
                onPressed: () async {
                  await save(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.80, 55),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).save,
                    style: Theme.of(context).textTheme.headlineSmall))
          ]));
    } else {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  key: const Key('saveTaskNoteButton'),
                  onPressed: () async {
                    await save(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 55),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).save,
                      style: Theme.of(context).textTheme.headlineSmall)),
              const SizedBox(width: 20),
              ElevatedButton(
                  key: const Key('deleteTaskNoteButton'),
                  onPressed: () async {
                    await showDeleteConfirmation(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 55),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).delete,
                      style: Theme.of(context).textTheme.headlineSmall))
            ],
          ));
    }
  }

  showDeleteConfirmation(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      key: const Key('cancelConfirmationButton'),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
      ),
      child: Text(AppLocalizations.of(context).cancel,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget deleteButton = ElevatedButton(
      key: const Key('deleteConfirmationButton'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
      ),
      child: Text(AppLocalizations.of(context).delete,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      onPressed: () async {
        delete(context);
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 0,
      title: Text(AppLocalizations.of(context).delete_note,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      content: Text(AppLocalizations.of(context).delete_note_message,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      actions: [
        cancelButton,
        deleteButton,
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: modalBackground,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  callBadgeWidget() {
    unlockBadgeForUser(3, context); //streak
  }
}
