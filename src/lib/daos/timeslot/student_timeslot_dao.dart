import 'package:floor/floor.dart';
import 'package:src/models/timeslot/student_timeslot.dart';

@dao
abstract class StudentTimeslotDao {
  @Query('SELECT * FROM student_timeslot')
  Future<List<StudentTimeslot>> findAllStudentTimeslots();

  @Query('SELECT * FROM student_timeslot WHERE id = :id')
  Future<StudentTimeslot?> findStudentTimeslotById(int id);
  @Query('SELECT * FROM student_timeslot WHERE task_id = :taskId')
  Future<List<StudentTimeslot>> findStudentTimeslotsByTaskId(int taskId);

  @Query(
      'SELECT * FROM student_timeslot WHERE task_id = :taskId AND timeslot_id = :timeslotId')
  Future<StudentTimeslot?> findStudentTimeslotByTaskIdAndTimeslotId(
      int taskId, int timeslotId);

  @Query('SELECT * FROM student_timeslot WHERE timeslot_id = :timeslotId')
  Future<List<StudentTimeslot>> findStudentTimeslotsByTimeslotId(
      int timeslotId);

  @insert
  Future<void> insertStudentTimeslot(StudentTimeslot studentTimeslot);

  @update
  Future<void> updateStudentTimeslot(StudentTimeslot studentTimeslot);

  @delete
  Future<void> deleteStudentTimeslot(StudentTimeslot studentTimeslot);
  
  @insert
  Future<void> insertStudentTimeslots(List<StudentTimeslot> studentTimeslots);

  @update
  Future<void> updateStudentTimeslots(List<StudentTimeslot> studentTimeslots);

}
