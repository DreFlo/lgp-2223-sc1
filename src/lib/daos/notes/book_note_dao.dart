import 'package:floor/floor.dart';
import 'package:src/models/notes/book_note.dart';

@dao
abstract class BookNoteDao {
  @Query('SELECT * FROM book_note')
  Future<List<BookNote>> findAllBookNotes();

  @Query('SELECT * FROM book_note WHERE id = :id')
  Stream<BookNote?> findBookNoteById(int id);

  @insert
  Future<void> insertBookNote(BookNote bookNote);

  @insert
  Future<void> insertBookNotes(List<BookNote> bookNotes);

  @update
  Future<void> updateBookNote(BookNote bookNote);

  @delete
  Future<void> deleteBookNote(BookNote bookNote);
}
