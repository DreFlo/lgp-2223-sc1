import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/task_note.dart';

class NoteTaskNoteSuperEntity {
  int? id;
  String title;
  String content;
  DateTime date;
  int taskId;

  NoteTaskNoteSuperEntity({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.taskId,
  });

  NoteTaskNoteSuperEntity.fromNoteTaskNoteEntity(TaskNote taskNote, Note note)
      : id = note.id,
        title = note.title,
        content = note.content,
        date = note.date,
        taskId = taskNote.taskId;

  Note toNote() {
    return Note(
      id: id,
      title: title,
      content: content,
      date: date,
    );
  }

  TaskNote toTaskNote() {
    return TaskNote(
      id: id!,
      taskId: taskId,
    );
  }

  NoteTaskNoteSuperEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    int? taskId,
  }) {
    return NoteTaskNoteSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      taskId: taskId ?? this.taskId,
    );
  }
}