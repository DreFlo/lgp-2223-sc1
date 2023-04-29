import 'dart:async';
import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/models/badge.dart';
import 'package:src/models/mood.dart';
import 'package:src/models/timeslot/media_media_timeslot.dart';
import 'package:src/models/timeslot/media_timeslot.dart';
import 'package:src/models/timeslot/task_student_timeslot.dart';
import 'package:src/models/timeslot/student_timeslot.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/user.dart';
import 'package:src/models/user_badge.dart';
import 'package:src/utils/type_converters.dart';
import 'package:src/utils/enums.dart';

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

import 'package:src/daos/badge_dao.dart';
import 'package:src/daos/mood_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/daos/timeslot/media_timeslot_dao.dart';
import 'package:src/daos/timeslot/student_timeslot_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/daos/user_dao.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter, ListConverter])
@Database(version: 2, entities: [
  Institution,
  Subject,
  TaskGroup,
  Task,
  StudentEvaluation,
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
  User,
  Badge,
  Mood,
  Timeslot,
  MediaTimeslot,
  StudentTimeslot,
  UserBadge,
  MediaMediaTimeslot,
  TaskStudentTimeslot,
])
abstract class AppDatabase extends FloorDatabase {
  InstitutionDao get institutionDao;
  SubjectDao get subjectDao;
  TaskGroupDao get taskGroupDao;
  TaskDao get taskDao;
  StudentEvaluationDao get evaluationDao;

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

  UserBadgeDao get userBadgeDao;
  BadgeDao get badgeDao;
  MoodDao get moodDao;
  TimeslotDao get timeslotDao;
  MediaTimeslotDao get mediaTimeslotDao;
  StudentTimeslotDao get studentTimeslotDao;
  UserDao get userDao;
  TaskStudentTimeslotDao get taskStudentTimeslotDao;
  MediaMediaTimeslotDao get mediaMediaTimeslotDao;
}
