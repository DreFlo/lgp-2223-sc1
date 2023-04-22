// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'pages/catalog_search/leisure_module_test.dart' as leisure_module_test;
import 'pages/catalog_search/search_bar_test.dart' as search_bar_test;
import 'pages/catalog_search/search_test.dart' as search_test;

void main() {
  leisure_module_test.main();
  search_bar_test.main();
  search_test.main();
}
