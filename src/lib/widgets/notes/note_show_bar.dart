import 'package:flutter/material.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/student/task.dart';
import 'package:src/pages/notes/task_note_show.dart';
import 'package:src/themes/colors.dart';

class NoteShowBar extends StatefulWidget {
  final Task task;
  final Note note;
  final void Function(Note n)? editNote;
  final void Function()? deleteNote;
  final int? taskId;

  const NoteShowBar(
      {Key? key,
      required this.task,
      required this.note,
      this.editNote,
      this.deleteNote,
      this.taskId})
      : super(key: key);

  @override
  State<NoteShowBar> createState() => _NoteShowBarState();
}

class _NoteShowBarState extends State<NoteShowBar> {
  late Note note;
  late void Function(Note n)? editNote;
  late void Function()? deleteNote;
  late int? taskId;
  bool selected = false;

  @override
  initState() {
    note = widget.note;
    editNote = widget.editNote;
    deleteNote = widget.deleteNote;
    taskId = widget.taskId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: const Color(0xFF22252D),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (builder) => SingleChildScrollView(
                      child: TaskNoteShow(
                    taskId: widget.task.id!,
                    note: note,
                    callback: editNote,
                    deleteCallback: deleteNote,
                  )));
        },
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
                                  fontWeight: FontWeight.bold)),
                          Text(note.content,
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: selected ? Colors.black : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))
                        ])),
              ],
            )));
  }
}
