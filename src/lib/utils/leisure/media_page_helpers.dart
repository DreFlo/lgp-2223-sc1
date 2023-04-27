// ignore_for_file: avoid_dynamic_calls

import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/daos/notes/note_episode_note_super_dao.dart';
import 'package:src/env/env.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/pages/leisure/media_pages/book_page.dart';
import 'package:src/pages/leisure/media_pages/movie_page.dart';
import 'package:src/pages/leisure/media_pages/tv_series_page.dart';
import 'package:src/widgets/leisure/media_image_widgets/book_image.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';
import 'package:src/widgets/leisure/media_image_widgets/movie_image.dart';
import 'package:src/widgets/leisure/media_image_widgets/tv_series_image.dart';
import 'package:src/widgets/leisure/media_page_buttons/book_page_button.dart';
import 'package:src/models/media/review.dart';
import 'package:flutter/material.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/season.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/leisure/media_page_buttons/movie_page_button.dart';
import 'package:src/widgets/leisure/media_page_buttons/tv_series_page_button.dart';
import 'package:tmdb_api/tmdb_api.dart';

bool isFavorite = false;

Future<Review?> loadReviews(int id) async {
  final reviewExists =
      await serviceLocator<ReviewDao>().countReviewsByMediaId(id);
  if (reviewExists == 0) {
    return null;
  }
  final reviewStream = serviceLocator<ReviewDao>().findReviewByMediaId(id);

  Review? firstNonNullReview =
      await reviewStream.firstWhere((review) => review != null);
  Review reviewDB = firstNonNullReview!;

  return reviewDB;
}

Future<List<NoteBookNoteSuperEntity>> loadBookNotes(int id) async {
  final noteExists =
      await serviceLocator<BookNoteDao>().countBookNoteByBookId(id);

  if (noteExists == 0) {
    return [];
  }

  List<NoteBookNoteSuperEntity> notes =
      await serviceLocator<NoteBookNoteSuperDao>().findNoteBookNoteByBookId(id);
  return notes;
}

Future<List<MediaVideoEpisodeSuperEntity>> loadEpisodes(
    List<Season> seasons) async {
  List<MediaVideoEpisodeSuperEntity> episodes = [];
  for (int i = 0; i < seasons.length; i++) {
    List<MediaVideoEpisodeSuperEntity> episode =
        await serviceLocator<MediaVideoEpisodeSuperDao>()
            .findMediaVideoEpisodeBySeasonId(seasons[i].id ?? 0);
    episodes.addAll(episode);
  }
  return episodes;
}

Future<List<Season>> loadSeasons(int id) async {
  List<Season> seasons =
      await serviceLocator<SeasonDao>().findAllSeasonBySeriesId(id);
  return seasons;
}

Future<List<NoteEpisodeNoteSuperEntity>> loadEpisodeNotes(
    List<MediaVideoEpisodeSuperEntity> episodes) async {
  List<NoteEpisodeNoteSuperEntity> notes = [];
  for (int i = 0; i < episodes.length; i++) {
    final noteExists = await serviceLocator<EpisodeNoteDao>()
        .countEpisodeNoteByEpisodeId(episodes[i].id ?? 0);

    if (noteExists == 0) {
      continue;
    }

    List<NoteEpisodeNoteSuperEntity> note =
        await serviceLocator<NoteEpisodeNoteSuperDao>()
            .findNoteEpisodeNoteByEpisodeId(episodes[i].id ?? 0);
    notes.addAll(note);
  }

  return notes;
}

void saveFavoriteStatus(bool favorite, int id) async {
  final mediaStream = serviceLocator<MediaDao>().findMediaById(id);
  Media? firstNonNullMedia =
      await mediaStream.firstWhere((media) => media != null);
  Media media = firstNonNullMedia!;
  Media newMedia = Media(
      description: media.description,
      id: media.id,
      name: media.name,
      linkImage: media.linkImage,
      favorite: favorite,
      status: media.status,
      genres: media.genres,
      release: media.release,
      xp: media.xp,
      participants: media.participants);
  await serviceLocator<MediaDao>().updateMedia(newMedia);
}

MediaImageWidget showWidget(Media item) {
  if (item is MediaBookSuperEntity) {
    return BookImageWidget(image: item.linkImage);
  } else if (item is MediaVideoMovieSuperEntity) {
    return MovieImageWidget(image: item.linkImage);
  } else {
    return TVSeriesImageWidget(image: item.linkImage);
  }
}

void toggleFavorite(bool favorite) {
  isFavorite = favorite;
}

