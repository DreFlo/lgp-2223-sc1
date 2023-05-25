import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/models/notes/note_task_note_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class NoteTaskNoteSuperDao {
  static final NoteTaskNoteSuperDao _singleton =
      NoteTaskNoteSuperDao._internal();

  factory NoteTaskNoteSuperDao() {
    return _singleton;
  }

  NoteTaskNoteSuperDao._internal();

  Future<int> insertNoteTaskNoteSuperEntity(
    NoteTaskNoteSuperEntity noteTaskNoteSuperEntity,
  ) async {
    final note = noteTaskNoteSuperEntity.toNote();

    int noteId = await serviceLocator<NoteDao>().insertNote(note);

    final noteTaskNoteSuperEntityWithId =
        noteTaskNoteSuperEntity.copyWith(id: noteId);

    final taskNote = noteTaskNoteSuperEntityWithId.toTaskNote();

    await serviceLocator<TaskNoteDao>().insertTaskNote(taskNote);

    return noteId;
  }

  Future<void> insertNoteTaskNoteSuperEntities(
    List<NoteTaskNoteSuperEntity> noteTaskNoteSuperEntities,
  ) async {
    for (var noteTaskNoteSuperEntity in noteTaskNoteSuperEntities) {
      await insertNoteTaskNoteSuperEntity(noteTaskNoteSuperEntity);
    }
  }

  Future<void> updateNoteTaskNoteSuperEntity(
    NoteTaskNoteSuperEntity noteTaskNoteSuperEntity,
  ) async {
    if (noteTaskNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update for NoteTaskNoteSuperEntity");
    }

    final note = noteTaskNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().updateNote(note);

    final taskNote = noteTaskNoteSuperEntity.toTaskNote();

    await serviceLocator<TaskNoteDao>().updateTaskNote(taskNote);
  }

  Future<void> deleteNoteTaskNoteSuperEntity(
    NoteTaskNoteSuperEntity noteTaskNoteSuperEntity,
  ) async {
    if (noteTaskNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete for NoteTaskNoteSuperEntity");
    }

    final note = noteTaskNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().deleteNote(note);
  }
}

final noteTaskNoteSuperDao = NoteTaskNoteSuperDao();
