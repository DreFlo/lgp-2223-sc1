import 'package:floor/floor.dart';
import 'package:src/models/student/evaluation.dart';

@dao
abstract class StudentEvaluationDao {
  @Query('SELECT * FROM evaluation')
  Future<List<StudentEvaluation>> findAllStudentEvaluations();

  @Query('SELECT * FROM evaluation WHERE id = :id')
  Stream<StudentEvaluation?> findStudentEvaluationById(int id);

  @insert
  Future<int> insertStudentEvaluation(StudentEvaluation evaluation);

  @insert
  Future<void> insertStudentEvaluations(List<StudentEvaluation> evaluations);

  @update
  Future<void> updateStudentEvaluation(StudentEvaluation evaluation);

  @update
  Future<void> updateStudentEvaluations(List<StudentEvaluation> evaluations);

  @delete
  Future<void> deleteStudentEvaluation(StudentEvaluation evaluation);
}
