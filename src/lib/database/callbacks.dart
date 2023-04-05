import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

final unitTestPrintVersionCallback = Callback(onCreate: (database, version) {
  if (kDebugMode) {
    print('Database created - version $version');
  }
});

final addConstraintsCallback = Callback(
  onCreate: (database, version) async {
    // Add constraints to the database as triggers
    await database.execute('PRAGMA foreign_keys = OFF');
    //await database.execute('BEGIN TRANSACTION');

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
    CREATE TRIGGER timeslot_date
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
    await database.execute('''_update
    CREATE UPDATE book_note_pages
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

    //await database.execute('COMMIT');
    await database.execute('PRAGMA foreign_keys = ON');
  },
);
