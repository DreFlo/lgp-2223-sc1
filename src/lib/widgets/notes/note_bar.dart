import 'package:flutter/material.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/themes/colors.dart';
import 'package:src/pages/notes/add_task_note_form.dart';

class NoteBar extends StatefulWidget {
  final Note note;
  final void Function(Note n) onSelected, onUnselected, editNote, deleteNote;
  final int? taskId;

  const NoteBar(
      {Key? key,
      required this.note,
      required this.onSelected,
      required this.onUnselected,
      required this.editNote,
      required this.deleteNote,
      this.taskId})
      : super(key: key);

  @override
  State<NoteBar> createState() => _NoteBarState();
}

class _NoteBarState extends State<NoteBar> {
  late Note note;
  late void Function(Note n) onSelected, onUnselected, editNote, deleteNote;
  late int? taskId;
  bool selected = false;

  @override
  initState() {
    note = widget.note;
    onUnselected = widget.onUnselected;
    onSelected = widget.onSelected;
    editNote = widget.editNote;
    deleteNote = widget.deleteNote;
    taskId = widget.taskId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? grayButton : lightGray),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Flexible(
                  flex: 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(note.title,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: selected ? Colors.black : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(note.content,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:
                                    selected ? Colors.black : Colors.grey[400],
                                fontSize: 16,
                                fontWeight: FontWeight.normal))
                      ])),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10))),
                    onPressed: () {
                      if (selected) {
                        onUnselected(note);
                      } else {
                        onSelected(note);
                      }
                      setState(() {
                        selected = !selected;
                      });
                    },
                    child: const Icon(Icons.delete)),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10))),
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
                                  callback: editNote,
                                  deleteNoteCallback: deleteNote)));
                    },
                    child: const Icon(Icons.edit))
              ])
            ])));
  }
}
