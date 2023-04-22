import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/pages/gamification/progress_in_timeslot_modal.dart';
import 'package:src/utils/enums.dart';
import '../utils/locations_injector.dart';

void disableOverflowErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final isOverflowError = exception is FlutterError &&
        !exception.diagnostics.any(
            (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));

    if (isOverflowError) {
      //print(details);
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

      await tester.pumpWidget(const LocalizationsInjector(
          child: ProgressInTimeslotModal(
              taskCount: 10,
              finishedTaskCount: 5,
              modules: [Module.leisure, Module.student])));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text("Emil is incredibly proud!\nKeep up the good work!"),
          findsOneWidget);
      expect(find.text("5 tasks"), findsOneWidget);
      expect(find.text("out of 10 tasks planned!"), findsOneWidget);
    });
  });
}
