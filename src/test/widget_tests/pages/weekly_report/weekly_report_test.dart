import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/pages/weekly_report/weekly_report.dart';
import 'package:src/utils/service_locator.dart';

import '../../../utils/locations_injector.dart';
import '../../../utils/service_locator_test_util.dart';

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets("View weekly report - no projects", (widgetTester) async {
    await widgetTester
        .pumpWidget(const LocalizationsInjector(child: WeeklyReport()));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('mostFinishedTaskGroup')), findsNothing);
    expect(find.byKey(const Key('noProjectsThisTime')), findsOneWidget);
  });

  testWidgets("View weekly report - no notes", (widgetTester) async {
    await widgetTester
        .pumpWidget(const LocalizationsInjector(child: WeeklyReport()));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('mostFinishedTaskGroup')), findsNothing);
    expect(find.byKey(const Key('noProjectsThisTime')), findsOneWidget);
  });
}
