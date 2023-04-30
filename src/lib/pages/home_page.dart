// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/env/env.dart';
import 'package:src/models/user.dart';
import 'package:src/pages/gamification/no_progress_in_timeslot_modal.dart';
import 'package:src/pages/gamification/timeslot_finished_modal.dart';
import 'package:src/pages/leisure/add_book_note_form.dart';
import 'package:src/pages/leisure/book_notes_sheet.dart';
import 'package:src/pages/leisure/episodes_notes_sheet.dart';
import 'package:src/pages/leisure/mark_episodes_sheet.dart';
import 'package:src/pages/leisure/media_page.dart';
import 'package:src/pages/tasks/institution_form.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import '../models/student/task.dart';
import '../models/timeslot/timeslot.dart';
import 'gamification/gained_xp_toast.dart';
import 'gamification/level_up_toast.dart';
import 'gamification/progress_bar_sheet.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:src/pages/auth/landing_page.dart';
import 'package:src/pages/catalog_search/leisure_module.dart';

import 'gamification/progress_in_timeslot_modal.dart';
import 'leisure/add_to_catalog_form.dart';
import 'tasks/project_form.dart';
import 'tasks/task_form.dart';
import 'package:src/pages/tasks/project_form.dart';
import 'package:src/pages/tasks/task_form.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _counter = 0;
  Object redrawObject = Object();
  bool isFavorite = false;
  List<String> user = ['John Smith', '11', '400'];
  Status status = Status.goingThrough;
  String title = "She-ra and the Princesses of Power",
      synopsis =
          "In this reboot of the '80s series, a magic sword transforms an orphan girl into warrior She-Ra, who unites a rebellion to fight against evil.",
      type = "TV Show";
  List<int> length = [5, 52, 20];
  List<String> cast = [
    'Aimee Carrero as Adora',
    'AJ Michalka as Catra',
    'Marcus Scribner as Bow',
    'Karen Fukuhara as Glimmer'
  ];
  Map<String, String> notes = {
    'S04E03':
        "After Horde Prime takes Glimmer aboard his flagship, she loses her access to magic again in Season 5. This time her combat skills don't cut it against the much stronger antagonists of Horde Prime's clone army- Catra has to save her multiple times. Only until she returns to Etheria's surface does she get her powers back, though she does manage to cast spells on Krytis.",
    'S02E07': 'Bow is best boy.'
  };
  Map<String, String> bookNotes = {
    '0-10':
        "After Horde Prime takes Glimmer aboard his flagship, she loses her access to magic again in Season 5. This time her combat skills don't cut it against the much stronger antagonists of Horde Prime's clone army- Catra has to save her multiple times. Only until she returns to Etheria's surface does she get her powers back, though she does manage to cast spells on Krytis.",
    '11-20': 'Bow is best boy.'
  };
  Map<int, Map<int, String>> episodes = const {
    1: {
      1: "123445241355423523254135362541355342",
      2: "Episode 2",
      3: "Episode 3",
      4: "Episode 4"
    },
    2: {1: "Episode 1", 2: "Episode 2"},
    3: {1: "Episode 1", 2: "Episode 2"},
    4: {1: "Episode 1", 2: "Episode 2"}
  };

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  List trendingmovies = [];
  List trendingtvshows = [];
  List books = [];

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

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Wrap(spacing: 10, children: [
        const SizedBox(height: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).helloWorld,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(0, 250, 100, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))))),
              child: const Text('To another view!'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreenAni()));
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(0, 250, 100, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))))),
              child: const Text('Search/Catalog'),
              onPressed: () {
                loadmedia();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LeisureModule(
                            trendingMovies: trendingmovies,
                            trendingTvshows: trendingtvshows,
                            books: books)));
                // builder: (context) => SearchMedia()));
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Input a name'),
              controller: nameInputController,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(0, 250, 100, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))))),
              child: const Text('Add name'),
              onPressed: () async {
                await serviceLocator<UserDao>().insertUser(User(
                    userName: nameInputController.text,
                    id: 0,
                    password: 'secure',
                    xp: 0,
                    level: 1,
                    imagePath: ''));
                setState(() {
                  redrawObject = Object();
                });
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF6C5DD3)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))))),
              child: const Text('Auth Pages'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LandingPage()));
              },
            ),
            ElevatedButton(
                child: Text("Media Page"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.35,
                          maxChildSize: 0.75,
                          builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: const [
                                    /*SingleChildScrollView(
                                        controller: scrollController,
                                        child: MediaPage(
                                            title: title,
                                            synopsis: synopsis,
                                            type: type,
                                            length: length,
                                            cast: cast,
                                            image: 'assets/images/poster.jpg',
                                            notes: notes,
                                            status: status,
                                            leisureTags: const [],
                                            isFavorite: isFavorite)),
                                    Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: mediaPageButton())*/
                                  ])));
                }),
            ElevatedButton(
                child: Text("Task Form"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            child: DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.60,
                                minChildSize: 0.60,
                                maxChildSize: 0.60,
                                builder: (context, scrollController) =>
                                    TaskForm(
                                      scrollController: scrollController,
                                    )),
                          ));
                }),
            ElevatedButton(
                child: Text("Project Form"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                          child: DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.75,
                              minChildSize: 0.75,
                              maxChildSize: 0.75,
                              builder: (context, scrollController) =>
                                  ProjectForm(
                                    scrollController: scrollController,
                                  ))));
                }),
            ElevatedButton(
                child: Text("Subject Form"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.5,
                            minChildSize: 0.5,
                            maxChildSize: 0.5,
                            builder: (context, scrollController) => SubjectForm(
                              scrollController: scrollController,
                            ),
                          )));
                }),
            ElevatedButton(
                child: Text("Institution Form"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.5,
                            minChildSize: 0.5,
                            maxChildSize: 0.5,
                            builder: (context, scrollController) =>
                                InstitutionForm(
                              scrollController: scrollController,
                            ),
                          )));
                }),
            ElevatedButton(
                child: Text("Progress Bar"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                            child: ProgressBarSheet(
                                level: 2,
                                user: user,
                                image: 'assets/images/poster.jpg'),
                          ));
                }),
            ElevatedButton(
                child: Text("Gaining progress toast"),
                onPressed: () {
                  var snackBar = SnackBar(
                    duration: const Duration(seconds: 15),
                    content: GainedXPToast(value: 40, level: 2, points: 10),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  );
                  // Step 3
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }),
            ElevatedButton(
                child: Text("Level up toast"),
                onPressed: () {
                  var snackBar = SnackBar(
                    content: LevelUpToast(level: 2, points: 20),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  );
                  // Step 3
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }),
            ElevatedButton(
                child: Text("Finished timeslot <3"),
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => Dialog(
                          backgroundColor: modalBackground,
                          insetPadding: EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TimeslotFinishedModal(
                              timeslot: Timeslot(
                                  title: "Finish LGP project!",
                                  description: "Finish LGP project!",
                                  xpMultiplier: 2,
                                  finished: true,
                                  userId: 1,
                                  endDateTime: DateTime.now(),
                                  startDateTime: DateTime.now()
                                      .subtract(Duration(hours: 20))),
                              tasks: [
                                Task(
                                    id: 0,
                                    name: "Math assignment for Algebra",
                                    description:
                                        "Do 3 problems from page 12 before Thursday",
                                    deadline: DateTime.now(),
                                    priority: Priority.medium,
                                    taskGroupId: 0,
                                    subjectId: 0,
                                    xp: 10,
                                    finished: false),
                                Task(
                                    id: 1,
                                    name: "Math assignment for Algebra",
                                    description:
                                        "Do 3 problems from page 12 before Thursday",
                                    deadline: DateTime.now(),
                                    priority: Priority.medium,
                                    taskGroupId: 0,
                                    subjectId: 0,
                                    xp: 10,
                                    finished: false),
                                Task(
                                    id: 2,
                                    name: "Math assignment for Algebra",
                                    description:
                                        "Do 3 problems from page 12 before Thursday",
                                    deadline: DateTime.now(),
                                    priority: Priority.medium,
                                    taskGroupId: 0,
                                    subjectId: 0,
                                    xp: 10,
                                    finished: false),
                                Task(
                                    id: 3,
                                    name: "Math assignment for Algebra",
                                    description:
                                        "Do 3 problems from page 12 before Thursday",
                                    deadline: DateTime.now(),
                                    priority: Priority.medium,
                                    taskGroupId: 0,
                                    subjectId: 0,
                                    xp: 10,
                                    finished: false),
                                Task(
                                    id: 4,
                                    name: "Math assignment for Algebra",
                                    description:
                                        "Do 3 problems from page 12 before Thursday",
                                    deadline: DateTime.now(),
                                    priority: Priority.medium,
                                    taskGroupId: 0,
                                    subjectId: 0,
                                    xp: 10,
                                    finished: false),
                              ])));
                }),
            ElevatedButton(
                child: Text("progress in timeslot"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          backgroundColor: modalBackground,
                          insetPadding: EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ProgressInTimeslotModal(
                            modules: const [
                              Module.student,
                              Module.fitness,
                              Module.personal
                            ],
                            taskCount: 5,
                            finishedTaskCount: 3,
                          )));
                }),
            ElevatedButton(
                child: Text("no progress in timeslot"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          backgroundColor: modalBackground,
                          insetPadding: EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: NoProgressInTimeslotModal()));
                }),
            FutureBuilder(
                key: ValueKey<Object>(redrawObject),
                future: serviceLocator<UserDao>().findAllUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    StringBuffer stringBuffer = StringBuffer();
                    for (User person in snapshot.data) {
                      stringBuffer.write('${person.userName}, ');
                    }
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Result: ${stringBuffer.toString()}'),
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                }),
          ],
        ),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
