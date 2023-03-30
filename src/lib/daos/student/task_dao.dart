import 'package:floor/floor.dart';
import 'package:src/models/student/task.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM task')
  Future<List<Task>> findAllTasks();

  @Query('SELECT * FROM task WHERE id = :id')
  Stream<Task?> findTaskById(int id);

  @insert
  Future<void> insertTask(Task task);

  @insert
  Future<void> insertTasks(List<Task> tasks);

  @update
  Future<void> updateTask(Task task);

  @delete
  Future<void> deleteTask(Task task);
}
