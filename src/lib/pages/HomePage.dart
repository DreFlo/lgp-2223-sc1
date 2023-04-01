// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';
import 'package:src/utils/service_locator.dart';
import 'leisure/AddToCatalogForm.dart';
import 'leisure/FinishedMediaForm.dart';
import 'leisure/MarkEpisodesSheet.dart';
import 'leisure/MediaPage.dart';
import 'package:src/utils/enums.dart';

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
                                            isFavorite: false,
                                            title:
                                                "She-ra and the Princesses of Power",
                                            synopsis:
                                                "In this reboot of the '80s series, a magic sword transforms an orphan girl into warrior She-Ra, who unites a rebellion to fight against evil.",
                                            length: [5, 52, 20],
                                            cast: [
                                              'Aimee Carrero as Adora',
                                              'AJ Michalka as Catra',
                                              'Marcus Scribner as Bow',
                                              'Karen Fukuhara as Glimmer'
                                            ],
                                            notes: [
                                              'Glimmer sucks.',
                                              'Bow is best boy.'
                                            ],
                                            type: 'TV Show')),
                                    Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: ElevatedButton(
                                          onPressed: () {},
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
                                              AppLocalizations.of(context).add,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall),
                                        ))
                                  ])));
                }),
            ElevatedButton(
                child: Text("Finished Media Form"),
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
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                50),
                                        child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: FinishedMediaForm(
                                                rating: Reaction.neutral,
                                                startDate: DateTime.now()
                                                    .toString()
                                                    .split(" ")[0],
                                                endDate: 'Not Defined',
                                                isFavorite: false))),
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
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                              ),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .save,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                            )))
                                  ])));
                }),
            ElevatedButton(
                child: Text("Add To Catalog Form"),
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
                                                status: null,
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
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                              ),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .save,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                            )))
                                  ])));
                }),
                ElevatedButton(
                child: Text("Mark Episodes Sheet"),
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
                                                episodes: const {
                                                  1: {
                                                    1: "Episode 1",
                                                    2: "Episode 2"
                                                  },
                                                  2: {
                                                    1: "Episode 1",
                                                    2: "Episode 2"
                                                  },
                                                  3: {
                                                    1: "Episode 1",
                                                    2: "Episode 2"
                                                  },
                                                  4: {
                                                    1: "Episode 1",
                                                    2: "Episode 2"
                                                  }
                                                }))),
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
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                              ),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .save,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                            )))
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
