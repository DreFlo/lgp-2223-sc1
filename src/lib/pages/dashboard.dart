import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/dashboard/dashboard_gridview.dart';
import '../widgets/dashboard/dashboard_horizontal_scrollview.dart';
import 'catalog_search/leisure_module.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';

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
  List<TaskGroup> taskGroups = [];
  List<TimeslotMediaTimeslotSuperEntity> mediaEvents = [];
  bool loadedAllData = false;

  //student stuff -> Taskgroup
  //media stuff -> Timeslot
  /*final List<Project> items = [
    Project('Project de LGP', 'Student', 'LGP', 1, "Faculdade"),
    Project('Criar meu Portfolio', 'Personal', 'Profissional', 1),
    Project('Ver o último episódio de The Last of Us', 'Leisure', 'Tv Show'),
    Project('Ver John Wick', 'Leisure', 'Movie'),
    Project('Treino 5 Minutos', 'Fitness', 'Fitness'),
  ];

  late List<Project> searchResults = items;*/

  late dynamic searchResults = items;

  @override
  void initState() {
    super.initState();
    loadDataDB();
  }

  List<dynamic> get items {
    if (loadedAllData) {
      final List<dynamic> combined = [];
      if (tasks.isNotEmpty) {
        combined.addAll(tasks);
      }
      if (taskGroups.isNotEmpty) {
        combined.addAll(taskGroups);
      }
      if (mediaEvents.isNotEmpty) {
        combined.addAll(mediaEvents);
      }
      
      searchResults = combined;
      return combined;
    }
    return [];
  }

  void loadEventsDB() async {
    //only for Media
    mediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllTimeslotMediaTimeslot();
    setState(() {
      mediaEvents = mediaEvents;
    });
  }

  void loadTaskGroupsDB() async {
    //lil cards student
    taskGroups = await serviceLocator<TaskGroupDao>().findAllTaskGroups();
    setState(() {
      taskGroups = taskGroups;
    });
  }

  void loadTasksDB() async {
    //lil cards student (tasks that don't have a taskgroup)
    tasks = await serviceLocator<TaskDao>().findTasksWithoutTaskGroup();
    setState(() {
      tasks = tasks;
    });
  }

  void loadDataDB() async {
    loadTaskGroupsDB();
    loadTasksDB();
    loadEventsDB();
    setState(() {
      loadedAllData = true;
    });
  }

  void search(String query) {
    setState(() {
      searchResults = items
          .where((element) =>
              element is Task &&
                  element.name.toLowerCase().contains(query.toLowerCase()) ||
              element is TaskGroup &&
                  element.name.toLowerCase().contains(query.toLowerCase()) ||
              element is TimeslotMediaTimeslotSuperEntity &&
                  element.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  showWidget() {
    if (loadedAllData) {
      List<Task> taskResults = searchResults.whereType<Task>().toList();
      List<TaskGroup> taskGroupResults =
          searchResults.whereType<TaskGroup>().toList();
      List<TimeslotMediaTimeslotSuperEntity> mediaResults =
          searchResults.whereType<TimeslotMediaTimeslotSuperEntity>().toList();
      switch (_selectedIndex) {
        case 1:
          return DashBoardGridView(
              tasks: taskResults, taskGroups: taskGroupResults);
        case 2:
          return DashBoardGridView(mediaEvents: mediaResults);
        default:
          return DashBoardGridView(
              tasks: taskResults,
              taskGroups: taskGroupResults,
              mediaEvents: mediaResults);
      }
    }
  }

  /*List<Project> filterItems() {
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
  }*/

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
              nItems: tasks.length + taskGroups.length + mediaEvents.length,
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
          Expanded(child: showWidget())
        ],
      ),
    );
  }
}
