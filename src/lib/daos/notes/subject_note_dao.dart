import 'package:floor/floor.dart';
import 'package:src/models/notes/subject_note.dart';

@dao
abstract class SubjectNoteDao {
  @Query('SELECT * FROM subject_note')
  Future<List<SubjectNote>> findAllSubjectNotes();

  @Query('SELECT * FROM subject_note WHERE id = :id')
  Stream<SubjectNote?> findSubjectNoteById(int id);

  @insert
  Future<void> insertSubjectNote(SubjectNote subjectNote);

  @insert
  Future<void> insertSubjectNotes(List<SubjectNote> subjectNotes);

  @update
  Future<void> updateSubjectNote(SubjectNote subjectNote);

  @update
  Future<void> updateSubjectNotes(List<SubjectNote> subjectNotes);

  @delete
  Future<void> deleteSubjectNote(SubjectNote subjectNote);
}
