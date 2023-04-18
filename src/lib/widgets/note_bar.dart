// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/themes/colors.dart';
import 'package:src/pages/notes/add_task_note_form.dart';

class NoteBar extends StatefulWidget {
  final Note note;
  final Function onSelected, onUnselected, editNote;
  final int? taskId;

  const NoteBar(
      {Key? key,
      required this.note,
      required this.onSelected,
      required this.onUnselected,
      required this.editNote,
      this.taskId})
      : super(key: key);

  @override
  State<NoteBar> createState() => _NoteBarState();
}

class _NoteBarState extends State<NoteBar> {
  late Note note;
  late Function onSelected, onUnselected, editNote;
  late int? taskId;
  bool selected = false;

  @override
  initState() {
    note = widget.note;
    onUnselected = widget.onUnselected;
    onSelected = widget.onSelected;
    editNote = widget.editNote;
    taskId = widget.taskId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selected ? grayButton : lightGray),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.title,
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: selected ? Colors.black : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))
                        ])),
                Flexible(
                    flex: 1,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ElevatedButton(
                          child: const Icon(Icons.delete),
                          onPressed: () {
                            if (selected) {
                              onUnselected(note);
                            } else {
                              onSelected(note);
                            }
                            setState(() {
                              selected = !selected;
                            });
                          }),
                      ElevatedButton(
                          child: const Icon(Icons.edit),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: const Color(0xFF22252D),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.0)),
                                ),
                                builder: (builder) => SingleChildScrollView(
                                    child: AddTaskNoteForm(
                                        note: note,
                                        taskId: taskId,
                                        callback: editNote)));
                          })
                    ]))
              ],
            )));
  }
}
