// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';
import 'package:src/utils/service_locator.dart';
import 'leisure/AddToCatalogForm.dart';
import 'leisure/MarkEpisodesSheet.dart';
import 'leisure/EpisodesNotesSheet.dart';
import 'leisure/BookNotesSheet.dart';
import 'leisure/AddBookNoteForm.dart';
import 'leisure/MediaPage.dart';
import 'package:src/utils/enums.dart';
import 'package:src/env/env.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'catalog_search/Catalog.dart';


const Color leisureColor = Color(0xFFF52349);

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  Object redrawObject = Object();
  bool isFavorite = false;
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

  void loadmedia() async {
    final tmdb = TMDB(
        ApiKeys('api key', 'apiReadAccessTokenv4'));
    Map movieresult =
        await tmdb.v3.trending.getTrending(mediaType: MediaType.movie);
    Map tvresult = await tmdb.v3.trending
        .getTrending(mediaType: MediaType.tv); //doesn't have ['results']

    setState(() {
      trendingmovies = movieresult['results'];
      trendingtvshows = tvresult['results'];
    });
  }

  Widget mediaPageButton() {
    if (type == "TV Show") {
      if (status == Status.nothing) {
        // If the media is not in the catalog, show a button to add it.
        return ElevatedButton(
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
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.5,
                    builder: (context, scrollController) => Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: AddToCatalogForm(
                                          status: Status.nothing,
                                          startDate: DateTime.now()
                                              .toString()
                                              .split(" ")[0],
                                          endDate: 'Not Defined'))),
                              Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //TODO: Save stuff + send to database.
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              55),
                                          backgroundColor: leisureColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context).save,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                      )))
                            ])));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
            backgroundColor: leisureColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(AppLocalizations.of(context).add,
              style: Theme.of(context).textTheme.headlineSmall),
        );
      } else {
        // If media is somehow in the catalog, then user should be able to see their notes and edit info.
        return Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
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
                          initialChildSize: 0.35,
                          minChildSize: 0.35,
                          maxChildSize: 0.5,
                          builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                50),
                                        child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: MarkEpisodesSheet(
                                                episodes: episodes))),
                                  ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).progress,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              ElevatedButton(
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
                          initialChildSize: 0.35,
                          minChildSize: 0.35,
                          maxChildSize: 0.5,
                          builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                50),
                                        child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: EpisodesNotesSheet(
                                                notes: notes,
                                                episodes: episodes)))
                                  ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).notes,
                    style: Theme.of(context).textTheme.headlineSmall),
              )
            ],
          ),
        );
      }
    } else if (type == "Book") {
      if (status == Status.nothing) {
        // If the media is not in the catalog, show a button to add it.
        return ElevatedButton(
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
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.5,
                    builder: (context, scrollController) => Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          50),
                                  child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: AddToCatalogForm(
                                          status: Status.nothing,
                                          startDate: DateTime.now()
                                              .toString()
                                              .split(" ")[0],
                                          endDate: 'Not Defined'))),
                              Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //TODO: Save stuff + send to database.
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              55),
                                          backgroundColor: leisureColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context).save,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                      )))
                            ])));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
            backgroundColor: leisureColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(AppLocalizations.of(context).add,
              style: Theme.of(context).textTheme.headlineSmall),
        );
      } else {
        // If media is somehow in the catalog, then user should be able to see their notes and edit info.
        return Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
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
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Stack(children: const [
                            AddBookNoteForm(),
                          ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).progress,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              ElevatedButton(
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
                          initialChildSize: 0.35,
                          minChildSize: 0.35,
                          maxChildSize: 0.5,
                          builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                50),
                                        child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: BookNotesSheet(
                                                notes: bookNotes)))
                                  ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).notes,
                    style: Theme.of(context).textTheme.headlineSmall),
              )
            ],
          ),
        );
      }
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
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
                        builder: (context) => Catalog(trendingMovies: trendingmovies, trendingTvshows: trendingtvshows,)));
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
                await serviceLocator<PersonDao>()
                    .insertPerson(Person(name: nameInputController.text));
                setState(() {
                  redrawObject = Object();
                });
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
                                  children: [
                                    SingleChildScrollView(
                                        controller: scrollController,
                                        child: MediaPage(
                                            title: title,
                                            synopsis: synopsis,
                                            type: type,
                                            length: length,
                                            cast: cast,
                                            notes: notes,
                                            status: status,
                                            isFavorite: isFavorite)),
                                    Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: mediaPageButton())
                                  ])));
                }),
            FutureBuilder(
                key: ValueKey<Object>(redrawObject),
                future: serviceLocator<PersonDao>().findAllPersons(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    StringBuffer stringBuffer = StringBuffer();
                    for (Person person in snapshot.data) {
                      stringBuffer.write('${person.name}, ');
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
