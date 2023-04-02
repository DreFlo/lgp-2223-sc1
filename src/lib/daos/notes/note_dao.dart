import 'package:floor/floor.dart';
import 'package:src/models/notes/note.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM note')
  Future<List<Note>> findAllNotes();

  @Query('SELECT * FROM note WHERE id = :id')
  Stream<Note?> findNoteById(int id);

  @insert
  Future<void> insertNote(Note note);

  @insert
  Future<void> insertNotes(List<Note> notes);

  @update
  Future<void> updateNote(Note note);

  @update
  Future<void> updateNotes(List<Note> notes);

  @delete
  Future<void> deleteNote(Note note);
}
