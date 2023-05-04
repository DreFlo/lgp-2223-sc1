import 'package:mockito/annotations.dart';
import 'package:src/daos/badge_dao.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/daos/mood_dao.dart';
import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/note_episode_note_super_dao.dart';
import 'package:src/daos/notes/note_subject_note_super_dao.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/daos/notes/subject_note_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/media_timeslot_dao.dart';
import 'package:src/daos/timeslot/student_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/database/database.dart';
import 'package:src/utils/service_locator.dart';

import 'service_locator_test_util.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppDatabase>(),
  MockSpec<InstitutionDao>(),
  MockSpec<SubjectDao>(),
  MockSpec<TaskGroupDao>(),
  MockSpec<TaskDao>(),
  MockSpec<NoteDao>(),
  MockSpec<StudentEvaluationDao>(),
  MockSpec<MediaDao>(),
  MockSpec<VideoDao>(),
  MockSpec<SeriesDao>(),
  MockSpec<BookDao>(),
  MockSpec<SeasonDao>(),
  MockSpec<ReviewDao>(),
  MockSpec<EpisodeDao>(),
  MockSpec<MovieDao>(),
  MockSpec<BookNoteDao>(),
  MockSpec<EpisodeNoteDao>(),
  MockSpec<TaskNoteDao>(),
  MockSpec<SubjectNoteDao>(),
  MockSpec<TimeslotDao>(),
  MockSpec<MediaTimeslotDao>(),
  MockSpec<StudentTimeslotDao>(),
  MockSpec<BadgeDao>(),
  MockSpec<MoodDao>(),
  MockSpec<UserBadgeDao>(),
  MockSpec<UserDao>(),
  MockSpec<MediaVideoEpisodeSuperDao>(),
  MockSpec<MediaVideoMovieSuperDao>(),
  MockSpec<NoteBookNoteSuperDao>(),
  MockSpec<NoteSubjectNoteSuperDao>(),
  MockSpec<NoteTaskNoteSuperDao>(),
  MockSpec<NoteEpisodeNoteSuperDao>(),
  MockSpec<MediaBookSuperDao>(),
  MockSpec<MediaSeriesSuperDao>(),
  MockSpec<TimeslotMediaTimeslotSuperDao>(),
  MockSpec<TimeslotStudentTimeslotSuperDao>(),
  MockSpec<MediaMediaTimeslotDao>(),
  MockSpec<TaskStudentTimeslotDao>(),
])
void setupMockServiceLocatorUnitTests() {
  serviceLocator
      .registerSingletonAsync<AppDatabase>(() async => MockAppDatabase());

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
  serviceLocator.registerSingletonWithDependencies<StudentEvaluationDao>(
      () => MockStudentEvaluationDao(),
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
  serviceLocator.registerSingletonWithDependencies<TimeslotDao>(
      () => MockTimeslotDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaTimeslotDao>(
      () => MockMediaTimeslotDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<StudentTimeslotDao>(
      () => MockStudentTimeslotDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<BadgeDao>(
      () => MockBadgeDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MoodDao>(() => MockMoodDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<UserBadgeDao>(
      () => MockUserBadgeDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<UserDao>(() => MockUserDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaMediaTimeslotDao>(
      () => MockMediaMediaTimeslotDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<TaskStudentTimeslotDao>(
      () => MockTaskStudentTimeslotDao(),
      dependsOn: [AppDatabase]);

  // Super DAOs
  serviceLocator.registerSingletonWithDependencies<MediaVideoEpisodeSuperDao>(
      () => MockMediaVideoEpisodeSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaVideoMovieSuperDao>(
      () => MockMediaVideoMovieSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<NoteBookNoteSuperDao>(
      () => MockNoteBookNoteSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<NoteSubjectNoteSuperDao>(
      () => MockNoteSubjectNoteSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<NoteTaskNoteSuperDao>(
      () => MockNoteTaskNoteSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<NoteEpisodeNoteSuperDao>(
      () => MockNoteEpisodeNoteSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaBookSuperDao>(
      () => MockMediaBookSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator.registerSingletonWithDependencies<MediaSeriesSuperDao>(
      () => MockMediaSeriesSuperDao(),
      dependsOn: [AppDatabase]);
  serviceLocator
      .registerSingletonWithDependencies<TimeslotMediaTimeslotSuperDao>(
          () => MockTimeslotMediaTimeslotSuperDao(),
          dependsOn: [AppDatabase]);
  serviceLocator
      .registerSingletonWithDependencies<TimeslotStudentTimeslotSuperDao>(
          () => MockTimeslotStudentTimeslotSuperDao(),
          dependsOn: [AppDatabase]);
}
