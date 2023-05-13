import 'package:flutter/material.dart';
import 'package:src/api_wrappers/tmdb_api_tv_wrapper.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/pages/catalog_search/list_media_search/list_media_search.dart';
import 'package:src/pages/leisure/media_pages/tv_series_page.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/leisure/media_image_widgets/tv_series_image.dart';
import 'package:src/widgets/leisure/media_page_buttons/tv_series_page_button.dart';

class ListTVSeriesSearch extends ListMediaSearch<MediaSeriesSuperEntity> {
  const ListTVSeriesSearch(
      {Key? key, required List<MediaSeriesSuperEntity> media})
      : super(key: key, media: media);

  @override
  ListTVSeriesSearchState createState() => ListTVSeriesSearchState();
}

class ListTVSeriesSearchState
    extends ListMediaSearchState<MediaSeriesSuperEntity> {
  List<Season> seasons = [];
  List<MediaVideoEpisodeSuperEntity> episodesDB = [];
  List<NoteEpisodeNoteSuperEntity> episodeNotes = [];
  MediaSeriesSuperEntity? media;

  Future<MediaSeriesSuperEntity> loadSeriesDetails(
      MediaSeriesSuperEntity series) async {
    final TMDBTVSeriesAPIWrapper tmdb = TMDBTVSeriesAPIWrapper();
    return await tmdb.getSeriesMediaPageInfo(series);
  }

  @override
  Widget showMediaPageBasedOnType(MediaSeriesSuperEntity item) {
    return FutureBuilder<MediaSeriesSuperEntity>(
      future: (media != null && media!.name == item.name)
          ? Future.value(media)
          : loadSeriesDetails(item),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TVSeriesPage(
              media: snapshot.data!, toggleFavorite: super.toggleFavorite);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  TVSeriesImageWidget showWidget(MediaSeriesSuperEntity item) {
    return TVSeriesImageWidget(image: item.linkImage);
  }

  @override
  Future<MediaStatus> getMediaInfoFromDB(MediaSeriesSuperEntity item) async {
    media = await loadSeriesDetails(item);
    String photo = item.linkImage;

    final mediaExists =
        await serviceLocator<MediaDao>().countMediaByPhoto(photo);

    if (mediaExists == 0) {
      statusFavorite =
          MediaStatus(status: Status.nothing, favorite: false, id: 0);
      return statusFavorite;
    }

    final mediaByPhoto = await serviceLocator<MediaDao>().findMediaByPhoto(photo);
    review = await loadReviews(mediaByPhoto!.id ?? 0);
    seasons = await loadSeasons(mediaByPhoto.id ?? 0);
    episodesDB = await loadEpisodes(seasons);
    episodeNotes = await loadEpisodeNotes(episodesDB);

    statusFavorite = MediaStatus(
        status: mediaByPhoto.status, favorite: mediaByPhoto.favorite, id: mediaByPhoto.id ?? 0);
    return statusFavorite;
  }

  @override
  TVSeriesPageButton showMediaPageButton(MediaSeriesSuperEntity item) {
    return TVSeriesPageButton(
      item: media ?? item,
      mediaId: statusFavorite.id,
    );
  }
}
