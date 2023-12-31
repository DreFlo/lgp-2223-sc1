import 'package:floor/floor.dart';
import 'package:src/models/student/task_group.dart';

@dao
abstract class TaskGroupDao {
  @Query('SELECT * FROM task_group')
  Future<List<TaskGroup>> findAllTaskGroups();

  @Query('SELECT * FROM task_group WHERE id = :id')
  Stream<TaskGroup?> findTaskGroupById(int id);

  @insert
  Future<int> insertTaskGroup(TaskGroup taskGroup);

  @insert
  Future<void> insertTaskGroups(List<TaskGroup> taskGroups);

  @update
  Future<void> updateTaskGroup(TaskGroup taskGroup);

  @update
  Future<void> updateTaskGroups(List<TaskGroup> taskGroups);

  @delete
  Future<void> deleteTaskGroup(TaskGroup taskGroup);
}
