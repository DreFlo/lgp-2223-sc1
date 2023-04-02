import 'package:floor/floor.dart';
import 'package:src/models/media/episode.dart';

@dao
abstract class EpisodeDao {
  @Query('SELECT * FROM episode')
  Future<List<Episode>> findAllEpisode();

  @Query('SELECT * FROM episode WHERE id = :id')
  Stream<Episode?> findEpisodeById(int id);

  @insert
  Future<void> insertEpisode(Episode episode);

  @insert
  Future<void> insertEpisodes(List<Episode> episodes);

  @update
  Future<void> updateEpisode(Episode episode);

  @update
  Future<void> updateEpisodes(List<Episode> episodes);

  @delete
  Future<void> deleteEpisode(Episode episode);
}
