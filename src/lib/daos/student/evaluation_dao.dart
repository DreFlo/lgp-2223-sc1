import 'package:floor/floor.dart';
import 'package:src/models/student/evaluation.dart';

@dao
abstract class EvaluationDao {
  @Query('SELECT * FROM evaluation')
  Future<List<Evaluation>> findAllEvaluations();

  @Query('SELECT * FROM evaluation WHERE id = :id')
  Stream<Evaluation?> findEvaluationById(int id);

  @insert
  Future<void> insertEvaluation(Evaluation evaluation);

  @insert
  Future<void> insertEvaluations(List<Evaluation> evaluations);
}
