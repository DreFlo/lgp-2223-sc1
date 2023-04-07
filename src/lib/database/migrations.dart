import 'package:floor/floor.dart';

final allMigrations = [
  migration1to2,
  migration2to3,
  migration3to4,
  migration4to5,
  migration5to6
];

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `institution` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `picture` TEXT NOT NULL, `type` INTEGER NOT NULL, `acronym` TEXT NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `subject` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight_average` REAL NOT NULL, `institution_id` INTEGER NOT NULL, FOREIGN KEY (`institution_id`) REFERENCES `institution` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task_group` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `subject_id` INTEGER, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `task_group_id` INTEGER NOT NULL, FOREIGN KEY (`task_group_id`) REFERENCES `task_group` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `evaluation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight` REAL NOT NULL, `minimum` REAL NOT NULL, `grade` REAL NOT NULL, `subject_id` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `media` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `book` (`authors` TEXT NOT NULL, `total_pages` INTEGER NOT NULL, `progress_pages` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `series` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `video` (`duration` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `season` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `number` INTEGER NOT NULL, `series_id` INTEGER NOT NULL, FOREIGN KEY (`series_id`) REFERENCES `series` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `review` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `start_date` INTEGER NOT NULL, `end_date` INTEGER NOT NULL, `review` TEXT NOT NULL, `rating` INTEGER NOT NULL, `emoji` INTEGER NOT NULL, `media_id` INTEGER NOT NULL, FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `movie` (`duration` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `episode` (`number` INTEGER NOT NULL, `season_id` INTEGER NOT NULL, `duration` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL, FOREIGN KEY (`season_id`) REFERENCES `season` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `note` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `subject_note` (`subject_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task_note` (`task_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `episode_note` (`episode_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`episode_id`) REFERENCES `episode` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `book_note` (`startPage` INTEGER NOT NULL, `endPage` INTEGER NOT NULL, `book_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
});

final migration2to3 = Migration(2, 3, (database) async {
  await database.execute('DROP TABLE IF EXISTS `person`');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userName` TEXT NOT NULL, `password` TEXT NOT NULL, `xp` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `badge` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `imagePath` TEXT NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `mood` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `mood` INTEGER NOT NULL, `date` INTEGER NOT NULL, `user_id` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `timeslot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `media_timeslot` (`media` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `student_timeslot` (`task` INTEGER, `evaluation` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `user_badge` (`user_id` INTEGER NOT NULL, `badge_id` INTEGER NOT NULL, PRIMARY KEY (`user_id`, `badge_id`))');
});

final migration3to4 = Migration(3, 4, (database) async {
  await database.execute(
      'ALTER TABLE `institution` ADD COLUMN `user_id` INTEGER REFERENCES `user` (`id`)');
  await database.execute('PRAGMA foreign_keys = OFF;');
  await database.execute(''
      'BEGIN TRANSACTION;');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `user_badge_new` (`user_id` INTEGER NOT NULL, `badge_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, FOREIGN KEY (`badge_id`) REFERENCES `badge` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`user_id`, `badge_id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `mood_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `mood` INTEGER NOT NULL, `date` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `timeslot_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `media_timeslot_new` (`media` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`media`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `student_timeslot_new` (`task` INTEGER, `evaluation` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`task`) REFERENCES `task` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, FOREIGN KEY (`evaluation`) REFERENCES `evaluation` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database
      .execute('INSERT INTO `user_badge_new` SELECT * FROM `user_badge`');
  await database.execute('INSERT INTO `mood_new` SELECT * FROM `mood`');
  await database.execute('INSERT INTO `timeslot_new` SELECT * FROM `timeslot`');
  await database.execute(
      'INSERT INTO `media_timeslot_new` SELECT * FROM `media_timeslot`');
  await database.execute(
      'INSERT INTO `student_timeslot_new` SELECT * FROM `student_timeslot`');
  await database.execute('DROP TABLE `user_badge`');
  await database.execute('DROP TABLE `mood`');
  await database.execute('DROP TABLE `timeslot`');
  await database.execute('DROP TABLE `media_timeslot`');
  await database.execute('DROP TABLE `student_timeslot`');
  await database.execute('ALTER TABLE `user_badge_new` RENAME TO `user_badge`');
  await database.execute('ALTER TABLE `mood_new` RENAME TO `mood`');
  await database.execute('ALTER TABLE `timeslot_new` RENAME TO `timeslot`');
  await database
      .execute('ALTER TABLE `media_timeslot_new` RENAME TO `media_timeslot`');
  await database.execute(
      'ALTER TABLE `student_timeslot_new` RENAME TO `student_timeslot`');
  await database.execute('COMMIT;');
  await database.execute('PRAGMA foreign_keys = ON;');
});

final migration4to5 = Migration(4, 5, (database) async {
  // Review new
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `review_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `start_date` INTEGER NOT NULL, `end_date` INTEGER NOT NULL, `review` TEXT NOT NULL, `emoji` INTEGER NOT NULL, `media_id` INTEGER NOT NULL, FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

  await database.execute('INSERT INTO `review_new` SELECT * FROM `review`');
  //drop table review
  await database.execute('DROP TABLE `review`');
  await database.execute('ALTER TABLE `review_new` RENAME TO `review`');

  // Timeslot new
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `timeslot_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `start_datetime` INTEGER NOT NULL, `end_datetime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp_multiplier` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'INSERT INTO `timeslot_new` (`id`, `title`, `description`, `start_datetime`, `end_datetime`, `priority`, `xp_multiplier`, `user_id`) SELECT `id`, `title`, `description`, `startDateTime`, `endDateTime`, `priority`, `xp`, `user_id` FROM `timeslot`');
  // await database.execute(
  //     'INSERT INTO `timeslot_new` SELECT `id`, `title`, `description`, `startDateTime`, `endDateTime`, `priority`, `xp`, `user_id` FROM `timeslot`');
  await database.execute('DROP TABLE `timeslot`');
  await database.execute('ALTER TABLE `timeslot_new` RENAME TO `timeslot`');

  // media timeslot
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `media_timeslot_new` (`media` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `start_datetime` INTEGER NOT NULL, `end_datetime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp_multiplier` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'INSERT INTO `media_timeslot_new` (`media`, `id`, `title`, `description`, `start_datetime`, `end_datetime`, `priority`, `xp_multiplier`, `user_id`) SELECT `media`, `id`, `title`, `description`, `startDateTime`, `endDateTime`, `priority`, `xp`, `user_id` FROM `media_timeslot`');
  await database.execute('DROP TABLE `media_timeslot`');
  await database
      .execute('ALTER TABLE `media_timeslot_new` RENAME TO `media_timeslot`');

  //drop tab
  // student timeslot
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `student_timeslot_new` (`task` INTEGER, `evaluation` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `start_datetime` INTEGER NOT NULL, `end_datetime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp_multiplier` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, FOREIGN KEY (`evaluation_id`) REFERENCES `evaluation` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'INSERT INTO `student_timeslow_new` (`media`, `id`, `title`, `description`, `start_datetime`, `end_datetime`, `priority`, `xp_multiplier`, `user_id`) SELECT `media`, `id`, `title`, `description`, `startDateTime`, `endDateTime`, `priority`, `xp`, `user_id` FROM `student_timeslot`');
  //drop table student timeslot
  await database.execute('DROP TABLE `student_timeslot`');
  await database.execute(
      'ALTER TABLE `student_timeslot_new` RENAME TO `student_timeslot`');

  // task new
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `task_group_id` INTEGER NOT NULL, FOREIGN KEY (`task_group_id`) REFERENCES `task_group` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

  await database.execute('INSERT INTO `task_new` SELECT * FROM `task`');
  await database.execute('DROP TABLE `task`');
  await database.execute('ALTER TABLE `task_new` RENAME TO `task`');

  // media new
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `media_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL, `genres` TEXT NOT NULL, `release` INTEGER NOT NULL, `xp` INTEGER NOT NULL)');
  await database.execute('INSERT INTO `media_new` SELECT * FROM `media`');
  await database.execute('DROP TABLE `media`');
  await database.execute('ALTER TABLE `media_new` RENAME TO `media`');
});

final migration5to6 = Migration(5, 6, (database) async {
  await database.execute('PRAGMA foreign_keys = OFF');
  await database.execute('BEGIN TRANSACTION');

  await database.execute('''
    CREATE TRIGGER timeslot_date
    BEFORE INSERT ON timeslot
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_datetime > NEW.end_datetime THEN
          RAISE(ABORT, 'start_datetime must be before end_datetime')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER student_timeslot_date
    BEFORE INSERT ON student_timeslot
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_datetime > NEW.end_date THEN
          RAISE(ABORT, 'start_datetime must be before end_datetime')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER media_timeslot_date
    BEFORE INSERT ON media_timeslot
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_datetime > NEW.end_datetime THEN
          RAISE(ABORT, 'start_datetime must be before end_datetime')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER evaluation_grade_and_weight
    BEFORE INSERT ON evaluation
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.grade < 0 THEN
          RAISE(ABORT, 'grade must be higher or equal to 0')
        WHEN NEW.weight > 1 OR NEW.weight < 0 THEN
          RAISE(ABORT, 'weight must be between 0 and 1')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER evaluation_sum_weight
    BEFORE INSERT ON evaluation
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.weight < 0 THEN
          RAISE(ABORT, 'weight must be higher or equal to 0')
        WHEN (SELECT SUM(weight) FROM evaluation WHERE subject_id = NEW.subject_id) + NEW.weight > 1 THEN
          RAISE(ABORT, 'total weight must be between 0 and 1')
        WHEN NEW.minimum < 0 THEN
          RAISE(ABORT, 'minimum must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER student_timeslot_xor_connection
    BEFORE INSERT ON student_timeslot
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN (NEW.task_id IS NULL AND NEW.evaluation_id IS NOT NULL) OR (NEW.task_id IS NOT NULL AND ) THEN
          RAISE(ABORT, 'student_timeslot must have either a task_id or an evaluation_id')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER subject_weight_average
    BEFORE INSERT ON subject
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.weight_average < 0 THEN
          RAISE(ABORT, 'weight_average must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER task_deadline
    BEFORE INSERT ON task
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.deadline > (SELECT deadline FROM task_group WHERE id = NEW.task_group_id) THEN
          RAISE(ABORT, 'task deadline cannot be after the task group deadline')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER episode_number
    BEFORE INSERT ON episode
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.number < 0 THEN
          RAISE(ABORT, 'number must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER season_number
    BEFORE INSERT ON season
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.number < 0 THEN
          RAISE(ABORT, 'number must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER book_note
    BEFORE INSERT ON book_note_pages
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_page > NEW.end_page THEN
          RAISE(ABORT, 'end page must be higher or equal to start page')
        WHEN (SELECT total_pages FROM book WHERE id = NEW.book_id) < NEW.end_page THEN
          RAISE(ABORT, 'end page must be smaller or equal than total pages')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER book_pages
    BEFORE INSERT ON book
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.progress_pages < 0 THEN
          RAISE(ABORT, 'progress pages must be higher or equal to 0')
        WHEN NEW.total_pages < NEW.progress_pages THEN
          RAISE(ABORT, 'total pages must be higher or equal to progress pages')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER video_duration
    BEFORE INSERT ON video
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.duration < 0 THEN
          RAISE(ABORT, 'duration must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER review_date
    BEFORE INSERT ON review
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_date > NEW.end_date THEN
          RAISE(ABORT, 'start date must be before or the same as end date')
      END;
    END;
  ''');

  await database.execute('COMMIT');
  await database.execute('PRAGMA foreign_keys = ON');
});

final migration6to7 = Migration(6, 7, (database) async {
  await database.execute('PRAGMA foreign_keys = OFF');
  await database.execute('BEGIN TRANSACTION');

  await database.execute('DROP TABLE IF EXISTS institution');
  await database.execute('DROP TABLE IF EXISTS subject');
  await database.execute('DROP TABLE IF EXISTS task_group');
  await database.execute('DROP TABLE IF EXISTS task');
  await database.execute('DROP TABLE IF EXISTS evaluation');
  await database.execute('DROP TABLE IF EXISTS media');
  await database.execute('DROP TABLE IF EXISTS book');
  await database.execute('DROP TABLE IF EXISTS series');
  await database.execute('DROP TABLE IF EXISTS video');
  await database.execute('DROP TABLE IF EXISTS season');
  await database.execute('DROP TABLE IF EXISTS review');
  await database.execute('DROP TABLE IF EXISTS movie');
  await database.execute('DROP TABLE IF EXISTS episode');
  await database.execute('DROP TABLE IF EXISTS note');
  await database.execute('DROP TABLE IF EXISTS subject_note');
  await database.execute('DROP TABLE IF EXISTS task_note');
  await database.execute('DROP TABLE IF EXISTS episode_note');
  await database.execute('DROP TABLE IF EXISTS book_note');
  await database.execute('DROP TABLE IF EXISTS user');
  await database.execute('DROP TABLE IF EXISTS badge');
  await database.execute('DROP TABLE IF EXISTS mood');
  await database.execute('DROP TABLE IF EXISTS timeslot');
  await database.execute('DROP TABLE IF EXISTS media_timeslot');
  await database.execute('DROP TABLE IF EXISTS student_timeslot');
  await database.execute('DROP TABLE IF EXISTS user_badge');

  await database.execute(
      'CREATE TABLE IF NOT EXISTS `institution` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `picture` TEXT NOT NULL, `type` INTEGER NOT NULL, `acronym` TEXT NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `subject` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight_average` REAL NOT NULL, `institution_id` INTEGER NOT NULL, FOREIGN KEY (`institution_id`) REFERENCES `institution` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task_group` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `task_group_id` INTEGER NOT NULL, `subject_id` INTEGER, FOREIGN KEY (`task_group_id`) REFERENCES `task_group` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `evaluation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight` REAL NOT NULL, `minimum` REAL NOT NULL, `grade` REAL NOT NULL, `subject_id` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `media` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL, `genres` TEXT NOT NULL, `release` INTEGER NOT NULL, `xp` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `book` (`id` INTEGER NOT NULL, `authors` TEXT NOT NULL, `total_pages` INTEGER NOT NULL, `progress_pages` INTEGER, FOREIGN KEY (`id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `series` (`id` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `video` (`id` INTEGER NOT NULL, `duration` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `season` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `number` INTEGER NOT NULL, `series_id` INTEGER NOT NULL, FOREIGN KEY (`series_id`) REFERENCES `series` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `review` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `start_date` INTEGER NOT NULL, `end_date` INTEGER NOT NULL, `review` TEXT NOT NULL, `emoji` INTEGER NOT NULL, `media_id` INTEGER NOT NULL, FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `movie` (`id` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `video` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `episode` (`id` INTEGER NOT NULL, `number` INTEGER NOT NULL, `season_id` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `video` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, FOREIGN KEY (`season_id`) REFERENCES `season` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `note` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `subject_note` (`id` INTEGER NOT NULL, `subject_id` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `task_note` (`id` INTEGER NOT NULL, `task_id` INTEGER NOT NULL, FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `episode_note` (`id` INTEGER NOT NULL, `episode_id` INTEGER NOT NULL, FOREIGN KEY (`episode_id`) REFERENCES `episode` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `book_note` (`id` INTEGER NOT NULL, `start_page` INTEGER NOT NULL, `end_page` INTEGER NOT NULL, `book_id` INTEGER NOT NULL, FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_name` TEXT NOT NULL, `password` TEXT NOT NULL, `xp` INTEGER NOT NULL, `image_path` TEXT NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `badge` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `image_path` TEXT NOT NULL)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `mood` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `mood` INTEGER NOT NULL, `date` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `timeslot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `start_datetime` INTEGER NOT NULL, `end_datetime` INTEGER NOT NULL, `xp_multiplier` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `media_timeslot` (`id` INTEGER NOT NULL, `media_id` TEXT NOT NULL, FOREIGN KEY (`id`) REFERENCES `timeslot` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `student_timeslot` (`id` INTEGER NOT NULL, `task_id` TEXT NOT NULL, FOREIGN KEY (`id`) REFERENCES `timeslot` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `user_badge` (`user_id` INTEGER NOT NULL, `badge_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, FOREIGN KEY (`badge_id`) REFERENCES `badge` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`user_id`, `badge_id`))');

  await database.execute('''
    CREATE TRIGGER timeslot_date
    BEFORE INSERT ON timeslot
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_datetime > NEW.end_datetime THEN
          RAISE(ABORT, 'start_datetime must be before end_datetime')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER timeslot_date_update
    BEFORE UPDATE ON timeslot
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_datetime > NEW.end_datetime THEN
          RAISE(ABORT, 'start_datetime must be before end_datetime')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER evaluation_grade_and_weight
    BEFORE INSERT ON evaluation
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.grade < 0 THEN
          RAISE(ABORT, 'grade must be higher or equal to 0')
        WHEN NEW.weight > 1 OR NEW.weight < 0 THEN
          RAISE(ABORT, 'weight must be between 0 and 1')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER evaluation_grade_and_weight_update
    BEFORE UPDATE ON evaluation
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.grade < 0 THEN
          RAISE(ABORT, 'grade must be higher or equal to 0')
        WHEN NEW.weight > 1 OR NEW.weight < 0 THEN
          RAISE(ABORT, 'weight must be between 0 and 1')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER evaluation_sum_weight
    BEFORE INSERT ON evaluation
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.weight < 0 THEN
          RAISE(ABORT, 'weight must be higher or equal to 0')
        WHEN (SELECT SUM(weight) FROM evaluation WHERE subject_id = NEW.subject_id) + NEW.weight > 1 THEN
          RAISE(ABORT, 'total weight must be between 0 and 1')
        WHEN NEW.minimum < 0 THEN
          RAISE(ABORT, 'minimum must be higher or equal to 0')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER evaluation_sum_weight_update
    BEFORE UPDATE ON evaluation
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.weight < 0 THEN
          RAISE(ABORT, 'weight must be higher or equal to 0')
        WHEN (SELECT SUM(weight) FROM evaluation WHERE subject_id = NEW.subject_id) + NEW.weight > 1 THEN
          RAISE(ABORT, 'total weight must be between 0 and 1')
        WHEN NEW.minimum < 0 THEN
          RAISE(ABORT, 'minimum must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER subject_weight_average
    BEFORE INSERT ON subject
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.weight_average < 0 THEN
          RAISE(ABORT, 'weight_average must be higher or equal to 0')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER subject_weight_average_update
    BEFORE UPDATE ON subject
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.weight_average < 0 THEN
          RAISE(ABORT, 'weight_average must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER task_deadline
    BEFORE INSERT ON task
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.deadline > (SELECT deadline FROM task_group WHERE id = NEW.task_group_id) THEN
          RAISE(ABORT, 'task deadline cannot be after the task group deadline')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER task_deadline_update
    BEFORE UPDATE ON task
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.deadline > (SELECT deadline FROM task_group WHERE id = NEW.task_group_id) THEN
          RAISE(ABORT, 'task deadline cannot be after the task group deadline')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER episode_number
    BEFORE INSERT ON episode
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.number < 0 THEN
          RAISE(ABORT, 'number must be higher or equal to 0')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER episode_number_update
    BEFORE UPDATE ON episode
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.number < 0 THEN
          RAISE(ABORT, 'number must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER season_number
    BEFORE INSERT ON season
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.number < 0 THEN
          RAISE(ABORT, 'number must be higher or equal to 0')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER season_number_update
    BEFORE UPDATE ON season
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.number < 0 THEN
          RAISE(ABORT, 'number must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER book_note_pages
    BEFORE INSERT ON book_note
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_page > NEW.end_page THEN
          RAISE(ABORT, 'end page must be higher or equal to start page')
        WHEN (SELECT total_pages FROM book WHERE id = NEW.book_id) < NEW.end_page THEN
          RAISE(ABORT, 'end page must be smaller or equal than total pages')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER book_note_pages_update
    BEFORE UPDATE ON book_note
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_page > NEW.end_page THEN
          RAISE(ABORT, 'end page must be higher or equal to start page')
        WHEN (SELECT total_pages FROM book WHERE id = NEW.book_id) < NEW.end_page THEN
          RAISE(ABORT, 'end page must be smaller or equal than total pages')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER book_pages
    BEFORE INSERT ON book
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.progress_pages < 0 THEN
          RAISE(ABORT, 'progress pages must be higher or equal to 0')
        WHEN NEW.total_pages < NEW.progress_pages THEN
          RAISE(ABORT, 'total pages must be higher or equal to progress pages')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER book_pages_update
    BEFORE UPDATE ON book
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.progress_pages < 0 THEN
          RAISE(ABORT, 'progress pages must be higher or equal to 0')
        WHEN NEW.total_pages < NEW.progress_pages THEN
          RAISE(ABORT, 'total pages must be higher or equal to progress pages')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER video_duration
    BEFORE INSERT ON video
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.duration < 0 THEN
          RAISE(ABORT, 'duration must be higher or equal to 0')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER video_duration_update
    BEFORE UPDATE ON video
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.duration < 0 THEN
          RAISE(ABORT, 'duration must be higher or equal to 0')
      END;
    END;
  ''');

  await database.execute('''
    CREATE TRIGGER review_date
    BEFORE INSERT ON review
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_date > NEW.end_date THEN
          RAISE(ABORT, 'start date must be before or the same as end date')
      END;
    END;
  ''');
  await database.execute('''
    CREATE TRIGGER review_date_update
    BEFORE UPDATE ON review
    FOR EACH ROW
    BEGIN
      SELECT CASE
        WHEN NEW.start_date > NEW.end_date THEN
          RAISE(ABORT, 'start date must be before or the same as end date')
      END;
    END;
  ''');

  await database.execute('COMMIT');
  await database.execute('PRAGMA foreign_keys = ON');
});
