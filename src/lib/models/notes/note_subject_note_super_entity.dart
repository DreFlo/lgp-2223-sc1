import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/subject_note.dart';

class NoteSubjectNoteSuperEntity {
  int? id;
  String title;
  String content;
  DateTime date;
  int subjectId;

  NoteSubjectNoteSuperEntity({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.subjectId,
  });

  NoteSubjectNoteSuperEntity.fromNoteSubjectNoteEntity(
      SubjectNote subjectNote, Note note)
      : id = note.id,
        title = note.title,
        content = note.content,
        date = note.date,
        subjectId = subjectNote.subjectId;

  Note toNote() {
    return Note(
      id: id,
      title: title,
      content: content,
      date: date,
    );
  }

  SubjectNote toSubjectNote() {
    return SubjectNote(
      id: id!,
      subjectId: subjectId,
    );
  }

  NoteSubjectNoteSuperEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    int? subjectId,
  }) {
    return NoteSubjectNoteSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      subjectId: subjectId ?? this.subjectId,
    );
  }
}
