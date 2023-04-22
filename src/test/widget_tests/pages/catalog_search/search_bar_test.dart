import '../../widget_tests_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/utils/service_locator.dart';
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
  testWidgets('SearchBar widget should call onSearch with the entered text',
      (WidgetTester tester) async {
    String searchedText = '';

    await tester.pumpWidget(LocalizationsInjector(
      child: SearchBar(
        onSearch: (text) {
          searchedText = text;
        },
      ),
    ));

    // Enter text into the search bar
    await tester.enterText(find.byType(TextField), 'test search');

    // Submit the search
    await tester.testTextInput.receiveAction(TextInputAction.search);

    // Verify that onSearch was called with the entered text
    expect(searchedText, equals('test search'));
  });
}
