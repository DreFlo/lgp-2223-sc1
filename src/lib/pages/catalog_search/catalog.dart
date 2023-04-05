import 'package:flutter/material.dart';

class Catalog extends StatelessWidget {
  final List trendingMovies;
  final List trendingTvshows;

  const Catalog(
      {Key? key, required this.trendingMovies, required this.trendingTvshows})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff181a20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10 * fem, 50 * fem, 0, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Media',
                    style: TextStyle(
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
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'My Media',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xff5e6272),
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20 * fem),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Discover',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 0, 0),
              child: Center(
              child: Container(
                width: 327 * fem,
                height: 30 * fem,
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xff5e6272),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      filled: true,
                      fillColor: const Color(0xffdadada),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                    ),
                  ),
                )),
              ),
            ),
            Expanded(
              child:ListView(
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
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
              Padding(
        padding: EdgeInsets.only(right: 10 * fem),
        child: TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
      ),
    ],
            )
          ),
          //const SizedBox(height: 10),
          Container(
            height: 270*fem,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 15 * fem),
              scrollDirection: Axis.horizontal,
              itemCount: trendingMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    width: 140*fem,
                    child: Column(
                      children: [
                       /* Media(
                          image: trendingMovies[index]['poster_path'],
                        ),*/
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
