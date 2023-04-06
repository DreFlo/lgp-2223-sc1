import 'package:flutter/material.dart';
import 'SearchMedia/Books.dart';
import 'SearchMedia/Movies.dart';
import 'SearchMedia/Tvshows.dart';
import 'dart:async';

class SearchMedia extends StatefulWidget {
  final String search;

  const SearchMedia({Key? key, required this.search}) : super(key: key);

  @override
  State<SearchMedia> createState() => _SearchMediaState();
}

class _SearchMediaState extends State<SearchMedia>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late bool showSplashScreen;
  static bool _hasShownSplashScreen = false;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    if (_hasShownSplashScreen) {
      showSplashScreen = false;
    } else {
      showSplashScreen = true;
      _hasShownSplashScreen = true;
      Timer(const Duration(seconds: 2), () {
        setState(() {
          showSplashScreen = false;
        });
      });
    }
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
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22 * fem),
            child: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  text: 'Movies',
                ),
                Tab(
                  text: 'Tv Shows',
                ),
                Tab(
                  text: 'Books',
                ),
              ],
            ),
          ),
          Expanded(
            child: showSplashScreen
                ? Image.asset('assets/images/tmdb_logo.png')
                : TabBarView(
                    controller: tabController,
                    children: [
                      Movies(search: widget.search),
                      Tvshows(search: widget.search),
                      Books(search: widget.search),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
