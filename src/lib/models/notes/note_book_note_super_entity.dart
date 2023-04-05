import 'package:src/models/notes/book_note.dart';
import 'package:src/models/notes/note.dart';

class NoteBookNoteSuperEntity {
  int? id;
  String title;
  String content;
  DateTime date;
  int startPage;
  int endPage;
  int bookId;

  NoteBookNoteSuperEntity({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.startPage,
    required this.endPage,
    required this.bookId,
  });

  NoteBookNoteSuperEntity.fromNoteBookNoteEntity(BookNote bookNote, Note note)
      : id = note.id,
        title = note.title,
        content = note.content,
        date = note.date,
        startPage = bookNote.startPage,
        endPage = bookNote.endPage,
        bookId = bookNote.bookId;

  Note toNote() {
    return Note(
      id: id,
      title: title,
      content: content,
      date: date,
    );
  }

  BookNote toBookNote() {
    return BookNote(
      id: id!,
      startPage: startPage,
      endPage: endPage,
      bookId: bookId,
    );
  }

  NoteBookNoteSuperEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    int? startPage,
    int? endPage,
    int? bookId,
  }) {
    return NoteBookNoteSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      startPage: startPage ?? this.startPage,
      endPage: endPage ?? this.endPage,
      bookId: bookId ?? this.bookId,
    );
  }
}
