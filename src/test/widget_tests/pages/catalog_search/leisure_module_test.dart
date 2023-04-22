import '../../widget_tests_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/catalog_search/leisure_module.dart';
import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/search_bar.dart';


import '../../../utils/service_locator_test_util.dart';
void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('LeisureModule displays two tabs and a search bar',
      (WidgetTester tester) async {
    // Build the LeisureModule widget
    await tester
        .pumpWidget(const LocalizationsInjector(child: LeisureModule()));

    // Verify that the widget displays two tabs
    expect(find.text('My Media'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);

    // Tap the "Discover" tab and wait for the widget to rebuild
    await tester.tap(find.text('Discover'));
    await tester.pump();

    // Verify that the widget displays a search bar
    expect(find.widgetWithIcon(SearchBar, Icons.search), findsOneWidget);
  });
}
