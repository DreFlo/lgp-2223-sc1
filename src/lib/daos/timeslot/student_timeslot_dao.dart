import 'package:floor/floor.dart';
import 'package:src/models/timeslot/student_timeslot.dart';

@dao
abstract class StudentTimeslotDao {
  @Query('SELECT * FROM student_timeslot')
  Future<List<StudentTimeslot>> findAllStudentTimeslots();

  @Query('SELECT * FROM student_timeslot WHERE id = :id')
  Future<StudentTimeslot?> findStudentTimeslotById(int id);

  @insert
  Future<int> insertStudentTimeslot(StudentTimeslot studentTimeslot);

  @insert
  Future<void> insertStudentTimeslots(List<StudentTimeslot> studentTimeslots);

  @update
  Future<void> updateStudentTimeslot(StudentTimeslot studentTimeslot);

  @update
  Future<void> updateStudentTimeslots(List<StudentTimeslot> studentTimeslots);

  @delete
  Future<void> deleteStudentTimeslot(StudentTimeslot studentTimeslot);
}
