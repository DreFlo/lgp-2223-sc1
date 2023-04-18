// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, must_be_immutable

import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'media.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/media/review.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/leisure/media_page.dart';
import 'package:src/utils/enums.dart';
import 'package:src/env/env.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/widgets/leisure/media_page_button.dart';

class ListMediaSearch extends StatelessWidget {
  final List media;
  final String title;

  Map<int, Map<dynamic, dynamic>> episodes = {};

  dynamic statusFavorite = {};
  List<Season> seasons = [];
  List<MediaVideoEpisodeSuperEntity> episodesDB = [];
  List<NoteEpisodeNoteSuperEntity> episodeNotes = [];
  Review? review;
  List<NoteBookNoteSuperEntity> bookNotes = [];

  ListMediaSearch({Key? key, required this.title, required this.media})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    // Filter out null images
    List filteredMedia =
        media.where((item) => showWidget(item) != null).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(40 * fem, 22 * fem, 0, 0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10.0 * fem,
          runSpacing: 22.0 * fem,
          children: List.generate(filteredMedia.length, (index) {
            return SizedBox(
                // Wrap GestureDetector widget with SizedBox
                width: 100.0 * fem,
                height: 150.0 * fem,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Color(0xFF22252D),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.0)),
                        ),
                        builder: (context) => DraggableScrollableSheet(
                            expand: false,
                            minChildSize: 0.35,
                            maxChildSize: 0.75,
                            builder: (context, scrollController) => Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      SingleChildScrollView(
                                          controller: scrollController,
                                          child: showMediaPageBasedOnType(
                                              filteredMedia[index])),
                                      Positioned(
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                          child: FutureBuilder<dynamic>(
                                              future: getStatusFromDB(
                                                  filteredMedia[index]),
                                              builder: ((context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                }
                                                return showMediaPageButton(
                                                    filteredMedia[index],
                                                    context);
                                              })))
                                    ])));
                  },
                  child: SizedBox(
                    width: 100.0 * fem,
                    height: 150.0 * fem,
                    child: showWidget(filteredMedia[index]),
                  ),
                ));
          }),
        ),
      ),
    );
  }

  List<String> makeCastList(Map cast) {
    List<String> castList = [];
    cast['cast'].forEach((item) {
      String name = item['name'] ?? '';
      castList.add(name);
    });
    return castList;
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

  Future<Map> getDetails(int id, String type) async {
    final tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));

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
      }

      return result;
    } else {
      return {};
    }
  }

  getStatusFromDB(dynamic item) async {
    String photo = '';
    if (title == 'All Books') {
      photo = item.info.imageLinks['thumbnail'].toString();
    } else {
      photo = item['poster_path'];
    }
    //check if media is in catalog
    final mediaExists =
        await serviceLocator<MediaDao>().countMediaByPhoto(photo);

    if (mediaExists == 0) {
      statusFavorite['status'] = Status.nothing;
      statusFavorite['favorite'] = false;
      statusFavorite['id'] = 0;
      return statusFavorite;
    }

    final media = await serviceLocator<MediaDao>().findMediaByPhoto(photo);
    if (title == 'All Books') {
      review = await loadReviews(media!.id ?? 0);
      bookNotes = await loadBookNotes(media.id ?? 0);
    } else if (title == 'All Movies') {
      review = await loadReviews(media!.id ?? 0);
    } else {
      review = await loadReviews(media!.id ?? 0);
      seasons = await loadSeasons(media.id ?? 0);
      episodesDB = await loadEpisodes(seasons);
      episodeNotes = await loadEpisodeNotes(episodesDB);
    }
    statusFavorite['status'] = media.status;
    statusFavorite['favorite'] = media.favorite;
    statusFavorite['id'] = media.id;
    return statusFavorite;
  }

  showMediaPageButton(dynamic item, context) {
    if (title == 'All Books') {
      return MediaPageButton(
          item: item,
          type: 'Book',
          mediaId: statusFavorite['id']);
    } else if (title == 'All Movies') {
      return MediaPageButton(
          item: item,
          type: 'Movie',
          mediaId: statusFavorite['id']
          );
    } else {
      return MediaPageButton(
          item: item,
          type: 'TV Show',
          mediaId: statusFavorite['id']
         );
    }
  }

  showMediaPageBasedOnType(dynamic item) {
    if (title == 'All Books') {
      List<String> leisureTags = [];
      if (item.info.maturityRating != null && item.info.maturityRating != '') {
        leisureTags.add(item.info.maturityRating);
      }
      if (item.info.categories != null && item.info.categories.length != 0) {
        leisureTags.addAll(item.info.categories);
      }
      if (item.info.publisher != null && item.info.publisher != '') {
        leisureTags.add(item.info.publisher);
      }
      if (item.info.publishedDate != null) {
        leisureTags.add(item.info.publishedDate.year.toString());
      }

      String photo = item.info.imageLinks['thumbnail'].toString();
      getStatusFromDB(item);

      return FutureBuilder<dynamic>(
          future: getStatusFromDB(item),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MediaPage(
                  title: item.info.title,
                  synopsis: item.info.description,
                  type: 'Book',
                  length: [item.info.pageCount],
                  cast: item.info.authors,
                  image: photo,
                  leisureTags: leisureTags,
                  status: statusFavorite['status'],
                  isFavorite: statusFavorite['favorite']);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          });
    } else if (title == 'All Movies') {
      return FutureBuilder<Map>(
        future: getDetails(item['id'], 'Movie'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> leisureTags = [];
            if (snapshot.data!['tagline'] != null &&
                snapshot.data!['tagline'] != '') {
              leisureTags.add(snapshot.data!['tagline']);
            }
            if (snapshot.data!['genres'] != null &&
                snapshot.data!['genres'].length != 0) {
              snapshot.data!['genres'].forEach((item) {
                leisureTags.add(item['name']);
              });
            }
            if (snapshot.data!['release_date'] != null &&
                snapshot.data!['release_date'] != '') {
              leisureTags.add(snapshot.data!['release_date'].substring(0, 4));
            }

            String photo = item['poster_path'];
            //getStatusFromDB(photo);

            return MediaPage(
              type: 'Movie',
              image: photo,
              cast: snapshot.data!['cast'],
              status: statusFavorite['status'],
              isFavorite: statusFavorite['favorite'],
              leisureTags: leisureTags,
              title: snapshot.data!['title'],
              synopsis: snapshot.data!['overview'],
              length: [snapshot.data!['runtime']],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      );
    } else if (title == 'All TV Shows') {
      return FutureBuilder<Map>(
        future: getDetails(item['id'], 'TV'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> leisureTags = [];
            if (snapshot.data!['tagline'] != null &&
                snapshot.data!['tagline'] != '') {
              leisureTags.add(snapshot.data!['tagline']);
            }
            if (snapshot.data!['genres'] != null &&
                snapshot.data!['genres'].length != 0) {
              snapshot.data!['genres'].forEach((item) {
                leisureTags.add(item['name']);
              });
            }
            if (snapshot.data!['first_air_date'] != null &&
                snapshot.data!['first_air_date'] != '') {
              leisureTags.add(snapshot.data!['first_air_date'].substring(0, 4));
            }

            String photo = item['poster_path'];
            //getStatusFromDB(photo);

            return MediaPage(
              type: 'TV Show',
              image: photo,
              cast: snapshot.data!['cast'],
              status: statusFavorite['status'],
              isFavorite: statusFavorite['favorite'],
              leisureTags: leisureTags,
              title: snapshot.data!['name'],
              synopsis: snapshot.data!['overview'],
              length: [
                snapshot.data!['number_of_seasons'],
                snapshot.data!['number_of_episodes'],
                snapshot.data!['runtime']
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      );
    }
  }

  showWidget(dynamic item) {
    if (title == 'All Books') {
      if (item.info.imageLinks['thumbnail'] != null) {
        return MediaWidget(
            image: item.info.imageLinks['thumbnail'].toString(), type: 'book');
      }
    } else {
      if (item['poster_path'] != null) {
        return MediaWidget(image: item['poster_path'], type: 'video');
      }
    }
  }
}
