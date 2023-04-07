import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/dashboard/my_dashboard_gridview.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../env/env.dart';
import '../widgets/dashboard/my_horizontal_scrollview.dart';
import 'catalog_search/LeisureModule.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

// TODO: Replace with real data
class Project {
  final String title;
  final String module;
  final String subject;
  final String institution;
  final int nTasks;

  Project(this.title, this.module, this.subject,
      [this.nTasks = 0, this.institution = ""]);
}

class _MyDashboardState extends State<MyDashboard> {
  int _selectedIndex = 0;
  bool _searching = false;

  List trendingmovies = [];
  List trendingtvshows = [];
  List books = [];

  final List<Project> items = [
    Project('Project de LGP', 'Student', 'LGP', 1, "Faculdade"),
    Project('Criar meu Portfolio', 'Personal', 'Profissional', 1),
    Project('Ver o último episódio de The Last of Us', 'Leisure', 'Tv Show'),
    Project('Ver John Wick', 'Leisure', 'Movie'),
    Project('Treino 5 Minutos', 'Fitness', 'Fitness'),
  ];

  late List<Project> searchResults = items;

  void loadmedia() async {
    final tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));
    Map movieresult =
        await tmdb.v3.trending.getTrending(mediaType: MediaType.movie);
    Map tvresult = await tmdb.v3.trending
        .getTrending(mediaType: MediaType.tv); //doesn't have ['results']
    books = await queryBooks(
      'batman',
      maxResults: 40,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );

    setState(() {
      trendingmovies = movieresult['results'];
      trendingtvshows = tvresult['results'];
      books = books;
    });
  }

  void search(String query) {
    setState(() {
      searchResults = items
          .where((element) =>
              element.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  List<Project> filterItems() {
    switch (_selectedIndex) {
      case 1:
        return searchResults
            .where((element) => element.module == 'Student')
            .toList();
      case 2:
        return searchResults
            .where((element) => element.module == 'Leisure')
            .toList();
      case 3:
        return searchResults
            .where((element) => element.module == 'Fitness')
            .toList();
      case 4:
        return searchResults
            .where((element) => element.module == 'Personal')
            .toList();
      default:
        return searchResults;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 33),
            child: MyHorizontalScrollView(
              nItems: items.length,
              selectedIndex: _selectedIndex,
              setSelectedIndex: (int index) =>
                  setState(() => _selectedIndex = index),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 31),
                child: Text(
                  AppLocalizations.of(context).dashboard,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _selectedIndex == 2
                      ? GestureDetector(
                          onTap: () => {
                            // navigate to catalog
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LeisureModule(
                                        trendingMovies: trendingmovies,
                                        trendingTvshows: trendingtvshows,
                                        books: books)))
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: const Icon(
                              Icons.list_alt,
                              color: grayText,
                              size: 25,
                            ),
                          ),
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () => {
                      setState(() => _searching = !_searching),
                      if (!_searching) search("")
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: _searching ? 0 : 31),
                      child: const Icon(
                        Icons.search_rounded,
                        color: grayText,
                        size: 25,
                      ),
                    ),
                  ),
                  _searching
                      ? Container(
                          width: 150,
                          height: 25,
                          margin: const EdgeInsets.only(right: 31),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: grayButton,
                          ),
                          child: TextField(
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.labelSmall,
                            onChanged: (value) => {
                              setState(() {
                                search(value);
                              })
                            },
                          ),
                        )
                      : Container(),
                ],
              )
            ],
          ),
          Expanded(child: MyDashBoardGridView(items: filterItems()))
        ],
      ),
    );
  }
}
