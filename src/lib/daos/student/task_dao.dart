import 'package:floor/floor.dart';
import 'package:src/models/student/task.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM task')
  Future<List<Task>> findAllTasks();

  @Query('SELECT * FROM task WHERE id = :id')
  Stream<Task?> findTaskById(int id);

  @Query('SELECT * FROM task WHERE task_group_id IS NULL')
  Future<List<Task>> findTasksWithoutTaskGroup();
  
  @Query('SELECT * FROM task WHERE task_group_id = :taskGroupId')
  Future<List<Task>> findTasksByTaskGroupId(int taskGroupId);

  @Query('SELECT COUNT(*) FROM task WHERE task_group_id = :taskGroupId')
  Future<int?> countTasksByTaskGroupId(int taskGroupId);

  @insert
  Future<int> insertTask(Task task);

  @insert
  Future<void> insertTasks(List<Task> tasks);

  @update
  Future<void> updateTask(Task task);

  @update
  Future<void> updateTasks(List<Task> tasks);

  @delete
  Future<void> deleteTask(Task task);
}
