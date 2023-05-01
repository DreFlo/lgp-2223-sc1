import 'package:floor/floor.dart';
import 'package:src/models/media/season.dart';

@dao
abstract class SeasonDao {
  @Query('SELECT * FROM season')
  Future<List<Season>> findAllSeason();

  @Query('SELECT * FROM season WHERE id = :id')
  Stream<Season?> findSeasonById(int id);

  @Query('SELECT * FROM season WHERE series_id = :id')
  Future<List<Season>> findAllSeasonBySeriesId(int id);

  @insert
  Future<int> insertSeason(Season season);

  @insert
  Future<void> insertSeasons(List<Season> season);

  @update
  Future<void> updateSeason(Season season);

  @update
  Future<void> updateSeasons(List<Season> season);

  @delete
  Future<void> deleteSeason(Season season);
}
