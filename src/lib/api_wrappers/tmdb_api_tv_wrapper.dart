// ignore_for_file: avoid_dynamic_calls

import 'package:src/env/env.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/utils/enums.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TMDBTVSeriesAPIWrapper {
  TMDB tmdb;

  TMDBTVSeriesAPIWrapper()
      : tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));

  Future<Map<dynamic, dynamic>> _getTVSeriesDetails(int id) async {
    Map details = await tmdb.v3.tv.getDetails(id);

    List<String> castNames = (await tmdb.v3.tv.getCredits(id))['cast']
        .map((cast) => cast['name'])
        .toList();

    details['participants'] = castNames.join(', ');

    return details;
  }

  Future<Map<dynamic, dynamic>> _getTVSeasonDetails(int id, int season) async {
    Map details = await tmdb.v3.tvSeasons.getDetails(id, season);

    List<String> castNames =
        (await tmdb.v3.tvSeasons.getCredits(id, season))['cast']
            .map((cast) => cast['name'])
            .toList();

    details['participants'] = castNames.join(', ');

    return details;
  }

  Future<List<MediaSeriesSuperEntity>> _getMediaSeriesSuperEntitiesFromMapList(
      List<Map> tmdbResults) async {
    // Get details for each series
    for (int i = 0; i < tmdbResults.length; i++) {
      Map tv = tmdbResults[i];
      tmdbResults[i]['details'] = await _getTVSeriesDetails(tv['id']);
    }

    // Create a list of MediaSeriesSuperEntities
    List<MediaSeriesSuperEntity> tvSeries =
        List.generate(tmdbResults.length, (index) {
      Map tv = tmdbResults[index];

      Map<String, dynamic> tvJson = {
        'id': null,
        'name': tv['name'],
        'description': tv['overview'],
        'linkImage': tv['poster_path'],
        'status': Status.nothing,
        'favorite': false,
        'genres': tv['details']['genres']
            .map((genre) => genre['name'])
            .toList()
            .join(', '),
        'release': tv['first_air_date'],
        'xp': 0,
        'tagline': tv['details']['tagline'],
        'duration': tv['details']['episode_run_time'],
        'participants': tv['details']['participants'],
        'numberEpisodes': tv['number_of_episodes'],
        'numberSeasons': tv['number_of_seasons'],
      };

      return MediaSeriesSuperEntity.fromJson(tvJson);
    });

    return tvSeries;
  }

  Future<List<MediaSeriesSuperEntity>> getTrendingTVSeries() async {
    List<Map> tvResults =
        (await tmdb.v3.trending.getTrending(mediaType: MediaType.tv))['results']
            .where((tv) => tv['poster_path'] != null)
            .toList();

    List<MediaSeriesSuperEntity> tvSeries =
        await _getMediaSeriesSuperEntitiesFromMapList(tvResults);

    return tvSeries;
  }

  Future<List<MediaSeriesSuperEntity>> getTVSeriesBySearch(String query) async {
    List<Map> tvResults = (await tmdb.v3.search.queryTvShows(query))['results']
        .where((tv) => tv['poster_path'] != null)
        .toList();

    List<MediaSeriesSuperEntity> tvSeries =
        await _getMediaSeriesSuperEntitiesFromMapList(tvResults);

    return tvSeries;
  }
}
