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

  @Query('SELECT COUNT(*) FROM task WHERE finished = :finished')
  Future<int?> countFinishedTasks(bool finished);

  @Query('SELECT COUNT(*) FROM task')
  Future<int?> countTasks();

  @Query(
      'SELECT COUNT(DISTINCT task_group_id) FROM task WHERE finished = :finished')
  Future<int?> countFinishedTaskGroups(bool finished);

  @Query('SELECT finished FROM task WHERE id = :id')
  Future<bool?> isTaskFinished(int id);

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

  @Query('''SELECT * FROM task 
            WHERE deadline >= cast((julianday('now') - 2440587.5) * 86400 * 1000 as integer)''')
  Future<List<Task>> findTasksActivities();
}
