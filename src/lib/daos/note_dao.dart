import 'package:floor/floor.dart';
import 'package:src/models/note.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM note')
  Future<List<Note>> findAllNotes();

  @Query('SELECT * FROM note WHERE id = :id')
  Stream<Note?> findNoteById(int id);

  @Query('SELECT * FROM note WHERE subject_id = :id')
  Stream<Note?> findNoteBySubjectId(int id);

  @Query('SELECT * FROM note WHERE task_id = :id')
  Stream<Note?> findNoteByTaskId(int id);

  @insert
  Future<void> insertNote(Note note);

  @insert
  Future<void> insertNotes(List<Note> notes);
}
