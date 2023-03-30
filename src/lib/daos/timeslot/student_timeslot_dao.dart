import 'package:floor/floor.dart';
import 'package:src/models/timeslot/student_timeslot.dart';

@dao
abstract class StudentTimeslotDao {
  @Query('SELECT * FROM student_timeslot')
  Future<List<StudentTimeslot>> findAllStudentTimeslot();

  @Query('SELECT * FROM student_timeslot WHERE id = :id')
  Future<StudentTimeslot?> findStudentTimeslotById(int id);

  @insert
  Future<void> insertStudentTimeslot(StudentTimeslot studentTimeslot);

  @update
  Future<void> updateStudentTimeslot(StudentTimeslot studentTimeslot);

  @delete
  Future<void> deleteStudentTimeslot(StudentTimeslot studentTimeslot);
}
