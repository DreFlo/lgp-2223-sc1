import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:src/daos/media/media_video_super_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/database/database.dart';
import 'package:src/database/migrations.dart';

import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';

import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/daos/notes/subject_note_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/daos/notes/book_note_dao.dart';

import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/daos/media/season_dao.dart';

import 'package:src/daos/timeslot/media_timeslot_dao.dart';
import 'package:src/daos/timeslot/student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';

import 'package:src/daos/badge_dao.dart';
import 'package:src/daos/mood_dao.dart';
import 'package:src/daos/user_dao.dart';

import 'package:src/database/callbacks.dart';

final GetIt serviceLocator = GetIt.instance;

/// Setup the GetIt service locator
/// Used to register singleton variables
/// Add any singleton variables here
void setup() {
  serviceLocator.registerSingletonAsync<AppDatabase>(() async =>
      await $FloorAppDatabase
          .databaseBuilder('wokka_database.db')
          .addMigrations([])
          .addCallback(addConstraintsCallback)
          .build());

  serviceLocator.registerSingletonWithDependencies<InstitutionDao>(
      () => serviceLocator.get<AppDatabase>().institutionDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SubjectDao>(
      () => serviceLocator.get<AppDatabase>().subjectDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskGroupDao>(
      () => serviceLocator.get<AppDatabase>().taskGroupDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskDao>(
      () => serviceLocator.get<AppDatabase>().taskDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<NoteDao>(
      () => serviceLocator.get<AppDatabase>().noteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<EvaluationDao>(
      () => serviceLocator.get<AppDatabase>().evaluationDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaDao>(
      () => serviceLocator.get<AppDatabase>().mediaDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<VideoDao>(
      () => serviceLocator.get<AppDatabase>().videoDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SeriesDao>(
      () => serviceLocator.get<AppDatabase>().seriesDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<BookDao>(
      () => serviceLocator.get<AppDatabase>().bookDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SeasonDao>(
      () => serviceLocator.get<AppDatabase>().seasonDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<ReviewDao>(
      () => serviceLocator.get<AppDatabase>().reviewDao,
      dependsOn: [AppDatabase]);
  // serviceLocator.registerSingletonWithDependencies<EpisodeDao>(
  //     () => serviceLocator.get<AppDatabase>().episodeDao,
  //     dependsOn: [AppDatabase]);
  // serviceLocator.registerSingletonWithDependencies<MovieDao>(
  //     () => serviceLocator.get<AppDatabase>().movieDao,
  //     dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<BookNoteDao>(
      () => serviceLocator.get<AppDatabase>().bookNoteDao,
      dependsOn: [AppDatabase]);
  // serviceLocator.registerSingletonWithDependencies<EpisodeNoteDao>(
  //     () => serviceLocator.get<AppDatabase>().episodeNoteDao,
  //     dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskNoteDao>(
      () => serviceLocator.get<AppDatabase>().taskNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SubjectNoteDao>(
      () => serviceLocator.get<AppDatabase>().subjectNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<UserDao>(
      () => serviceLocator.get<AppDatabase>().userDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<BadgeDao>(
      () => serviceLocator.get<AppDatabase>().badgeDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MoodDao>(
      () => serviceLocator.get<AppDatabase>().moodDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaTimeslotDao>(
      () => serviceLocator.get<AppDatabase>().mediaTimeslotDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TimeslotDao>(
      () => serviceLocator.get<AppDatabase>().timeslotDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<StudentTimeslotDao>(
      () => serviceLocator.get<AppDatabase>().studentTimeslotDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<UserBadgeDao>(
      () => serviceLocator.get<AppDatabase>().userBadgeDao,
      dependsOn: [AppDatabase]);

  // SuperDAOs
  serviceLocator.registerSingletonWithDependencies<MediaVideoSuperDao>(
          () => mediaVideoSuperDao,
      dependsOn: [AppDatabase]);
}
