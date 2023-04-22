import 'package:flutter/material.dart';
import 'search_media/books.dart';
import 'search_media/movies.dart';
import 'search_media/tv_shows.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  Timer? _timer;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    if (_hasShownSplashScreen) {
      showSplashScreen = false;
    } else {
      showSplashScreen = true;
      _hasShownSplashScreen = true;
      _timer = Timer(const Duration(seconds: 2), () {
        setState(() {
          showSplashScreen = false;
        });
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  text: AppLocalizations.of(context).movies,
                ),
                Tab(
                  text: AppLocalizations.of(context).tv_shows,
                ),
                Tab(
                  text: AppLocalizations.of(context).books,
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
                      TVShows(search: widget.search),
                      Books(search: widget.search),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
