import 'package:floor/floor.dart';
import 'package:src/models/student/subject.dart';

@dao
abstract class SubjectDao {
  @Query('SELECT * FROM subject')
  Future<List<Subject>> findAllSubjects();

  @Query('SELECT * FROM subject WHERE id = :id')
  Stream<Subject?> findSubjectById(int id);

  @Query('SELECT * FROM subject WHERE institution_id = :id')
  Stream<Subject?> findSubjectByInstitutionId(int id);

  @insert
  Future<void> insertSubject(Subject subject);

  @insert
  Future<void> insertSubjects(List<Subject> subjects);
}
