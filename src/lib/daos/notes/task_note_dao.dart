import 'package:floor/floor.dart';
import 'package:src/models/notes/task_note.dart';

@dao
abstract class TaskNoteDao {
  @Query('SELECT * FROM task_note')
  Future<List<TaskNote>> findAllTaskNotes();

  @Query('SELECT * FROM task_note WHERE id = :id')
  Stream<TaskNote?> findTaskNoteById(int id);

  @insert
  Future<void> insertTaskNote(TaskNote taskNote);

  @insert
  Future<void> insertTaskNotes(List<TaskNote> taskNote);
}
