import 'package:flutter/material.dart';
import 'LeisureModule/Search.dart';
import 'LeisureModule/Catalog.dart';

class LeisureModule extends StatefulWidget {
  final List trendingMovies;
  final List trendingTvshows;
  final List books;

  const LeisureModule( 
    {Key? key,
      required this.trendingMovies,
      required this.trendingTvshows,
      required this.books})
      : super(key: key);

  @override
  State<LeisureModule> createState() => _LeisureModuleState();
}

class _LeisureModuleState extends State<LeisureModule>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      body: Column(
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
              padding: EdgeInsets.only(top: 22 * fem),
              child: TabBar(
                controller: tabController,
                tabs: [
                  Tab(
                    text: 'My Media',
                  ),
                  Tab(
                    text: 'Discover',
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 0, 0),
            child: Center(
              child: Container(
                width: 327 * fem,
                height: 50 * fem,
                child: Center(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // My Media TabBarView
                Catalog(
                  trendingMovies: widget.trendingMovies,
                  trendingTvshows: widget.trendingTvshows,
                  books: widget.books,),
                // Discover TabBarView
                SearchMedia(),
              ],
            ),
          ),
          /*Expanded(
            child: TabBarView(
              controller: myMediaTabController,
              children: [
                // My Media TabBarView
                Container(
                  child: Center(
                    child: Text('My Media'),
                  ),
                ),
                // Discover TabBarView
                Container(
                  child: Center(
                    child: Text('Discover'),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: mediaTypeTabController,
            tabs: [
              Tab(
                text: 'Movies',
              ),
              Tab(
                text: 'TV Shows',
              ),
              Tab(
                text: 'Books',
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
