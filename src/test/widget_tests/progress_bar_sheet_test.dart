import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/pages/gamification/progress_bar_sheet.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/user.dart';

import '../utils/locations_injector.dart';
import '../utils/service_locator_test_util.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });
  group('ProgressBarSheet', () {
    late LocalizationsInjector progressBarSheet;

    setUp(() {
      User userTest = User(
          name: 'test_user',
          imagePath: 'assets/images/no_image.jpg',
          level: 1,
          xp: 100,
          email: 'test@gmail.com',
          password: 'test',
          id: 1);
      progressBarSheet =
          LocalizationsInjector(child: ProgressBarSheet(user: userTest));
    });

    testWidgets('displays the user name', (WidgetTester tester) async {
      //Mock data

      final mockMediaDao = serviceLocator.get<MediaDao>();
      when(mockMediaDao.countAllMedia()).thenAnswer((_) async => 8);
      when(mockMediaDao.countFavoriteMedia(true)).thenAnswer((_) async => 2);

      final mockTaskDao = serviceLocator.get<TaskDao>();
      when(mockTaskDao.countFinishedTaskGroups(true))
          .thenAnswer((_) async => 8);
      when(mockTaskDao.countFinishedTasks(true)).thenAnswer((_) async => 2);

      await tester.pumpWidget(progressBarSheet);
      final nameFinder = find.text('test_user');
      expect(nameFinder, findsOneWidget);
      final levelFinder = find.text('LEVEL 1');
      expect(levelFinder, findsOneWidget);
    });
  });
}
