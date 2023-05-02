import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/pages/gamification/student_timeslot_finished_modal.dart';
import 'package:src/utils/enums.dart';

import '../utils/locations_injector.dart';

class MockImagePicker extends Mock implements ImagePicker {}

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
  group('TimeslotFinishedModal', () {
    late LocalizationsInjector timeslotFinishedModal;

    testWidgets('displays text', (WidgetTester tester) async {
      disableOverflowErrors();
      timeslotFinishedModal = LocalizationsInjector(
          child: TimeslotFinishedModal(
              tasks: [
            Task(
                id: 1,
                name: "Hello",
                description: "World",
                finished: true,
                xp: 1,
                priority: Priority.high,
                deadline: DateTime.now())
          ],
              timeslot: TimeslotStudentTimeslotSuperEntity(
                title: "Hello",
                description: "World",
                startDateTime: DateTime.now(),
                endDateTime: DateTime.now(),
                id: 1,
                finished: true,
                userId: 1,
                xpMultiplier: 1,
              )));
      await tester.pumpWidget(timeslotFinishedModal);

      expect(find.text('The event...'), findsOneWidget);
      expect(find.text('...has finished!'), findsOneWidget);
      expect(
          find.text(
              "Here are the tasks you had planned to finish.\nMark the ones you finished!"),
          findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    // testWidgets('displays task', (WidgetTester tester) async {
    //   disableOverflowErrors();
    //   timeslotFinishedModal = LocalizationsInjector(
    //       child: TimeslotFinishedModal(
    //           tasks: [
    //         Task(
    //             id: 1,
    //             name: "Hello",
    //             description: "World",
    //             finished: true,
    //             xp: 1,
    //             priority: Priority.high,
    //             deadline: DateTime.now())
    //       ],
    //           timeslot: Timeslot(
    //             title: "Hello",
    //             description: "World",
    //             startDateTime: DateTime.now(),
    //             endDateTime: DateTime.now(),
    //             id: 1,
    //             finished: true,
    //             userId: 1,
    //             xpMultiplier: 1,
    //           )));

    //   await tester.pumpWidget(timeslotFinishedModal);
    //   tester.pumpAndSettle();
    //   expect(find.byType(TaskBar), findsOneWidget);
    // });
  });
}
