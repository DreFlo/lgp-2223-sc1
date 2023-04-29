import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/dashboard/dashboard_gridview.dart';
import 'package:src/widgets/dashboard/dashboard_horizontal_scrollview.dart';
import 'package:src/pages/catalog_search/leisure_module.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/utils/dashboard_project.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
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

  List<DashboardTask> dashboardTasks = [];

  late List searchResults = items;

  @override
  void initState() {
    super.initState();
    loadDataDB();
  }

  List get items {
    if (loadedAllData) {
      final List combined = [];
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

  Future<List<TimeslotMediaTimeslotSuperEntity>> loadEventsDB(
      DateTime start) async {
    //only for Media
    //need to find out the type of media + date
    //date easy -- type of media too many queries
    mediaEvents = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
        .findAllTimeslotMediaTimeslot(start);

    return mediaEvents;
  }

  Future<List<TaskGroup>> loadTaskGroupsDB() async {
    //lil cards student
    //need to find out subject + date + institution + number of tasks
    taskGroups = await serviceLocator<TaskGroupDao>().findAllTaskGroups();
    return taskGroups;
  }

  Future<List<Task>> loadTasksDB() async {
    //lil cards student (tasks that don't have a taskgroup)
    //need to find out subject + date + institution
    tasks = await serviceLocator<TaskDao>().findTasksWithoutTaskGroup();
    return tasks;
  }

  void loadDataDB() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, 0, 0, 0);

    mediaEvents = await loadEventsDB(start);
    taskGroups = await loadTaskGroupsDB();
    tasks = await loadTasksDB();
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
      if (searchResults.isEmpty) {
        searchResults = items;
      }
      List<Task> taskResults = searchResults.whereType<Task>().toList();
      List<TaskGroup> taskGroupResults =
          searchResults.whereType<TaskGroup>().toList();
      List<TimeslotMediaTimeslotSuperEntity> mediaResults =
          searchResults.whereType<TimeslotMediaTimeslotSuperEntity>().toList();
      switch (_selectedIndex) {
        case 0:
          return DashBoardGridView(
              tasks: taskResults,
              taskGroups: taskGroupResults,
              mediaEvents: mediaResults);
        case 1:
          return DashBoardGridView(
              tasks: taskResults, taskGroups: taskGroupResults);
        case 2:
          return DashBoardGridView(mediaEvents: mediaResults);
        default:
          return const DashBoardGridView(
              tasks: [], taskGroups: [], mediaEvents: []);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
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
          loadedAllData ? Expanded(child: showWidget()) : Container(),
        ],
      ),
    ));
  }
}
