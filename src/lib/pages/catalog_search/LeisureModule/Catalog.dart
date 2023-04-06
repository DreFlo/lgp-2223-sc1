import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/SeeAll.dart';
import '../Media.dart';
import '../Book.dart';

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
    int listLength = (trendingMovies.length/2).round();
    return Scaffold(
        body: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 20 * fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Movies',
                              style: TextStyle(
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
                                        title: 'All Movies',
                                        media: trendingMovies
                            )));
                                },
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
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
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 15 * fem),
                        scrollDirection: Axis.horizontal,
                        itemCount: listLength, //will be dependent on database size
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: 140 * fem,
                              child: Column(
                                children: [
                                  Media(
                                    image: trendingMovies[index]
                                        ['poster_path'],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20 * fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TV Shows',
                              style: TextStyle(
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
                                        title: 'All Tv Shows',
                                        media: trendingTvshows
                            )));
                                },
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
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
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 15 * fem),
                        scrollDirection: Axis.horizontal,
                        itemCount: listLength,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: 140 * fem,
                              child: Column(
                                children: [
                                  Media(
                                    image: trendingTvshows[index]
                                        ['poster_path'],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20 * fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Books',
                              style: TextStyle(
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
                                        title: 'All Books',
                                        media: books
                            )));
                                },
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
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
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 15 * fem),
                        scrollDirection: Axis.horizontal,
                        itemCount: listLength,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              width: 140 * fem,
                              child: Column(
                                children: [
                                   Book(
                                    image: books[index].info.imageLinks['thumbnail'].toString(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              ]
              )
              )])
              );

  }
}
