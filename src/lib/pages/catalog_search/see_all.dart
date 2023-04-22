import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/search_bar.dart';
import 'package:src/pages/catalog_search/list_media_catalog.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/models/media/media.dart';

class SeeAll extends StatefulWidget {
  final List media;
  final String title;
  final VoidCallback? refreshMediaList;

  const SeeAll(
      {Key? key,
      required this.title,
      required this.media,
      this.refreshMediaList})
      : super(key: key);

  @override
  SeeAllState createState() => SeeAllState();
}

class SeeAllState extends State<SeeAll> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String searchText = '';
  void onSearch(String text) {
    setState(() {
      searchText = text;
    });
  }

  Future<List> searchMediaBasedOnType() async {
    String query = '%$searchText%';
    final resultsToReturn = [];
    final results = await serviceLocator<MediaDao>().getMatchingMedia(query);

    for (Media media in results) {
      if (widget.title == 'All Movies') {
        int? isMediaMovie = await serviceLocator<MovieDao>()
            .countMoviesByMediaId(media.id ?? 0);
        if (isMediaMovie == 1) {
          resultsToReturn.add(await serviceLocator<MediaVideoMovieSuperDao>()
              .findMediaVideoMovieByMediaId(media.id ?? 0));
        }
      } else if (widget.title == 'All TV Shows') {
        int? isMediaSeries = await serviceLocator<SeriesDao>()
            .countSeriesByMediaId(media.id ?? 0);
        if (isMediaSeries == 1) {
          resultsToReturn.add(await serviceLocator<MediaSeriesSuperDao>()
              .findMediaSeriesByMediaId(media.id ?? 0));
        }
      } else if (widget.title == 'All Books') {
        int? isMediaBook =
            await serviceLocator<BookDao>().countBooksByMediaId(media.id ?? 0);
        if (isMediaBook == 1) {
          resultsToReturn.add(await serviceLocator<MediaBookSuperDao>()
              .findMediaBookByMediaId(media.id ?? 0));
        }
      }
    }
    return resultsToReturn;
  }

  showSearchResultOrSeeAll() {
    if (searchText == '') {
      return [
        SearchBar(onSearch: onSearch),
        Expanded(
          child: ListMediaCatalog(title: widget.title, media: widget.media),
        )
      ];
    } else {
      return [
        SearchBar(onSearch: onSearch),
        Expanded(
          child: FutureBuilder(
            future: searchMediaBasedOnType(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListMediaCatalog(
                    title: widget.title,
                    media: snapshot.data ?? [],
                    refreshMediaList: widget.refreshMediaList);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: const Color(0xFF181A20),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF5E6272), width: 0.5)),
                    child: IconButton(
                      splashRadius: 0.1,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_rounded),
                      iconSize: 15,
                      color: const Color(0xFF5E6272),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: showSearchResultOrSeeAll()),
    );
  }
}
