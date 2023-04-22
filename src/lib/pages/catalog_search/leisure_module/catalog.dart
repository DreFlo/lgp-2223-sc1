import 'package:flutter/material.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/pages/catalog_search/search_results.dart';
import 'package:src/pages/catalog_search/see_all.dart';
import 'package:src/themes/colors.dart';
import '../media.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';

class Catalog extends StatefulWidget {
  final String search;

  const Catalog({Key? key, required this.search}) : super(key: key);

  @override
  CatalogState createState() => CatalogState();
}

class CatalogState extends State<Catalog> {
  List movies = [];
  List series = [];
  List books = [];

  Future<List> loadmedia(String type) async {
    List result = [];

    if (type == 'movie') {
      result = await serviceLocator<MediaVideoMovieSuperDao>()
          .findAllMediaVideoMovie();
      movies = result;
    } else if (type == 'tv') {
      result = await serviceLocator<MediaSeriesSuperDao>().findAllMediaSeries();
      series = result;
    } else if (type == 'book') {
      result = await serviceLocator<MediaBookSuperDao>().findAllMediaBooks();
      books = result;
    }

    return result;
  }

  Future<List> loadMovies() async {
    return await loadmedia('movie');
  }

  Future<List> loadTv() async {
    return await loadmedia('tv');
  }

  Future<List> loadBooks() async {
    return await loadmedia('book');
  }

  Future<void> refreshMovies() async {
    await loadMovies();
    setState(() {});
  }

  Future<void> refreshSeries() async {
    await loadTv();
    setState(() {});
  }

  Future<void> refreshBooks() async {
    await loadBooks();
    setState(() {});
  }

  Future<Map> searchMedia() async {
    List<MediaVideoMovieSuperEntity> movieResults = [];
    List<MediaBookSuperEntity> bookResults = [];
    List<MediaSeriesSuperEntity> seriesResults = [];
    String query = '%${widget.search}%';
    final results = await serviceLocator<MediaDao>().getMatchingMedia(query);

    //identify the type of media and add it to the correct list
    for (Media media in results) {
      int? isMediaMovie =
          await serviceLocator<MovieDao>().countMoviesByMediaId(media.id ?? 0);
      int? isMediaSeries =
          await serviceLocator<SeriesDao>().countSeriesByMediaId(media.id ?? 0);
      int? isMediaBook =
          await serviceLocator<BookDao>().countBooksByMediaId(media.id ?? 0);

      if (isMediaMovie == 1) {
        movieResults.add(await serviceLocator<MediaVideoMovieSuperDao>()
            .findMediaVideoMovieByMediaId(media.id ?? 0));
      }
      if (isMediaSeries == 1) {
        seriesResults.add(await serviceLocator<MediaSeriesSuperDao>()
            .findMediaSeriesByMediaId(media.id ?? 0));
      }
      if (isMediaBook == 1) {
        bookResults.add(await serviceLocator<MediaBookSuperDao>()
            .findMediaBookByMediaId(media.id ?? 0));
      }
    }

    return {
      'movies': movieResults,
      'series': seriesResults,
      'books': bookResults,
    };
  }

  Future<void> refreshSearch() async {
    await searchMedia();
    setState(() {});
  }

  showSearchResultOrCatalog(context, double fem) {
    if (widget.search == '') {
      return ListView(shrinkWrap: true, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20 * fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).movies,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10 * fem),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeeAll(
                                      title: AppLocalizations.of(context)
                                          .all_movies,
                                      media: movies,
                                      refreshMediaList: refreshMovies)));
                        },
                        child: Text(
                          AppLocalizations.of(context).see_all,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xff5e6272),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                height: 210 * fem,
                child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: leisureColor,
                        child: FutureBuilder(
                            future: loadMovies(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: (snapshot.data as List?)?.length ??
                                      0, //will be dependent on database size
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        showMediaPageForMovies(
                                            (snapshot.data as List?)?[index],
                                            context);
                                      },
                                      child: SizedBox(
                                        width: 140 * fem,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MediaWidget(
                                                image: (snapshot.data
                                                        as List?)?[index]
                                                    ?.linkImage,
                                                type: 'video'),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return const CircularProgressIndicator();
                            }))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20 * fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).tv_shows,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10 * fem),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeeAll(
                                      title: AppLocalizations.of(context)
                                          .all_tv_shows,
                                      media: series,
                                      refreshMediaList: refreshSeries)));
                        },
                        child: Text(
                          AppLocalizations.of(context).see_all,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xff5e6272),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                height: 210 * fem,
                child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: leisureColor,
                        child: FutureBuilder(
                            future: loadTv(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: (snapshot.data as List?)?.length ??
                                      0, //will be dependent on database size
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        showMediaPageForTV(
                                            (snapshot.data as List?)?[index],
                                            context);
                                      },
                                      child: SizedBox(
                                        width: 140 * fem,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MediaWidget(
                                                image: (snapshot.data
                                                        as List?)?[index]
                                                    ?.linkImage,
                                                type: 'video'),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return const CircularProgressIndicator();
                            }))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20 * fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).books,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10 * fem),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeeAll(
                                      title: AppLocalizations.of(context)
                                          .all_books,
                                      media: books,
                                      refreshMediaList: refreshBooks)));
                        },
                        child: Text(
                          AppLocalizations.of(context).see_all,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xff5e6272),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                height: 210 * fem,
                child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: leisureColor,
                        child: FutureBuilder(
                            future: loadBooks(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: (snapshot.data as List?)?.length ??
                                      0, //will be dependent on database size
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        showMediaPageForBooks(
                                            (snapshot.data as List?)?[index],
                                            context);
                                      },
                                      child: SizedBox(
                                        width: 140 * fem,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MediaWidget(
                                                image: (snapshot.data
                                                        as List?)?[index]
                                                    ?.linkImage,
                                                type: 'book'),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return const CircularProgressIndicator();
                            }))),
              ),
              const SizedBox(height: 50),
            ],
          ),
        )
      ]);
    } else {
      return FutureBuilder<Map>(
        future: searchMedia(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SearchResults(media: snapshot.data!)),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(body: showSearchResultOrCatalog(context, fem));
  }
}
