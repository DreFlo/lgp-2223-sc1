import 'package:get_it/get_it.dart';
import 'package:src/daos/badge_dao.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/daos/mood_dao.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'package:src/daos/notes/note_episode_note_super_dao.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/daos/notes/note_subject_note_super_dao.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/daos/user_dao.dart';

import 'package:src/utils/mock_data/data.dart';

Future<void> seedDatabase(GetIt serviceLocator) async {
  await serviceLocator<UserDao>().insertUsers(mockUsers);
  await serviceLocator<BadgeDao>().insertBadges(mockBadges);
  await serviceLocator<UserBadgeDao>().insertUserBadges(mockUserBadges);
  await serviceLocator<MoodDao>().insertMoods(mockMoods);

  await serviceLocator<MediaSeriesSuperDao>()
      .insertMediaSeriesSuperEntities(mockSeries);
  await serviceLocator<SeasonDao>().insertSeasons(mockSeasons);
  await serviceLocator<MediaVideoEpisodeSuperDao>()
      .insertMediaVideoEpisodeSuperEntities(mockEpisodes);
  await serviceLocator<MediaBookSuperDao>()
      .insertMediaBookSuperEntities(mockBooks);
  await serviceLocator<MediaVideoMovieSuperDao>()
      .insertMediaVideoMovieSuperEntities(mockMovies);
  await serviceLocator<ReviewDao>().insertReviews(mockReviews);

  await serviceLocator<InstitutionDao>().insertInstitutions(mockInstitutions);
  await serviceLocator<SubjectDao>().insertSubjects(mockSubjects);
  await serviceLocator<StudentEvaluationDao>()
      .insertStudentEvaluations(mockEvaluations);
  await serviceLocator<TaskGroupDao>().insertTaskGroups(mockTaskGroups);
  await serviceLocator<TaskDao>().insertTasks(mockTasks);

  await serviceLocator<TimeslotMediaTimeslotSuperDao>()
      .insertTimeslotMediaTimeslotSuperEntities(mockMediaTimeslots);
  await serviceLocator<TimeslotStudentTimeslotSuperDao>()
      .insertTimeslotStudentTimeslotSuperEntities(mockStudentTimeslots);

  await serviceLocator<NoteBookNoteSuperDao>()
      .insertNoteBookNoteSuperEntities(mockBookNotes);
  await serviceLocator<NoteEpisodeNoteSuperDao>()
      .insertNoteEpisodeNoteSuperEntities(mockEpisodeNotes);
  await serviceLocator<NoteSubjectNoteSuperDao>()
      .insertNoteSubjectNoteSuperEntities(mockSubjectNotes);
  await serviceLocator<NoteTaskNoteSuperDao>()
      .insertNoteTaskNoteSuperEntities(mockTaskNotes);
  
}
