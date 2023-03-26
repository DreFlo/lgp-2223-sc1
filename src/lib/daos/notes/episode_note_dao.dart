import 'package:floor/floor.dart';
import 'package:src/models/notes/episode_note.dart';

@dao
abstract class EpisodeNoteDao {
  @Query('SELECT * FROM episode_note')
  Future<List<EpisodeNote>> findAllEpisodeNotes();

  @Query('SELECT * FROM episode_note WHERE id = :id')
  Stream<EpisodeNote?> findEpisodeNoteById(int id);

  @insert
  Future<void> insertEpisodeNote(EpisodeNote episodeNote);

  @insert
  Future<void> insertEpisodeNotes(List<EpisodeNote> episodeNotes);
}
