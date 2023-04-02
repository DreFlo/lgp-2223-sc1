// import 'package:floor/floor.dart';
// import 'package:src/models/media/movie.dart';
//
// @dao
// abstract class MovieDao {
//   @Query('SELECT * FROM movie')
//   Future<List<Movie>> findAllMovie();
//
//   @Query('SELECT * FROM movie WHERE id = :id')
//   Stream<Movie?> findMovieById(int id);
//
//   @insert
//   Future<int> insertMovie(Movie movie);
//
//   @insert
//   Future<void> insertMovies(List<Movie> movie);
//
//   @update
//   Future<void> updateMovie(Movie movie);
//
//   @update
//   Future<void> updateMovies(List<Movie> movie);
//
//   @delete
//   Future<void> deleteMovie(Movie movie);
// }
