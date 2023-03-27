import 'package:mockito/annotations.dart';

import 'package:src/daos/person_dao.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/subject_note_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';

import 'package:src/database.dart';
import 'package:src/utils/service_locator.dart';

import 'service_locator_test_util.mocks.dart';

@GenerateMocks([
  AppDatabase,
  PersonDao,
  InstitutionDao,
  SubjectDao,
  TaskGroupDao,
  TaskDao,
  NoteDao,
  EvaluationDao,
  MediaDao,
  VideoDao,
  SeriesDao,
  BookDao,
  SeasonDao,
  ReviewDao,
  EpisodeDao,
  MovieDao,
  BookNoteDao,
  EpisodeNoteDao,
  TaskNoteDao,
  SubjectNoteDao
])
void setupMockServiceLocatorUnitTests() {
  serviceLocator
      .registerSingletonAsync<AppDatabase>(() async => MockAppDatabase());

  serviceLocator.registerSingletonAsync<PersonDao>(() async => MockPersonDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<InstitutionDao>(
      () async => MockInstitutionDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SubjectDao>(
      () async => MockSubjectDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<TaskGroupDao>(
      () async => MockTaskGroupDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<TaskDao>(() async => MockTaskDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<NoteDao>(() async => MockNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<EvaluationDao>(
      () async => MockEvaluationDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<MediaDao>(() async => MockMediaDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<VideoDao>(() async => MockVideoDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SeriesDao>(() async => MockSeriesDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<BookDao>(() async => MockBookDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SeasonDao>(() async => MockSeasonDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<ReviewDao>(() async => MockReviewDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<EpisodeDao>(
      () async => MockEpisodeDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<MovieDao>(() async => MockMovieDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<BookNoteDao>(
      () async => MockBookNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<EpisodeNoteDao>(
      () async => MockEpisodeNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<TaskNoteDao>(
      () async => MockTaskNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SubjectNoteDao>(
      () async => MockSubjectNoteDao(),
      dependsOn: [AppDatabase]);
}

void setupServiceLocatorUnitTests() {
  serviceLocator.registerSingletonAsync<AppDatabase>(() async =>
      await $FloorAppDatabase
          .inMemoryDatabaseBuilder()
          .addCallback(callback)
          .build());

  serviceLocator.registerSingletonAsync<PersonDao>(
      () async => serviceLocator.get<AppDatabase>().personDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<InstitutionDao>(
      () async => serviceLocator.get<AppDatabase>().institutionDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SubjectDao>(
      () async => serviceLocator.get<AppDatabase>().subjectDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<TaskGroupDao>(
      () async => serviceLocator.get<AppDatabase>().taskGroupDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<TaskDao>(
      () async => serviceLocator.get<AppDatabase>().taskDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<NoteDao>(
      () async => serviceLocator.get<AppDatabase>().noteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<EvaluationDao>(
      () async => serviceLocator.get<AppDatabase>().evaluationDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<MediaDao>(
      () async => serviceLocator.get<AppDatabase>().mediaDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<VideoDao>(
      () async => serviceLocator.get<AppDatabase>().videoDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SeriesDao>(
      () async => serviceLocator.get<AppDatabase>().seriesDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<BookDao>(
      () async => serviceLocator.get<AppDatabase>().bookDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SeasonDao>(
      () async => serviceLocator.get<AppDatabase>().seasonDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<ReviewDao>(
      () async => serviceLocator.get<AppDatabase>().reviewDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<EpisodeDao>(
      () async => serviceLocator.get<AppDatabase>().episodeDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<MovieDao>(
      () async => serviceLocator.get<AppDatabase>().movieDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<BookNoteDao>(
      () async => serviceLocator.get<AppDatabase>().bookNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<EpisodeNoteDao>(
      () async => serviceLocator.get<AppDatabase>().episodeNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<TaskNoteDao>(
      () async => serviceLocator.get<AppDatabase>().taskNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonAsync<SubjectNoteDao>(
      () async => serviceLocator.get<AppDatabase>().subjectNoteDao,
      dependsOn: [AppDatabase]);
}
