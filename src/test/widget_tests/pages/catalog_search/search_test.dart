import '../../widget_tests_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/service_locator.dart';
import 'package:flutter/material.dart';

import 'package:src/pages/catalog_search/leisure_module/search.dart';

import '../../../utils/service_locator_test_util.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });
  testWidgets('SearchMedia widget displays splash screen and tabs',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
        const LocalizationsInjector(child: SearchMedia(search: 'test')));

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
