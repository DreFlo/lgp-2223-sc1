import 'package:flutter/material.dart';
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

// List<String> leisureTags = [];
//             if (snapshot.data!['tagline'] != null &&
//                 snapshot.data!['tagline'] != '') {
//               leisureTags.add(snapshot.data!['tagline']);
//             }
//             if (snapshot.data!['genres'] != null &&
//                 snapshot.data!['genres'].length != 0) {
//               snapshot.data!['genres'].forEach((item) {
//                 leisureTags.add(item['name']);
//               });
//             }
//             if (snapshot.data!['first_air_date'] != null &&
//                 snapshot.data!['first_air_date'] != '') {
//               leisureTags.add(snapshot.data!['first_air_date'].substring(0, 4));
//             }

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

  @override
  TVSeriesPage showMediaPageBasedOnType(
      MediaSeriesSuperEntity item, List<String> leisureTags) {
    return TVSeriesPage(
        media: item, toggleFavorite: toggleFavorite, leisureTags: leisureTags);
  }

  @override
  TVSeriesImageWidget showWidget(MediaSeriesSuperEntity item) {
    return TVSeriesImageWidget(image: item.linkImage);
  }

  @override
  Future<MediaStatus> getMediaInfoFromDB(MediaSeriesSuperEntity item) async {
    String photo = item.linkImage;

    final mediaExists =
        await serviceLocator<MediaDao>().countMediaByPhoto(photo);

    if (mediaExists == 0) {
      statusFavorite =
          MediaStatus(status: Status.nothing, favorite: false, id: 0);
      return statusFavorite;
    }

    final media = await serviceLocator<MediaDao>().findMediaByPhoto(photo);
    review = await loadReviews(media!.id ?? 0);
    seasons = await loadSeasons(media.id ?? 0);
    episodesDB = await loadEpisodes(seasons);
    episodeNotes = await loadEpisodeNotes(episodesDB);

    statusFavorite = MediaStatus(
        status: media.status, favorite: media.favorite, id: media.id ?? 0);
    return statusFavorite;
  }

  @override
  TVSeriesPageButton showMediaPageButton(MediaSeriesSuperEntity item) {
    return TVSeriesPageButton(
      item: item,
      mediaId: statusFavorite.id,
    );
  }
}
