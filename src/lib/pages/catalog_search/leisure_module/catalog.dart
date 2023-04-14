// ignore_for_file: file_names, sized_box_for_whitespace, use_build_context_synchronously, must_be_immutable
import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/see_all.dart';
import 'package:src/themes/colors.dart';
import '../media.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'dart:math';

class Catalog extends StatelessWidget {
  Catalog({Key? key}) : super(key: key);

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

 Future<int> loadDuration(int id) async {
  List<int> ids = await serviceLocator<EpisodeDao>().findEpisodeBySeasonId(id);
  List<int> duration = [];
  for (int i = 0; i < ids.length; i++) {
    duration = await serviceLocator<VideoDao>().findVideoDurationById(ids[i]);
  }

  int maxDuration = duration.reduce(max);

  return maxDuration;
}

  Future<List<NoteBookNoteSuperEntity>> loadBookNotes(int id) async {
    List<NoteBookNoteSuperEntity> notes =
        await serviceLocator<NoteBookNoteSuperDao>()
            .findNoteBookNoteByBookId(id);
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
        body: ListView(shrinkWrap: true, children: [
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
                                    title:
                                        AppLocalizations.of(context).all_movies,
                                    media: movies)));
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
                                                                    (snapshot.data
                                                                            as List?)?[
                                                                        index],
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .all_movies,
                                                                    0)),
                                                            /*Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: mediaPageButton())*/
                                                          ])));
                                    },
                                    child: Container(
                                      width: 140 * fem,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Media(
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
                                    media: series)));
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
                                    onTap: () async {
                                      int maxDuration = await loadDuration(
                                          (snapshot.data as List?)?[index]?.id);
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
                                                                    (snapshot.data
                                                                            as List?)?[
                                                                        index],
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
                                    },
                                    child: Container(
                                      width: 140 * fem,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Media(
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
                                    title:
                                        AppLocalizations.of(context).all_books,
                                    media: books)));
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
                                    onTap: () async {
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
                                                                    (snapshot.data
                                                                            as List?)?[
                                                                        index],
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .all_books,
                                                                    0)),
                                                            /*Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: mediaPageButton())*/
                                                          ])));
                                    },
                                    child: Container(
                                      width: 140 * fem,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Media(
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
    ]));
  }
}
