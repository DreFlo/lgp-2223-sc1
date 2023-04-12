import 'package:floor/floor.dart';

final List<Migration> allMigrations = [migration1to2];

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `user_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_name` TEXT NOT NULL, `password` TEXT NOT NULL, `xp` INTEGER NOT NULL, `level` INTEGER NOT NULL, `image_path` TEXT NOT NULL)');
  await database.execute('INSERT INTO `user_new` SELECT * FROM `user`');
  await database.execute('DROP TABLE `user`');
  await database.execute('ALTER TABLE `user_new` RENAME TO `user`');
});
