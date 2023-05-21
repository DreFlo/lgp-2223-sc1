import 'package:floor/floor.dart';
import 'package:src/models/notes/book_note.dart';

@dao
abstract class BookNoteDao {
  @Query('SELECT * FROM book_note')
  Future<List<BookNote>> findAllBookNotes();

  @Query('SELECT * FROM book_note WHERE id = :id')
  Stream<BookNote?> findBookNoteById(int id);

  @Query('SELECT COUNT() FROM book_note WHERE book_id = :bookId')
  Future<int?> countBookNoteByBookId(int bookId);

  @Query('SELECT * FROM book_note WHERE book_id = :bookId')
  Future<List<BookNote>> findBookNoteByBookId(int bookId);

  @Query('SELECT COUNT() FROM book_note')
  Future<int?> countNotes();

  @insert
  Future<int> insertBookNote(BookNote bookNote);

  @insert
  Future<void> insertBookNotes(List<BookNote> bookNotes);

  @update
  Future<void> updateBookNote(BookNote bookNote);

  @update
  Future<void> updateBookNotes(List<BookNote> bookNotes);

  @delete
  Future<void> deleteBookNote(BookNote bookNote);
}
