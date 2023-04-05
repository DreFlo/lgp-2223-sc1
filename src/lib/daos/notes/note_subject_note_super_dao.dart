import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/subject_note_dao.dart';
import 'package:src/models/notes/note_subject_note_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class NoteSubjectNoteSuperDao {
  static final NoteSubjectNoteSuperDao _singleton =
      NoteSubjectNoteSuperDao._internal();

  factory NoteSubjectNoteSuperDao() {
    return _singleton;
  }

  NoteSubjectNoteSuperDao._internal();

  Future<int> insertNoteSubjectNoteSuperEntity(
    NoteSubjectNoteSuperEntity noteSubjectNoteSuperEntity,
  ) async {
    if (noteSubjectNoteSuperEntity.id != null) {
      throw DatabaseOperationWithId(
          "Id can't be set for insert for NoteSubjectNoteSuperEntity");
    }

    final note = noteSubjectNoteSuperEntity.toNote();

    int noteId = await serviceLocator<NoteDao>().insertNote(note);

    final noteSubjectNoteSuperEntityWithId =
        noteSubjectNoteSuperEntity.copyWith(id: noteId);

    final subjectNote = noteSubjectNoteSuperEntityWithId.toSubjectNote();

    await serviceLocator<SubjectNoteDao>().insertSubjectNote(subjectNote);

    return noteId;
  }

  Future<void> updateNoteSubjectNoteSuperEntity(
    NoteSubjectNoteSuperEntity noteSubjectNoteSuperEntity,
  ) async {
    if (noteSubjectNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update for NoteSubjectNoteSuperEntity");
    }

    final note = noteSubjectNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().updateNote(note);

    final subjectNote = noteSubjectNoteSuperEntity.toSubjectNote();

    await serviceLocator<SubjectNoteDao>().updateSubjectNote(subjectNote);
  }

  Future<void> deleteNoteSubjectNoteSuperEntity(
    NoteSubjectNoteSuperEntity noteSubjectNoteSuperEntity,
  ) async {
    if (noteSubjectNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete for NoteSubjectNoteSuperEntity");
    }

    final subjectNote = noteSubjectNoteSuperEntity.toSubjectNote();

    await serviceLocator<SubjectNoteDao>().deleteSubjectNote(subjectNote);

    final note = noteSubjectNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().deleteNote(note);
  }
}

final noteSubjectNoteSuperDao = NoteSubjectNoteSuperDao();
