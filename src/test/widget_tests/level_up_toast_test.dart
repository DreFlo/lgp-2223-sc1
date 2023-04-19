import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:src/pages/gamification/level_up_toast.dart';

import '../utils/locations_injector.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  group('ProgressBarSheet', () {
    late LocalizationsInjector levelUpToast;
    setUp(() {
      levelUpToast = const LocalizationsInjector(
          child: LevelUpToast(level: 2, points: 20));
    });

    testWidgets('displays the level', (WidgetTester tester) async {
      await tester.pumpWidget(levelUpToast);
      final levelFinder = find.text('LEVEL UP!');
      expect(levelFinder, findsOneWidget);
    });

    testWidgets('displays the level', (WidgetTester tester) async {
      await tester.pumpWidget(levelUpToast);
      final levelFinder = find.text('LEVEL 2');
      expect(levelFinder, findsOneWidget);
    });
  });
}
