import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/service_locator.dart';

import 'flavors.dart';
import 'pages/my_home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: F.title,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (context, widget) {
          return FutureBuilder(
              future: serviceLocator.allReady(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (context) => Scaffold(
                          body: Center(
                            child: MyHomePage(title: F.title),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              });
        });
  }
}
