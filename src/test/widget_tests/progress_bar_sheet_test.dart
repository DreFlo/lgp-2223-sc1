import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:src/pages/gamification/progress_bar_sheet.dart';

import '../utils/locations_injector.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  group('ProgressBarSheet', () {
    late LocalizationsInjector progressBarSheet;
    late MockImagePicker mockImagePicker;

    setUp(() {
      mockImagePicker = MockImagePicker();
      progressBarSheet = const LocalizationsInjector(
          child: ProgressBarSheet(
        user: ['test_user', '50'],
        image: 'test_image',
        level: 1,
      ));
    });

    testWidgets('displays the user name', (WidgetTester tester) async {
      await tester.pumpWidget(progressBarSheet);
      final nameFinder = find.text('test_user');
      expect(nameFinder, findsOneWidget);
    });

    testWidgets('displays the level', (WidgetTester tester) async {
      await tester.pumpWidget(progressBarSheet);
      final levelFinder = find.text('LEVEL 1');
      expect(levelFinder, findsOneWidget);
    });
  });
}
