import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/service_locator.dart';

import 'flavors.dart';
import 'pages/my_home_page.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(108, 93, 211, .1),
  100: Color.fromRGBO(108, 93, 211, .2),
  200: Color.fromRGBO(108, 93, 211, .3),
  300: Color.fromRGBO(108, 93, 211, .4),
  400: Color.fromRGBO(108, 93, 211, .5),
  500: Color.fromRGBO(108, 93, 211, .6),
  600: Color.fromRGBO(108, 93, 211, .7),
  700: Color.fromRGBO(108, 93, 211, .8),
  800: Color.fromRGBO(108, 93, 211, .9),
  900: Color.fromRGBO(108, 93, 211, 1),
};

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: serviceLocator.allReady(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: F.title,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
                fontFamily: 'Poppins',
                primarySwatch: MaterialColor(0xFF6C5DD3, color),
                scaffoldBackgroundColor: Color(0xFF181A20),
                textTheme: const TextTheme(
                  displayMedium: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF71788D),
                      fontWeight: FontWeight.w400
                  ),
                  headlineMedium: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  titleLarge: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                  titleMedium: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  titleSmall: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  bodyMedium: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                  displaySmall: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  bodySmall: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal
                  )
                )),
            home: Scaffold(
              body: Center(
                child: MyHomePage(title: F.title),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
