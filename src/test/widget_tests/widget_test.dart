// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/catalog_search/leisure_module.dart';
import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/search_bar.dart';
import 'package:src/pages/catalog_search/leisure_module/search.dart';

import '../utils/service_locator_test_util.dart';

class LocalizationsInjector extends StatelessWidget {
  final Widget child;
  const LocalizationsInjector({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Material(child: child),
    );
  }
}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  /*testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final mockPersonDao = serviceLocator.get<PersonDao>();
    when(mockPersonDao.findAllPersons()).thenAnswer((_) async => []);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    await tester.pump(const Duration(seconds: 10));
    //
    // // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    //
    // // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(const Duration(seconds: 10));
    //
    // // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/

  testWidgets('LeisureModule displays two tabs and a search bar', (WidgetTester tester) async {
    // Build the LeisureModule widget
    await tester.pumpWidget(const LocalizationsInjector(child: LeisureModule()));

    // Verify that the widget displays two tabs
    expect(find.text('My Media'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);

    // Tap the "Discover" tab and wait for the widget to rebuild
    await tester.tap(find.text('Discover'));
    await tester.pump();

    // Verify that the widget displays a search bar
    expect(find.widgetWithIcon(SearchBar, Icons.search), findsOneWidget);
  });

  testWidgets('SearchMedia widget displays splash screen and tabs', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const LocalizationsInjector(child: SearchMedia(search: 'test')));

    // Verify that the splash screen is displayed
    expect(find.byType(Image), findsOneWidget);

    // Wait for the splash screen to disappear
    //await tester.pump(const Duration(seconds: 2));

    // Verify that the tabs are displayed
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Shows'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
  });
}
