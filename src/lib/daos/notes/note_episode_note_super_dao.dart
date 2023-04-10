import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class NoteEpisodeNoteSuperDao {
  static final NoteEpisodeNoteSuperDao _singleton =
      NoteEpisodeNoteSuperDao._internal();

  factory NoteEpisodeNoteSuperDao() {
    return _singleton;
  }

  NoteEpisodeNoteSuperDao._internal();

  Future<int> insertNoteEpisodeNoteSuperEntity(
    NoteEpisodeNoteSuperEntity noteEpisodeNoteSuperEntity,
  ) async {
    if (noteEpisodeNoteSuperEntity.id != null) {
      throw DatabaseOperationWithId(
          "Id can't be set for insert for NoteEpisodeNoteSuperEntity");
    }

    final note = noteEpisodeNoteSuperEntity.toNote();

    int noteId = await serviceLocator<NoteDao>().insertNote(note);

    final noteEpisodeNoteSuperEntityWithId =
        noteEpisodeNoteSuperEntity.copyWith(id: noteId);

    final episodeNote = noteEpisodeNoteSuperEntityWithId.toEpisodeNote();

    await serviceLocator<EpisodeNoteDao>().insertEpisodeNote(episodeNote);

    return noteId;
  }

  Future<void> updateNoteEpisodeNoteSuperEntity(
    NoteEpisodeNoteSuperEntity noteEpisodeNoteSuperEntity,
  ) async {
    if (noteEpisodeNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update for NoteEpisodeNoteSuperEntity");
    }

    final note = noteEpisodeNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().updateNote(note);

    final episodeNote = noteEpisodeNoteSuperEntity.toEpisodeNote();

    await serviceLocator<EpisodeNoteDao>().updateEpisodeNote(episodeNote);
  }

  Future<void> deleteNoteEpisodeNoteSuperEntity(
    NoteEpisodeNoteSuperEntity noteEpisodeNoteSuperEntity,
  ) async {
    if (noteEpisodeNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete for NoteEpisodeNoteSuperEntity");
    }

    final episodeNote = noteEpisodeNoteSuperEntity.toEpisodeNote();

    await serviceLocator<EpisodeNoteDao>().deleteEpisodeNote(episodeNote);

    final note = noteEpisodeNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().deleteNote(note);
  }
}

final noteEpisodeNoteSuperDao = NoteEpisodeNoteSuperDao();