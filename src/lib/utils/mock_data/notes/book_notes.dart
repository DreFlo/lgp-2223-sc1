import 'package:src/models/notes/note_book_note_super_entity.dart';

final mockBookNotes = [
  NoteBookNoteSuperEntity(
      id: 1,
      title: 'Notey McNoteFace',
      content: 'This is a note about a book.',
      date: DateTime.now(),
      startPage: 1,
      endPage: 50,
      bookId: 4),
  NoteBookNoteSuperEntity(
      id: 5,
      title: 'Vin',
      content: 'Poor urchin Vin',
      date: DateTime.now(),
      startPage: 1,
      endPage: 50,
      bookId: 7),
  NoteBookNoteSuperEntity(
      id: 6,
      title: 'Kelsier',
      content: 'This guy is cool',
      date: DateTime.now(),
      startPage: 51,
      endPage: 100,
      bookId: 7),
  NoteBookNoteSuperEntity(
      id: 7,
      title: 'Mistborn trainnig',
      content: 'Flying around while pushing must be fun',
      date: DateTime.now(),
      startPage: 101,
      endPage: 151,
      bookId: 7),
  NoteBookNoteSuperEntity(
      id: 8,
      title: 'The Lord Ruler',
      content: 'That guy made everything worse',
      date: DateTime.now(),
      startPage: 1,
      endPage: 50,
      bookId: 8),
];