List<String> makeCastList(Map cast) {
  List<String> castList = [];
  cast['cast'].forEach((item) {
    String name = item['name'] ?? '';
    castList.add(name);
  });
  return castList;
}

Future<Map> getDetails(int id, String type) async {
  final tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));
  final Map<int, Map<dynamic, dynamic>> episodes = {};
  final Map<int, List<dynamic>> fullEpisodes = {};

  if (type == 'Movie') {
    Map result = await tmdb.v3.movies.getDetails(id);
    Map cast = await tmdb.v3.movies.getCredits(id);
    List<String> castNames = makeCastList(cast);
    result['cast'] = castNames;
    return result;
  } else if (type == 'TV') {
    Map result = await tmdb.v3.tv.getDetails(id);
    Map cast = await tmdb.v3.tv.getCredits(id);
    List<String> castNames = makeCastList(cast);
    result['cast'] = castNames;

    // Get all episodes
    for (int season = 1; season <= result['number_of_seasons']; season++) {
      Map episodeSeason = await tmdb.v3.tvSeasons.getDetails(id, season);
      if (episodeSeason['episodes'][0]['runtime'] != null) {
        result['runtime'] = episodeSeason['episodes'][0]['runtime'];
      }
      Map episodeNumbersNames = makeEpisodeNameMap(episodeSeason);
      episodes[season] = episodeNumbersNames;
      fullEpisodes[season] = episodeSeason['episodes'];
    }
    result['episodes'] = episodes;
    result['full_episodes'] = fullEpisodes;
    return result;
  } else {
    return {};
  }
}

Map<int, String> makeEpisodeNameMap(Map episodes) {
  Map<int, String> episodeNameMap = {};
  episodes['episodes'].forEach((item) {
    String name = item['name'] ?? '';
    int episodeNumber = item['episode_number'] ?? 0;
    //to get all guest stars do makeCastList(item['guest_stars])
    episodeNameMap[episodeNumber] = name;
  });
  return episodeNameMap;
}

void showMediaPageForTV(MediaSeriesSuperEntity item, BuildContext context,
    void Function()? reload) async {
  List<String> leisureTags = [];
  leisureTags.add(item.release.year.toString());
  leisureTags.addAll(item.genres.split(','));
  leisureTags.add(item.tagline);
  isFavorite = item.favorite;
  if (context.mounted) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF22252D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            minChildSize: 0.35,
            maxChildSize: 0.9,
            builder: (context, scrollController) =>
                Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                  SingleChildScrollView(
                      controller: scrollController,
                      child: TVSeriesPage(
                        media: item,
                        leisureTags: leisureTags,
                        toggleFavorite: toggleFavorite,
                      )),
                  Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: TVSeriesPageButton(
                        item: item,
                        mediaId: item.id ?? 0,
                      ))
                ]))).whenComplete(() {
      if (isFavorite != item.favorite) {
        saveFavoriteStatus(isFavorite, item.id ?? 0);
        if (reload != null) {
          reload();
        }
      }
    });
  }
}

void showMediaPageForMovies(MediaVideoMovieSuperEntity item,
    BuildContext context, void Function()? reload) async {
  List<String> leisureTags = [];
  leisureTags.add(item.release.year.toString());
  leisureTags.addAll(item.genres.split(','));
  leisureTags.add(item.tagline);
  isFavorite = item.favorite;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF22252D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (context, scrollController) =>
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                SingleChildScrollView(
                    controller: scrollController,
                    child: MoviePage(
                      media: item,
                      leisureTags: leisureTags,
                      toggleFavorite: toggleFavorite,
                    )),
                Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: MoviePageButton(item: item, mediaId: item.id ?? 0))
              ]))).whenComplete(() {
    if (isFavorite != item.favorite) {
      saveFavoriteStatus(isFavorite, item.id ?? 0);
      if (reload != null) {
        reload();
      }
    }
  });
}

void showMediaPageForBooks(MediaBookSuperEntity item, BuildContext context,
    void Function()? reload) async {
  List<String> leisureTags = [];
  leisureTags.add(item.release.year.toString());
  leisureTags.addAll(item.genres.split(','));
  isFavorite = item.favorite;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF22252D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (context, scrollController) =>
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                SingleChildScrollView(
                    controller: scrollController,
                    child: BookPage(
                      media: item,
                      leisureTags: leisureTags,
                      toggleFavorite: toggleFavorite,
                    )),
                Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: BookPageButton(
                      item: item,
                      mediaId: item.id ?? 0,
                    ))
              ]))).whenComplete(() {
    if (isFavorite != item.favorite) {
      saveFavoriteStatus(isFavorite, item.id ?? 0);
      if (reload != null) {
        reload();
      }
    }
  });
}
