import 'package:floor/floor.dart';

final List<Migration> allMigrations = [];

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `user_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_name` TEXT NOT NULL, `password` TEXT NOT NULL, `xp` INTEGER NOT NULL, `level` INTEGER NOT NULL, `image_path` TEXT NOT NULL)');
  await database.execute('INSERT INTO `user_new` SELECT * FROM `user`');
  await database.execute('DROP TABLE `user`');
  await database.execute('ALTER TABLE `user_new` RENAME TO `user`');

  await database.execute(
      'CREATE TABLE IF NOT EXISTS `timeslot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `start_datetime` INTEGER NOT NULL, `end_datetime` INTEGER NOT NULL, `xp_multiplier` INTEGER NOT NULL, `finished` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute('INSERT INTO `timeslot_new` SELECT * FROM `timeslot`');
  await database.execute('DROP TABLE `timeslot`');
  await database.execute('ALTER TABLE `timeslot_new` RENAME TO `timeslot`');

  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `finished` INTEGER NOT NULL, `task_group_id` INTEGER NOT NULL, `subject_id` INTEGER, FOREIGN KEY (`task_group_id`) REFERENCES `task_group` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute('INSERT INTO `task_new` SELECT * FROM `task`');
  await database.execute('DROP TABLE `task`');
  await database.execute('ALTER TABLE `task_new` RENAME TO `task`');
});
