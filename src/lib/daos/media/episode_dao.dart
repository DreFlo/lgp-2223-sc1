import 'package:floor/floor.dart';
import 'package:src/models/media/episode.dart';

@dao
abstract class EpisodeDao {
  @Query('SELECT * FROM episode')
  Future<List<Episode>> findAllEpisode();

  @Query('SELECT * FROM episode WHERE id = :id')
  Stream<Episode?> findEpisodeById(int id);

  @Query('SELECT id FROM episode WHERE season_id = :id')
  Future<List<int>> findEpisodeBySeasonId(int id);

  @Query('SELECT * FROM episode WHERE season_id = :id')
  Future<List<Episode>> findAllEpisodesBySeasonId(int id);

  @insert
  Future<int> insertEpisode(Episode episode);

  @insert
  Future<void> insertEpisodes(List<Episode> episodes);

  @update
  Future<void> updateEpisode(Episode episode);

  @update
  Future<void> updateEpisodes(List<Episode> episodes);

  @delete
  Future<void> deleteEpisode(Episode episode);
}
