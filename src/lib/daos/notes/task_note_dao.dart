import 'package:floor/floor.dart';
import 'package:src/models/notes/task_note.dart';

@dao
abstract class TaskNoteDao {
  @Query('SELECT * FROM task_note')
  Future<List<TaskNote>> findAllTaskNotes();

  @Query('SELECT * FROM task_note WHERE id = :id')
  Stream<TaskNote?> findTaskNoteById(int id);

  @Query('SELECT * FROM task_note WHERE task_id = :taskId')
  Future<List<TaskNote>> findTaskNotesByTaskId(int taskId);

  @insert
  Future<int> insertTaskNote(TaskNote taskNote);

  @insert
  Future<void> insertTaskNotes(List<TaskNote> taskNote);

  @update
  Future<void> updateTaskNote(TaskNote taskNote);

  @update
  Future<void> updateTaskNotes(List<TaskNote> taskNote);

  @delete
  Future<void> deleteTaskNote(TaskNote taskNote);
}
