import 'package:flutter/material.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/pages/catalog_search/list_media_search/list_media_search.dart';
import 'package:src/pages/leisure/media_pages/movie_page.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';
import 'package:src/widgets/leisure/media_image_widgets/movie_image.dart';
import 'package:src/widgets/leisure/media_page_buttons/movie_page_button.dart';

class ListMoviesSearch extends ListMediaSearch<MediaVideoMovieSuperEntity> {
  const ListMoviesSearch(
      {Key? key, required List<MediaVideoMovieSuperEntity> media})
      : super(key: key, media: media);

  @override
  ListMoviesSearchState createState() => ListMoviesSearchState();
}

class ListMoviesSearchState
    extends ListMediaSearchState<MediaVideoMovieSuperEntity> {
  @override
  MoviePage showMediaPageBasedOnType(
      MediaVideoMovieSuperEntity item, List<String> leisureTags) {
    return MoviePage(
        media: item,
        toggleFavorite: super.toggleFavorite,
        leisureTags: leisureTags);
  }

  @override
  MediaImageWidget<MediaVideoMovieSuperEntity> showWidget(
      MediaVideoMovieSuperEntity item) {
    return MovieImageWidget(image: item.linkImage);
  }

  @override
  Future<MediaStatus> getMediaInfoFromDB(
      MediaVideoMovieSuperEntity item) async {
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

    statusFavorite = MediaStatus(
        status: media.status, favorite: media.favorite, id: media.id ?? 0);
    return statusFavorite;
  }

  @override
  MoviePageButton showMediaPageButton(MediaVideoMovieSuperEntity item) {
    return MoviePageButton(item: item, mediaId: statusFavorite.id);
  }
}
