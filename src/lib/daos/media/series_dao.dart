import 'package:floor/floor.dart';
import 'package:src/models/media/series.dart';

@dao
abstract class SeriesDao {
  @Query('SELECT * FROM series')
  Future<List<Series>> findAllSeries();

  @Query('SELECT * FROM series WHERE id = :id')
  Stream<Series?> findSeriesById(int id);

  @Query('SELECT COUNT() FROM series WHERE id = :id')
  Future<int?> countSeriesByMediaId(int id);

  @insert
  Future<int> insertSerie(Series series);

  @insert
  Future<void> insertSeries(List<Series> series);

  @update
  Future<void> updateSerie(Series series);

  @update
  Future<void> updateSeries(List<Series> series);

  @delete
  Future<void> deleteSerie(Series series);
}
