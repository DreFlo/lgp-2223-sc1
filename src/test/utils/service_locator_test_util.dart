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

  serviceLocator.registerSingletonWithDependencies<PersonDao>(
      () => MockPersonDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<InstitutionDao>(
      () => MockInstitutionDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SubjectDao>(
      () => MockSubjectDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskGroupDao>(
      () => MockTaskGroupDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskDao>(() => MockTaskDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<NoteDao>(() => MockNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<EvaluationDao>(
      () => MockEvaluationDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaDao>(
      () => MockMediaDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<VideoDao>(
      () => MockVideoDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SeriesDao>(
      () => MockSeriesDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<BookDao>(() => MockBookDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SeasonDao>(
      () => MockSeasonDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<ReviewDao>(
      () => MockReviewDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<EpisodeDao>(
      () => MockEpisodeDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MovieDao>(
      () => MockMovieDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<BookNoteDao>(
      () => MockBookNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<EpisodeNoteDao>(
      () => MockEpisodeNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskNoteDao>(
      () => MockTaskNoteDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SubjectNoteDao>(
      () => MockSubjectNoteDao(),
      dependsOn: [AppDatabase]);
}

void setupServiceLocatorUnitTests() {
  serviceLocator.registerSingletonAsync<AppDatabase>(() async =>
      await $FloorAppDatabase
          .inMemoryDatabaseBuilder()
          .addCallback(callback)
          .build());

  serviceLocator.registerSingletonWithDependencies<PersonDao>(
      () => serviceLocator.get<AppDatabase>().personDao,
      dependsOn: [AppDatabase]);
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
  serviceLocator.registerSingletonWithDependencies<EpisodeDao>(
      () => serviceLocator.get<AppDatabase>().episodeDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MovieDao>(
      () => serviceLocator.get<AppDatabase>().movieDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<BookNoteDao>(
      () => serviceLocator.get<AppDatabase>().bookNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<EpisodeNoteDao>(
      () => serviceLocator.get<AppDatabase>().episodeNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskNoteDao>(
      () => serviceLocator.get<AppDatabase>().taskNoteDao,
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<SubjectNoteDao>(
      () => serviceLocator.get<AppDatabase>().subjectNoteDao,
      dependsOn: [AppDatabase]);
}
