import 'package:floor/floor.dart';
import 'package:src/models/notes/episode_note.dart';

@dao
abstract class EpisodeNoteDao {
  @Query('SELECT * FROM episode_note')
  Future<List<EpisodeNote>> findAllEpisodeNotes();

  @Query('SELECT * FROM episode_note WHERE id = :id')
  Stream<EpisodeNote?> findEpisodeNoteById(int id);

  @Query('SELECT COUNT() FROM episode_note WHERE episode_id = :episodeId')
  Future<int?> countEpisodeNoteByEpisodeId(int episodeId);

  @Query('SELECT * FROM episode_note WHERE episode_id = :episodeId')
  Future<List<EpisodeNote>> findEpisodeNoteByEpisodeId(int episodeId);

  @Query('SELECT COUNT() FROM episode_note')
  Future<int?> countNotes();

  @insert
  Future<int> insertEpisodeNote(EpisodeNote episodeNote);

  @insert
  Future<void> insertEpisodeNotes(List<EpisodeNote> episodeNotes);

  @update
  Future<void> updateEpisodeNote(EpisodeNote episodeNote);

  @update
  Future<void> updateEpisodeNotes(List<EpisodeNote> episodeNotes);

  @delete
  Future<void> deleteEpisodeNote(EpisodeNote episodeNote);
}
