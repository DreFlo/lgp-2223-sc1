import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/pages/notes/task_note_show.dart';
import 'package:src/utils/service_locator.dart';
import '../../../utils/service_locator_test_util.dart';
import '../../widget_tests_utils.dart';
import 'package:src/models/notes/note.dart';

void func(Note note) {}

void main() {
  int taskId = 1;
  int noteId = 1;
  String noteTitle = 'note_title';
  String noteContent = 'note_content';
  DateTime noteDate = DateTime.now();
  Note note = Note(
    id: noteId,
    title: noteTitle,
    content: noteContent,
    date: noteDate,
  );
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('Load correct task note information test',
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(LocalizationsInjector(
      child: TaskNoteShow(note: note, taskId: taskId),
    ));

    await widgetTester.pumpAndSettle();

    expect(find.text(noteTitle), findsOneWidget);
    expect(find.text(noteContent), findsOneWidget);

    expect(find.byKey(const Key('taskNoteEditButton')), findsOneWidget);
  });
}
