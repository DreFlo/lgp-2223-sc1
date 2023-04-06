// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'LeisureModule/Search.dart';
import 'LeisureModule/Catalog.dart';
import 'SearchBar.dart';

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

  String searchText = '';
  void onSearch(String text) {
    setState(() {
      searchText = text;
    });
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
                tabs: const [
                  Tab(
                    text: 'My Media',
                  ),
                  Tab(
                    text: 'Discover',
                  ),
                ],
              )),
          SearchBar(onSearch: onSearch),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // My Media TabBarView
                Catalog(
                  trendingMovies: widget.trendingMovies,
                  trendingTvshows: widget.trendingTvshows,
                  books: widget.books,
                ),
                // Discover TabBarView
                SearchMedia(search: searchText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
