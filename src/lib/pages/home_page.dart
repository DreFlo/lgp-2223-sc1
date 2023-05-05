// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/models/user.dart';
import 'package:src/notifications/local_notifications_service.dart';
import 'package:src/pages/auth/landing_page.dart';
import 'package:src/pages/events/event_form.dart';
import 'package:src/pages/tasks/institution_form.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/tasks/project_form.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/pages/timer/timer_form.dart';
import 'package:src/utils/reset_db.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _counter = 0;
  Object redrawObject = Object();
  List<String> user = ['John Smith', '11', '400'];

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
                    id: 0,
                    name: nameInputController.text,
                    email: '${nameInputController.text}@gmail.com',
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
                                        30),
                            child: DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.80,
                                minChildSize: 0.80,
                                maxChildSize: 0.85,
                                builder: (context, scrollController) =>
                                    TaskForm(
                                        scrollController: scrollController,
                                        id: 1)),
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
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.75,
                          minChildSize: 0.75,
                          maxChildSize: 0.75,
                          builder: (context, scrollController) => ProjectForm(
                              scrollController: scrollController, id: 1)));
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
                            initialChildSize: 0.70,
                            minChildSize: 0.70,
                            maxChildSize: 0.75,
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
                                  30),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.65,
                            minChildSize: 0.65,
                            maxChildSize: 0.70,
                            builder: (context, scrollController) =>
                                InstitutionForm(
                              scrollController: scrollController,
                            ),
                          )));
                }),
            ElevatedButton(
                child: Text("notif"),
                onPressed: () {
                  serviceLocator<LocalNotificationService>()
                      .display('Go Study or else \u{1F52A}');
                }),
            ElevatedButton(
                child: Text("Event Form"),
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
                                initialChildSize: 0.9,
                                minChildSize: 0.9,
                                maxChildSize: 0.9,
                                builder: (context, scrollController) =>
                                    EventForm(
                                      scrollController: scrollController,
                                      // id: 2,
                                      // type: "student",
                                      // OR (1, leisure)
                                    )),
                          ));
                }),
            ElevatedButton(
                child: Text("Timer Form"),
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
                                  30),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.7,
                            minChildSize: 0.7,
                            maxChildSize: 0.7,
                            builder: (context, scrollController) => TimerForm(
                              scrollController: scrollController,
                            ),
                          )));
                }),
            ElevatedButton(
                onPressed: resetAndSeedDatabase, child: Text("Reset Database")),
            FutureBuilder(
                key: ValueKey<Object>(redrawObject),
                future: serviceLocator<UserDao>().findAllUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    StringBuffer stringBuffer = StringBuffer();
                    for (User person in snapshot.data) {
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
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
