import 'package:flutter/material.dart';
import 'package:src/api_wrappers/tmdb_api_tv_wrapper.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/pages/leisure/add_media_to_catalog_forms/add_media_to_catalog_form.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';

class AddTVSeriesToCatalogForm
    extends AddMediaToCatalogForm<MediaSeriesSuperEntity> {
  const AddTVSeriesToCatalogForm(
      {Key? key,
      required String startDate,
      required String endDate,
      required Status status,
      required MediaSeriesSuperEntity item,
      required void Function(int) setMediaId,
      required Future Function() showReviewForm,
      required VoidCallback? refreshStatus})
      : super(
            key: key,
            startDate: startDate,
            endDate: endDate,
            status: status,
            item: item,
            setMediaId: setMediaId,
            showReviewForm: showReviewForm,
            refreshStatus: refreshStatus);

  @override
  AddMovieToCatalogFormState createState() => AddMovieToCatalogFormState();
}

class AddMovieToCatalogFormState
    extends AddMediaToCatalogFormState<MediaSeriesSuperEntity> {
  @override
  Future<int> storeMediaInDatabase(Status status) async {
    int seriesId = await serviceLocator<MediaSeriesSuperDao>()
        .insertMediaSeriesSuperEntity(widget.item.copyWith(status: status));

    Map<int, int> seasonIdMap = {};

    for (int seasonNumber = 1;
        seasonNumber <= widget.item.numberSeasons;
        seasonNumber++) {
      seasonIdMap[seasonNumber] = await serviceLocator<SeasonDao>()
          .insertSeason(Season(number: seasonNumber, seriesId: seriesId));
    }

    final TMDBTVSeriesAPIWrapper tmdbTVSeriesAPIWrapper =
        TMDBTVSeriesAPIWrapper();

    for (int seasonNumber = 1;
        seasonNumber <= widget.item.numberSeasons;
        seasonNumber++) {
      List<MediaVideoEpisodeSuperEntity> episodes = await tmdbTVSeriesAPIWrapper
          .getSeasonEpisodes(widget.item.tmdbId, seasonNumber);

      for (MediaVideoEpisodeSuperEntity episode in episodes) {
        MediaVideoEpisodeSuperEntity insertedEpisode =
            episode.copyWith(seasonId: seasonIdMap[seasonNumber]);
        await serviceLocator<MediaVideoEpisodeSuperDao>()
            .insertMediaVideoEpisodeSuperEntity(
                insertedEpisode.copyWith(status: status));
      }
    }

    return seriesId;
  }
}
