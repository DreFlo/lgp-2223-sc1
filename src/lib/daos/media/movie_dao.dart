import 'package:floor/floor.dart';
import 'package:src/models/media/movie.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM movie')
  Future<List<Movie>> findAllMovie();

  @Query('SELECT * FROM movie WHERE id = :id')
  Stream<Movie?> findMovieById(int id);

  @insert
  Future<void> insertMovie(Movie movie);

  @insert
  Future<void> insertMovies(List<Movie> movie);
}