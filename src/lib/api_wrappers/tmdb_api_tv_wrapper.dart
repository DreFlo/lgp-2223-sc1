// ignore_for_file: avoid_dynamic_calls

import 'package:src/env/env.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/utils/enums.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TMDBTVSeriesAPIWrapper {
  TMDB tmdb;

  TMDBTVSeriesAPIWrapper()
      : tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));

  Future<Map<dynamic, dynamic>> _getTVSeriesDetails(int id) async {
    Map details = await tmdb.v3.tv.getDetails(id);

    List castNames = (await tmdb.v3.tv.getCredits(id))['cast']
        .map((cast) => cast['name'])
        .toList();

    details['participants'] = castNames.join(', ');

    return details;
  }

  Future<Map<dynamic, dynamic>> _getTVSeasonDetails(int id, int season) async {
    Map details = await tmdb.v3.tvSeasons.getDetails(id, season);

    List castNames = (await tmdb.v3.tvSeasons.getCredits(id, season))['cast']
        .map((cast) => cast['name'])
        .toList();

    details['participants'] = castNames.join(', ');

    return details;
  }

  Future<MediaSeriesSuperEntity> getSeriesMediaPageInfo(MediaSeriesSuperEntity series) async {
    Map details = await _getTVSeriesDetails(series.tmdbId);
    Map episodeDetails = await tmdb.v3.tvSeasons.getDetails(series.tmdbId, 1);
    details['episode_run_time'] = episodeDetails['episodes'][0]['runtime'];

    Map<String, dynamic> seriesJson = {
        'id': null,
        'name': series.name,
        'description': series.description,
        'linkImage': series.linkImage,
        'status': series.status,
        'favorite': series.favorite,
        'genres': details['genres']
            .map((genre) => genre['name'])
            .toList()
            .join(', '),
        'release': DateTime.parse(series.release.toString()),
        'xp': 0,
        'tagline': details['tagline'],
        'duration': details['episode_run_time'] ??0,
        'participants': details['participants'],
        'numberEpisodes': details['number_of_episodes'],
        'numberSeasons': details['number_of_seasons'],
        'tmdbId': series.tmdbId,
      };

      return MediaSeriesSuperEntity.fromJson(seriesJson);
  }

  Future<List<MediaSeriesSuperEntity>> _getMediaSeriesSuperEntitiesFromMapList(
      List tmdbResults) async {
    // Get details for each series
    //for (int i = 0; i < tmdbResults.length; i++) {
    //  Map tv = tmdbResults[i];
    //  tmdbResults[i]['details'] = await _getTVSeriesDetails(tv['id']);
    //  Map details = await tmdb.v3.tvSeasons.getDetails(tv['id'], 1);
    //  tmdbResults[i]['details']['episode_run_time'] =
    //      details['episodes'][0]['runtime'];
    //}

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
        /*'genres': tv['details']['genres']
            .map((genre) => genre['name'])
            .toList()
            .join(', '),*/
        'genres': '',
        'release': DateTime.parse(tv['first_air_date']),
        'xp': 0,
        'duration': 0,
        /*'tagline': tv['details']['tagline'],
        'duration': tv['details']['episode_run_time'] ??
            tv['details']['episode_run_time'] ??
            0,*/
        'tagline': '',
        /*'participants': tv['details']['participants'],
        'numberEpisodes': tv['details']['number_of_episodes'],
        'numberSeasons': tv['details']['number_of_seasons'],*/
        'participants': '',
        'numberEpisodes': 0,
        'numberSeasons': 0,
        'tmdbId': tv['id'],
      };

      return MediaSeriesSuperEntity.fromJson(tvJson);
    });

    return tvSeries;
  }

  Future<List<MediaSeriesSuperEntity>> getTrendingTVSeries() async {
    List tvResults =
        (await tmdb.v3.trending.getTrending(mediaType: MediaType.tv))['results']
            .where((tv) => tv['poster_path'] != null)
            .toList();

    List<MediaSeriesSuperEntity> tvSeries =
        await _getMediaSeriesSuperEntitiesFromMapList(tvResults);

    return tvSeries;
  }

  Future<List<MediaSeriesSuperEntity>> getTVSeriesBySearch(String query) async {
    List tvResults = (await tmdb.v3.search.queryTvShows(query))['results']
        .where((tv) => tv['poster_path'] != null)
        .toList();

    List<MediaSeriesSuperEntity> tvSeries =
        await _getMediaSeriesSuperEntitiesFromMapList(tvResults);

    return tvSeries;
  }

  Future<List<MediaVideoEpisodeSuperEntity>> getSeasonEpisodes(
      int id, int season) async {
    Map seasonDetails = await _getTVSeasonDetails(id, season);

    List<MediaVideoEpisodeSuperEntity> episodes =
        List.generate(seasonDetails['episodes'].length, (index) {
      Map episode = seasonDetails['episodes'][index];

      Map<String, dynamic> episodeJson = {
        'id': null,
        'name': episode['name'],
        'description': episode['overview'],
        'linkImage': episode['still_path'],
        'status': Status.nothing,
        'favorite': false,
        'genres': 'genres',
        'release': DateTime.parse(episode['air_date']),
        'xp': 0,
        'tagline': episode['tagline'],
        'duration': episode['runtime'],
        'participants': 'participants',
        'seasonId': season,
        'number': episode['episode_number'],
        'tmdbId': episode['id'],
      };

      return MediaVideoEpisodeSuperEntity.fromJson(episodeJson);
    });

    return episodes;
  }
}
