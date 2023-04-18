import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/dashboard/dashboard_gridview.dart';
import '../widgets/dashboard/dashboard_horizontal_scrollview.dart';
import 'catalog_search/leisure_module.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/models/student/task.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
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

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool _searching = false;

  List trendingmovies = [];
  List trendingtvshows = [];
  List books = [];

  List<Task> tasks = [];

  //student stuff -> Taskgroup 
  //media stuff -> Timeslot
  final List<Project> items = [
    Project('Project de LGP', 'Student', 'LGP', 1, "Faculdade"),
    Project('Criar meu Portfolio', 'Personal', 'Profissional', 1),
    Project('Ver o último episódio de The Last of Us', 'Leisure', 'Tv Show'),
    Project('Ver John Wick', 'Leisure', 'Movie'),
    Project('Treino 5 Minutos', 'Fitness', 'Fitness'),
  ];

  late List<Project> searchResults = items;

  @override
  void initState() {
    super.initState();
    loadTasksDB();
  }

  void loadEventsDB(){ //only for Media

  }

  void loadTaskGroupsDB() { //lil cards student

  }

  void loadTasksDB() async { //lil cards student (tasks that don't have a taskgroup)
    tasks = await serviceLocator<TaskDao>().findTasksWithoutTaskGroup();
    setState(() {
      tasks = tasks;
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
            child: HorizontalScrollView(
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
          Expanded(child: DashBoardGridView(items: filterItems()))
        ],
      ),
    );
  }
}
