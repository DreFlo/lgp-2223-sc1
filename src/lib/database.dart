import 'dart:async';
import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:src/utils/type_converters.dart';
import 'package:src/utils/enums.dart';

import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';

import 'package:src/daos/student/institution_dao.dart';
import 'package:src/models/student/institution.dart';

import 'package:src/daos/student/subject_dao.dart';
import 'package:src/models/student/subject.dart';

import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/task_group.dart';

import 'package:src/daos/student/task_dao.dart';
import 'package:src/models/student/task.dart';

import 'package:src/daos/notes/note_dao.dart';
import 'package:src/models/notes/note.dart';

import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/models/student/evaluation.dart';

import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media.dart';

import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/media/video.dart';

import 'package:src/daos/media/series_dao.dart';
import 'package:src/models/media/series.dart';

import 'package:src/daos/media/book_dao.dart';
import 'package:src/models/media/book.dart';

import 'package:src/daos/media/season_dao.dart';
import 'package:src/models/media/season.dart';

import 'package:src/daos/media/review_dao.dart';
import 'package:src/models/media/review.dart';

import 'package:src/daos/media/episode_dao.dart';
import 'package:src/models/media/episode.dart';

import 'package:src/daos/media/movie_dao.dart';
import 'package:src/models/media/movie.dart';

import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/models/notes/book_note.dart';

import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/models/notes/episode_note.dart';

import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/models/notes/task_note.dart';

import 'package:src/daos/notes/subject_note_dao.dart';
import 'package:src/models/notes/subject_note.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 2, entities: [
  Person,
  Institution,
  Subject,
  TaskGroup,
  Task,
  Evaluation,
  Media,
  Book,
  Series,
  Video,
  Season,
  Review,
  Movie,
  Episode,
  Note,
  SubjectNote,
  TaskNote,
  EpisodeNote,
  BookNote,
])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;

  InstitutionDao get institutionDao;
  SubjectDao get subjectDao;
  TaskGroupDao get taskGroupDao;
  TaskDao get taskDao;
  EvaluationDao get evaluationDao;

  MediaDao get mediaDao;
  BookDao get bookDao;
  SeriesDao get seriesDao;
  VideoDao get videoDao;
  SeasonDao get seasonDao;
  ReviewDao get reviewDao;
  MovieDao get movieDao;
  EpisodeDao get episodeDao;

  NoteDao get noteDao;
  SubjectNoteDao get subjectNoteDao;
  TaskNoteDao get taskNoteDao;
  EpisodeNoteDao get episodeNoteDao;
  BookNoteDao get bookNoteDao;
}

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
