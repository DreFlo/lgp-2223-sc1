import 'package:floor/floor.dart';

final List<Migration> allMigrations = [migration1to2];

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `series_new` (`id` INTEGER NOT NULL, `tagline` TEXT NOT NULL, `number_seasons` INTEGER NOT NULL, `number_episodes` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute('INSERT INTO `series_new` SELECT * FROM `series`');
  await database.execute('DROP TABLE `series`');
  await database.execute('ALTER TABLE `series_new` RENAME TO `series`');
});
