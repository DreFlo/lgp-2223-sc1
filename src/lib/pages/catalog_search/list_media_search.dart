// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/media.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/media/review.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/leisure/media_page.dart';
import 'package:src/utils/enums.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/widgets/leisure/media_page_button.dart';

class MediaStatus {
  final Status status;
  final bool favorite;
  final int id;

  MediaStatus({
    required this.status,
    required this.favorite,
    required this.id,
  });
}

class ListMediaSearch extends StatefulWidget {
  final List media;
  final String title;

  const ListMediaSearch({Key? key, required this.title, required this.media})
      : super(key: key);

  @override
  ListMediaSearchState createState() => ListMediaSearchState();
}

class ListMediaSearchState extends State<ListMediaSearch> {
  MediaStatus statusFavorite =
      MediaStatus(status: Status.nothing, favorite: false, id: 0);
  bool _isFavorite = false;
  List<Season> seasons = [];
  List<MediaVideoEpisodeSuperEntity> episodesDB = [];
  List<NoteEpisodeNoteSuperEntity> episodeNotes = [];
  Review? review;
  List<NoteBookNoteSuperEntity> bookNotes = [];

  void _toggleFavorite(bool value) {
    setState(() {
      _isFavorite = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    // Filter out null images
    List filteredMedia =
        widget.media.where((item) => showWidget(item) != null).toList();

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
                        backgroundColor: const Color(0xFF22252D),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.0)),
                        ),
                        builder: (context) => DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.75,
                            minChildSize: 0.35,
                            maxChildSize: 0.9,
                            builder: (context, scrollController) => Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      SingleChildScrollView(
                                          controller: scrollController,
                                          child: showMediaPageBasedOnType( //pass it
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
                                    ]
                                    ),
                                    )).whenComplete(() {
                                      if(_isFavorite != statusFavorite.favorite){
                                         saveFavoriteStatus(_isFavorite, statusFavorite.id);
                                      }
               

});
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

  getStatusFromDB(dynamic item) async {
    String photo = '';
    if (widget.title == 'All Books') {
      photo = item.info.imageLinks['thumbnail'].toString();
    } else {
      photo = item['poster_path'];
    }
    //check if media is in catalog
    final mediaExists =
        await serviceLocator<MediaDao>().countMediaByPhoto(photo);

    if (mediaExists == 0) {
      statusFavorite =
          MediaStatus(status: Status.nothing, favorite: false, id: 0);
      return statusFavorite;
    }

    final media = await serviceLocator<MediaDao>().findMediaByPhoto(photo);
    if (widget.title == 'All Books') {
      review = await loadReviews(media!.id ?? 0);
      bookNotes = await loadBookNotes(media.id ?? 0);
    } else if (widget.title == 'All Movies') {
      review = await loadReviews(media!.id ?? 0);
    } else {
      review = await loadReviews(media!.id ?? 0);
      seasons = await loadSeasons(media.id ?? 0);
      episodesDB = await loadEpisodes(seasons);
      episodeNotes = await loadEpisodeNotes(episodesDB);
    }

    statusFavorite = MediaStatus(
        status: media.status, favorite: media.favorite, id: media.id ?? 0);
    return statusFavorite;
  }

  showMediaPageButton(dynamic item, context) {
    if (widget.title == 'All Books') {
      return MediaPageButton(
          item: item, type: 'Book', mediaId: statusFavorite.id);
    } else if (widget.title == 'All Movies') {
      return MediaPageButton(
          item: item, type: 'Movie', mediaId: statusFavorite.id);
    } else {
      return MediaPageButton(
          item: item, type: 'TV Show', mediaId: statusFavorite.id);
    }
  }

  showMediaPageBasedOnType(dynamic item) {
    if (widget.title == 'All Books') {
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
                  status: statusFavorite.status,
                  isFavorite: statusFavorite.favorite,
                  toggleFavorite: _toggleFavorite,);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          });
    } else if (widget.title == 'All Movies') {
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
              status: statusFavorite.status,
              isFavorite: statusFavorite.favorite,
              leisureTags: leisureTags,
              title: snapshot.data!['title'],
              synopsis: snapshot.data!['overview'],
              length: [snapshot.data!['runtime']],
              toggleFavorite: _toggleFavorite,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    } else if (widget.title == 'All TV Shows') {
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
              status: statusFavorite.status,
              isFavorite: statusFavorite.favorite,
              leisureTags: leisureTags,
              title: snapshot.data!['name'],
              synopsis: snapshot.data!['overview'],
              toggleFavorite: _toggleFavorite,
              length: [
                snapshot.data!['number_of_seasons'],
                snapshot.data!['number_of_episodes'],
                snapshot.data!['runtime']
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    }
  }

  showWidget(dynamic item) {
    if (widget.title == 'All Books') {
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
