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
}
