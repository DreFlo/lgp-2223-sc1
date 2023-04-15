import 'package:src/pages/catalog_search/media.dart';
import 'package:src/pages/leisure/media_page.dart';
import 'package:src/widgets/leisure/media_page_button.dart';
import 'package:src/models/media/review.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:flutter/material.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/models/media/review.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<int> loadDuration(int id) async {
    List<int> ids =
        await serviceLocator<EpisodeDao>().findEpisodeBySeasonId(id);
    List<int> duration = [];
    for (int i = 0; i < ids.length; i++) {
      duration = await serviceLocator<VideoDao>().findVideoDurationById(ids[i]);
    }

    int maxDuration = duration.reduce(max);

    return maxDuration;
  }

Future<Review?> loadReviews(int id) async {
    final reviewExists = await serviceLocator<ReviewDao>().countReviewsByMediaId(id);
    if (reviewExists == 0) {
      return null;
    }
    final reviewStream = serviceLocator<ReviewDao>().findReviewByMediaId(id);

    Review? firstNonNullReview =
        await reviewStream.firstWhere((review) => review != null);
    Review reviewDB = firstNonNullReview!;

    return reviewDB;
}

showWidget(dynamic item, String title) {
  if (item.linkImage != null) {
    if (title == 'All Books') {
      return Media(image: item.linkImage, type: 'book');
    } else {
      return Media(image: item.linkImage, type: 'video');
    }
  }
}

showMediaPageBasedOnType(dynamic item, String title, int duration) {
  List<String> leisureTags = [];

  leisureTags.add(item.release.year.toString());
  leisureTags.addAll(item.genres.split(','));

  List<String> cast = [];
  cast.addAll(item.participants.split(', '));

  if (title == 'All Books') {
    return MediaPage(
      title: item.name,
      synopsis: item.description,
      type: 'Book',
      length: [item.totalPages],
      cast: cast,
      image: item.linkImage,
      status: item.status,
      isFavorite: item.favorite,
      leisureTags: leisureTags,
    );
  } else if (title == 'All Movies') {
    leisureTags.add(item.tagline);

    return MediaPage(
      title: item.name,
      synopsis: item.description,
      type: 'Movie',
      length: [item.duration],
      cast: cast,
      image: item.linkImage,
      status: item.status,
      isFavorite: item.favorite,
      leisureTags: leisureTags,
    );
  } else if (title == 'All TV Shows') {
    leisureTags.add(item.tagline);

    return MediaPage(
      title: item.name,
      synopsis: item.description,
      type: 'TV Show',
      length: [item.numberSeasons, item.numberEpisodes, duration], //get from DB
      cast: cast,
      image: item.linkImage,
      status: item.status,
      isFavorite: item.favorite,
      leisureTags: leisureTags,
    );
  }
}

showMediaPageButton(dynamic item, String title, Review? review) {
  if (title == 'All Books') {
    return MediaPageButton(item: item, type:'Book'); 
  } else if (title == 'All Movies') {
    return MediaPageButton(item: item, type:'Movie', review:review); 
  } else {
    return MediaPageButton(item: item, type:'TV Show'); 
  }
}

showMediaPageForTV(dynamic item, context) async {
int maxDuration = await loadDuration(
                                          item.id);
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              const Color(0xFF22252D),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30.0)),
                                          ),
                                          builder: (context) =>
                                              DraggableScrollableSheet(
                                                  expand: false,
                                                  minChildSize: 0.35,
                                                  maxChildSize: 0.75,
                                                  builder: (context,
                                                          scrollController) =>
                                                      Stack(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          children: [
                                                            SingleChildScrollView(
                                                                controller:
                                                                    scrollController,
                                                                child: showMediaPageBasedOnType(
                                                                    item,
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .all_tv_shows,
                                                                    maxDuration)),
                                                            /*Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: mediaPageButton())*/
                                                          ])));
}

showMediaPageForMovies(dynamic item, context) async{
  Review? review = await loadReviews(
                                          item.id);
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              const Color(0xFF22252D),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30.0)),
                                          ),
                                          builder: (context) =>
                                              DraggableScrollableSheet(
                                                  expand: false,
                                                  minChildSize: 0.35,
                                                  maxChildSize: 0.75,
                                                  builder: (context,
                                                          scrollController) =>
                                                      Stack(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          children: [
                                                            SingleChildScrollView(
                                                                controller:
                                                                    scrollController,
                                                                child: showMediaPageBasedOnType(
                                                                    item,
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .all_movies,
                                                                    0)),
                                                            Positioned(
                                                                left: 16,
                                                                right: 16,
                                                                bottom: 16,
                                                                child: MediaPageButton(item: item, type:'Movie', review:review))
                                                          ])));
}

showMediaPageForBooks(dynamic item){

}
