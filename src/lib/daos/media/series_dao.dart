import 'package:floor/floor.dart';
import 'package:src/models/media/series.dart';

@dao
abstract class SeriesDao {
  @Query('SELECT * FROM series')
  Future<List<Series>> findAllSeries();

  @Query('SELECT * FROM series WHERE id = :id')
  Stream<Series?> findSeriesById(int id);

  @insert
  Future<void> insertSerie(Series series);

  @insert
  Future<void> insertSeries(List<Series> series);
}