import 'package:floor/floor.dart';
import 'package:src/models/timeslot/task_student_timeslot.dart';
import 'package:src/models/timeslot/student_timeslot.dart';
import 'package:src/models/student/task.dart';

@dao
abstract class TaskStudentTimeslotDao {
  @Query('SELECT * FROM task_student_timeslot')
  Future<List<TaskStudentTimeslot>> findAllTaskStudentTimeslots();

  @Query('SELECT * FROM task_student_timeslot WHERE task_id = :id')
  Future<List<TaskStudentTimeslot>> findTaskStudentTimeslotByTaskId(int id);

  @Query('SELECT * FROM task_student_timeslot WHERE student_timeslot_id = :id')
  Future<List<TaskStudentTimeslot>> findTaskStudentTimeslotByStudentTimeslotId(
      int id);

  @insert
  Future<void> insertTaskStudentTimeslot(
      TaskStudentTimeslot taskStudentTimeslot);

  @insert
  Future<void> insertTaskStudentTimeslots(
      List<TaskStudentTimeslot> taskStudentTimeslots);

  @update
  Future<void> updateTaskStudentTimeslot(
      TaskStudentTimeslot taskStudentTimeslot);

  @delete
  Future<void> deleteTaskStudentTimeslot(
      TaskStudentTimeslot taskStudentTimeslot);

  @Query('''DELETE FROM task_student_timeslot 
          WHERE student_timeslot_id = :id''')
  Future<void> deleteTaskStudentTimeslotByStudentTimeslotId(int id);

  @Query('''SELECT T.* 
          FROM task_student_timeslot TT JOIN task T ON TT.task_id = T.id 
          WHERE TT.student_timeslot_id = :id''')
  Future<List<Task>> findTaskByStudentTimeslotId(int id);

  @Query('''SELECT T.* 
          FROM task_student_timeslot TT JOIN student_timeslot T ON TT.student_timeslot_id = T.id 
          WHERE TT.task_id = :id''')
  Future<List<StudentTimeslot>> findStudentTimeslotByTaskId(int id);
}
