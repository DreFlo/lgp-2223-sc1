// ignore_for_file: file_names, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:src/pages/HomePage.dart';
import 'package:src/pages/catalog_search/SeeAll.dart';
import '../Media.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Catalog extends StatelessWidget {
  final List trendingMovies;
  final List trendingTvshows;
  final List books;

  const Catalog(
      {Key? key,
      required this.trendingMovies,
      required this.trendingTvshows,
      required this.books})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    int listLength = (trendingMovies.length / 2).round();
    return Scaffold(
        body: ListView(shrinkWrap: true, children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                    media: trendingMovies)));
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
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            listLength, //will be dependent on database size
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: 140 * fem,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Media(
                                      image: trendingMovies[index]
                                          ['poster_path'],
                                      type: 'video'),
                                ],
                              ),
                            ),
                          );
                        },
                      ))),
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
                                    media: trendingTvshows)));
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
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listLength,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: 140 * fem,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Media(
                                      image: trendingTvshows[index]
                                          ['poster_path'],
                                      type: 'video'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ))),
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
              height: 210 * fem,
              padding: EdgeInsets.symmetric(horizontal: 15 * fem),
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: leisureColor,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listLength,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              //TODO: Open Media Page
                            },
                            radius: 0.1,
                            splashColor: Colors.transparent,
                            child: Container(
                              width: 140 * fem,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Media(
                                      image: books[index]
                                          .info
                                          .imageLinks['thumbnail']
                                          .toString(),
                                      type: 'book'),
                                ],
                              ),
                            ),
                          );
                        },
                      ))),
            ),
          ])),
      const SizedBox(height: 50),
    ]));
  }
}
