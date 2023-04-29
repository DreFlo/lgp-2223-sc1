// ignore_for_file: avoid_dynamic_calls

import 'package:src/env/env.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/utils/enums.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TMDBMovieAPIWrapper {
  TMDB tmdb;

  TMDBMovieAPIWrapper()
      : tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));

  Future<Map<dynamic, dynamic>> _getMovieDetails(int id) async {
    Map details = await tmdb.v3.movies.getDetails(id);

    List castNames = (await tmdb.v3.movies.getCredits(id))['cast']
        .map((cast) => cast['name'])
        .toList();

    details['participants'] = castNames.join(', ');

    return details;
  }

  Future<MediaVideoMovieSuperEntity> getMovieMediaPageInfo(
      MediaVideoMovieSuperEntity movie) async {
    Map details = await _getMovieDetails(movie.tmdbId);

    Map<String, dynamic> movieJson = {
      'id': null,
      'name': movie.name,
      'description': movie.description,
      'linkImage': movie.linkImage,
      'status': movie.status,
      'favorite': movie.favorite,
      'genres':
          details['genres'].map((genre) => genre['name']).toList().join(', '),
      'release': DateTime.parse(movie.release.toString()),
      'xp': 0,
      'tagline': details['tagline'],
      'duration': details['runtime'],
      'participants': details['participants'],
      'tmdbId': movie.tmdbId,
    };

    return MediaVideoMovieSuperEntity.fromJson(movieJson);
  }

  Future<List<MediaVideoMovieSuperEntity>>
      _getMediaVideoSuperEntitiesFromMapList(List tmdbResults) async {
    List<MediaVideoMovieSuperEntity> movies =
        List.generate(tmdbResults.length, (index) {
      Map movie = tmdbResults[index];

      Map<String, dynamic> movieJson = {
        'id': null,
        'name': movie['title'],
        'description': movie['overview'],
        'linkImage': movie['poster_path'],
        'status': Status.nothing,
        'favorite': false,
        'genres': '',
        'release': DateTime.parse(movie['release_date']),
        'xp': 0,
        'tagline': '',
        'duration': 0,
        'participants': '',
        'tmdbId': movie['id'],
      };

      return MediaVideoMovieSuperEntity.fromJson(movieJson);
    });

    return movies;
  }

  Future<List<MediaVideoMovieSuperEntity>> getTrendingMovies() async {
    List movieResults = (await tmdb.v3.trending
            .getTrending(mediaType: MediaType.movie))['results']
        .where((element) => element['poster_path'] != null)
        .toList();

    // Create a list of MediaVideoMovieSuperEntities
    List<MediaVideoMovieSuperEntity> movies =
        await _getMediaVideoSuperEntitiesFromMapList(movieResults);

    return movies;
  }

  Future<List<MediaVideoMovieSuperEntity>> getMoviesBySearch(
      String search) async {
    List movieResults = (await tmdb.v3.search.queryMovies(search))['results']
        .where((element) => element['poster_path'] != null)
        .toList();

    // Create a list of MediaVideoMovieSuperEntities
    List<MediaVideoMovieSuperEntity> movies =
        await _getMediaVideoSuperEntitiesFromMapList(movieResults);

    return movies;
  }
}
