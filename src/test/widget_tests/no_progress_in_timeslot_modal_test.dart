// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/locations_injector.dart';
import 'package:src/pages/gamification/no_progress_in_timeslot_modal.dart';

void disableOverflowErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final isOverflowError = exception is FlutterError &&
        !exception.diagnostics.any(
            (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));

    if (isOverflowError) {
      print(details);
    } else {
      FlutterError.presentError(details);
    }
  };
}

void main() {
  group('NoProgressInTimeslotModal widget', () {
    testWidgets('should display text and a button',
        (WidgetTester tester) async {
      disableOverflowErrors();

      await tester.pumpWidget(Wrap(children: [
        LocalizationsInjector(child: NoProgressInTimeslotModal())
      ]));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Everyone has bad days!'), findsOneWidget);
      expect(
          find.text(
              "Even if you didn't complete any tasks\ntoday, Emil is still very proud of you!"),
          findsOneWidget);
      expect(find.text("Tomorrow is a new day,\nyou'll get to try again!"),
          findsOneWidget);
    });
  });
}
