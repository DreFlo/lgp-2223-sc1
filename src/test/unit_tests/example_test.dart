import 'package:flutter_test/flutter_test.dart';
import 'package:src/daos/media/media_video_super_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/database/database.dart';
import 'package:src/models/media/media_video_super_entity.dart';
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/models/user.dart';

import '../utils/service_locator_test_util.dart';

void main() {
  setUp(() async {
    setupServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator<AppDatabase>().close();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>()
          .insertUser(User(userName: 'Emil', password: '1234', xp: 23));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);
    });
  });

  testWidgets('Test SuperDAO', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Just an example test to prove it works
      MediaVideoSuperEntity mediaVideoSuperEntity = MediaVideoSuperEntity(
        name: 'name',
        description: 'description',
        linkImage: 'linkImage',
        status: Status.goingThrough,
        favorite: true,
        genres: 'genres',
        release: DateTime.now(),
        xp: 23,
        duration: 23,
      );

      int id = await serviceLocator<MediaVideoSuperDao>()
          .insertMediaVideoSuperEntity(mediaVideoSuperEntity);

      expect(id, 1);

      Video video = (await serviceLocator<VideoDao>().findVideoById(id).first)!;

      expect(video.duration, 23);
    });
  });
}
