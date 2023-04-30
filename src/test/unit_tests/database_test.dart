import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/timeslot/task_student_timeslot_dao.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/database/database.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/models/media/movie.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'package:src/models/notes/note_subject_note_super_entity.dart';
import 'package:src/daos/notes/note_subject_note_super_dao.dart';
import 'package:src/models/notes/note_task_note_super_entity.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/daos/notes/note_episode_note_super_dao.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/models/media/episode.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/models/media/book.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/models/notes/book_note.dart';
import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/models/notes/episode_note.dart';
import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/models/timeslot/media_media_timeslot.dart';
import 'package:src/models/timeslot/task_student_timeslot.dart';
import 'package:src/utils/enums.dart' as enums;
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/models/user.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/models/notes/task_note.dart';
import 'package:src/models/notes/subject_note.dart';
import 'package:src/daos/notes/subject_note_dao.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/models/media/series.dart';
import 'package:src/utils/enums.dart';
import 'package:src/models/media/review.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/models/timeslot/media_timeslot.dart';
import 'package:src/models/timeslot/student_timeslot.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_media_timeslot_super_dao.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/daos/timeslot/timeslot_student_timeslot_super_dao.dart';

void main() {
  setUp(() async {
    await setup(testing: true);
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator<AppDatabase>().close();
  });

  testWidgets('Basic Database Insert Test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);
    });
  });

  testWidgets('Test SuperDAO for MediaVideoEpisode',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      MediaSeriesSuperEntity mediaSeriesSuperEntity = MediaSeriesSuperEntity(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: "Me",
          tagline: "Super Cool Test");

      int seriesId = await serviceLocator<MediaSeriesSuperDao>()
          .insertMediaSeriesSuperEntity(mediaSeriesSuperEntity);

      expect(seriesId, 1);

      Season season = Season(
        number: 1,
        seriesId: seriesId,
      );

      int seasonId = await serviceLocator<SeasonDao>().insertSeason(season);

      MediaVideoEpisodeSuperEntity mediaVideoEpisodeSuperEntity =
          MediaVideoEpisodeSuperEntity(
        name: 'name',
        description: 'description',
        linkImage: 'linkImage',
        status: Status.goingThrough,
        favorite: true,
        genres: 'genres',
        release: DateTime.now(),
        xp: 23,
        duration: 23,
        number: 1,
        seasonId: seasonId,
        participants: "Me",
      );

      int id = await serviceLocator<MediaVideoEpisodeSuperDao>()
          .insertMediaVideoEpisodeSuperEntity(mediaVideoEpisodeSuperEntity);

      expect(id, 2);

      Episode episode =
          (await serviceLocator<EpisodeDao>().findEpisodeById(id).first)!;

      expect(episode.number, 1);
    });
  });

  testWidgets('Test SuperDAO for MediaVideoMovie', (WidgetTester tester) async {
    await tester.runAsync(() async {
      MediaVideoMovieSuperEntity mediaVideoMovieSuperEntity =
          MediaVideoMovieSuperEntity(
              name: 'name',
              description: 'description',
              linkImage: 'linkImage',
              status: Status.goingThrough,
              favorite: true,
              genres: 'genres',
              release: DateTime.now(),
              xp: 23,
              duration: 23,
              participants: "Me",
              tagline: "Super Cool Test");

      int id = await serviceLocator<MediaVideoMovieSuperDao>()
          .insertMediaVideoMovieSuperEntity(mediaVideoMovieSuperEntity);

      expect(id, 1);

      Movie movie = (await serviceLocator<MovieDao>().findMovieById(id).first)!;

      expect(movie.id, 1);
    });
  });

  testWidgets('Test SuperDAO for MediaBook', (WidgetTester tester) async {
    await tester.runAsync(() async {
      MediaBookSuperEntity mediaBookSuperEntity = MediaBookSuperEntity(
        name: 'name',
        description: 'description',
        linkImage: 'linkImage',
        status: Status.goingThrough,
        favorite: true,
        genres: 'genres',
        release: DateTime.now(),
        xp: 23,
        participants: 'Me',
        totalPages: 23,
      );

      int id = await serviceLocator<MediaBookSuperDao>()
          .insertMediaBookSuperEntity(mediaBookSuperEntity);

      expect(id, 1);

      Book book = (await serviceLocator<BookDao>().findBookById(id).first)!;

      expect(book.id, 1);
    });
  });

  testWidgets('Test SuperDAO for Note/BookNote', (WidgetTester tester) async {
    await tester.runAsync(() async {
      int bookId = await serviceLocator<MediaDao>().insertMedia(Media(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: 'Me'));

      await serviceLocator<BookDao>()
          .insertBook(Book(id: bookId, totalPages: 23, progressPages: 0));

      NoteBookNoteSuperEntity noteBookNoteSuperEntity = NoteBookNoteSuperEntity(
          title: 'Note 1',
          content: 'Content 1',
          date: DateTime.now(),
          startPage: 1,
          endPage: 2,
          bookId: 1);

      int id = await serviceLocator<NoteBookNoteSuperDao>()
          .insertNoteBookNoteSuperEntity(noteBookNoteSuperEntity);

      expect(id, 1);

      BookNote bookNote =
          (await serviceLocator<BookNoteDao>().findBookNoteById(id).first)!;

      expect(bookNote.startPage, 1);

      await serviceLocator<BookNoteDao>().deleteBookNote(bookNote);
      BookNote? bookNoteDeleted =
          await serviceLocator<BookNoteDao>().findBookNoteById(id).first;
      Note? noteDeleted =
          await serviceLocator<NoteDao>().findNoteById(id).first;

      expect(bookNoteDeleted, null);
      expect(noteDeleted, null);
    });
  });

  testWidgets('Test SuperDAO for Note/TaskNote', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          name: 'name',
          picture: 'picture',
          type: InstitutionType.education,
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
        name: 'name',
        institutionId: 1,
        acronym: 'acronym',
      ));

      await serviceLocator<TaskGroupDao>().insertTaskGroup(TaskGroup(
        name: 'name',
        description: 'description',
        priority: enums.Priority.high,
        deadline: DateTime.now(),
      ));

      await serviceLocator<TaskDao>().insertTask(Task(
          name: 'name',
          description: 'description',
          priority: enums.Priority.high,
          deadline: DateTime.now().subtract(const Duration(days: 1)),
          taskGroupId: 1,
          subjectId: 1,
          xp: 20,
          finished: false));

      NoteTaskNoteSuperEntity noteTaskNoteSuperEntity = NoteTaskNoteSuperEntity(
          title: 'Note 1',
          content: 'Content 1',
          date: DateTime.now(),
          taskId: 1);

      int id = await serviceLocator<NoteTaskNoteSuperDao>()
          .insertNoteTaskNoteSuperEntity(noteTaskNoteSuperEntity);

      expect(id, 1);

      TaskNote taskNote =
          (await serviceLocator<TaskNoteDao>().findTaskNoteById(id).first)!;

      expect(taskNote.taskId, 1);

      //Test delete callback
      await serviceLocator<TaskNoteDao>().deleteTaskNote(taskNote);
      TaskNote? taskNoteDeleted =
          await serviceLocator<TaskNoteDao>().findTaskNoteById(id).first;
      Note? noteDeleted =
          await serviceLocator<NoteDao>().findNoteById(id).first;

      expect(taskNoteDeleted, null);
      expect(noteDeleted, null);
    });
  });

  testWidgets('Test SuperDAO for Note/SubjectNote',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          name: 'name',
          picture: 'picture',
          type: InstitutionType.education,
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
        name: 'name',
        institutionId: 1,
        acronym: 'acronym',
      ));

      NoteSubjectNoteSuperEntity noteSubjectNoteSuperEntity =
          NoteSubjectNoteSuperEntity(
              title: 'Note 1',
              content: 'Content 1',
              date: DateTime.now(),
              subjectId: 1);

      int id = await serviceLocator<NoteSubjectNoteSuperDao>()
          .insertNoteSubjectNoteSuperEntity(noteSubjectNoteSuperEntity);

      expect(id, 1);

      SubjectNote subjectNote = (await serviceLocator<SubjectNoteDao>()
          .findSubjectNoteById(id)
          .first)!;

      expect(subjectNote.subjectId, 1);

      //Test delete callback
      await serviceLocator<SubjectNoteDao>().deleteSubjectNote(subjectNote);
      SubjectNote? subjectNoteDeleted =
          await serviceLocator<SubjectNoteDao>().findSubjectNoteById(id).first;
      Note? noteDeleted =
          await serviceLocator<NoteDao>().findNoteById(id).first;

      expect(subjectNoteDeleted, null);
      expect(noteDeleted, null);
    });
  });

  testWidgets('Test Video/Episode SuperDAO', (WidgetTester tester) async {
    await tester.runAsync(() async {
      MediaSeriesSuperEntity mediaSeriesSuperEntity = MediaSeriesSuperEntity(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: "Me",
          tagline: "Super Cool Test");

      int seriesId = await serviceLocator<MediaSeriesSuperDao>()
          .insertMediaSeriesSuperEntity(mediaSeriesSuperEntity);

      expect(seriesId, 1);

      Season season = Season(
        number: 1,
        seriesId: seriesId,
      );

      int seasonId = await serviceLocator<SeasonDao>().insertSeason(season);

      MediaVideoEpisodeSuperEntity mediaVideoEpisodeSuperEntity =
          MediaVideoEpisodeSuperEntity(
        name: 'name',
        description: 'description',
        linkImage: 'linkImage',
        status: Status.goingThrough,
        favorite: true,
        genres: 'genres',
        release: DateTime.now(),
        xp: 23,
        duration: 23,
        number: 1,
        seasonId: seasonId,
        participants: "Me",
      );

      int id = await serviceLocator<MediaVideoEpisodeSuperDao>()
          .insertMediaVideoEpisodeSuperEntity(mediaVideoEpisodeSuperEntity);

      expect(id, 2);

      Episode episode =
          (await serviceLocator<EpisodeDao>().findEpisodeById(id).first)!;

      expect(episode.number, 1);
    });
  });

  testWidgets('Test Note/EpisodeNote SuperDAO', (WidgetTester tester) async {
    await tester.runAsync(() async {
      MediaSeriesSuperEntity mediaSeriesSuperEntity = MediaSeriesSuperEntity(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: "Me",
          tagline: "Super Cool Test");

      int seriesId = await serviceLocator<MediaSeriesSuperDao>()
          .insertMediaSeriesSuperEntity(mediaSeriesSuperEntity);

      expect(seriesId, 1);

      Season season = Season(
        number: 1,
        seriesId: seriesId,
      );

      int seasonId = await serviceLocator<SeasonDao>().insertSeason(season);

      MediaVideoEpisodeSuperEntity mediaVideoEpisodeSuperEntity =
          MediaVideoEpisodeSuperEntity(
              name: 'name',
              description: 'description',
              linkImage: 'linkImage',
              status: Status.goingThrough,
              favorite: true,
              genres: 'genres',
              release: DateTime.now(),
              xp: 23,
              duration: 23,
              number: 1,
              seasonId: seasonId,
              participants: 'Me');

      int id = await serviceLocator<MediaVideoEpisodeSuperDao>()
          .insertMediaVideoEpisodeSuperEntity(mediaVideoEpisodeSuperEntity);

      expect(id, 2);

      Episode episode =
          (await serviceLocator<EpisodeDao>().findEpisodeById(id).first)!;

      expect(episode.number, 1);

      NoteEpisodeNoteSuperEntity noteEpisodeNoteSuperEntity =
          NoteEpisodeNoteSuperEntity(
              title: 'title',
              content: 'content',
              date: DateTime.now(),
              episodeId: id);

      int id3 = await serviceLocator<NoteEpisodeNoteSuperDao>()
          .insertNoteEpisodeNoteSuperEntity(noteEpisodeNoteSuperEntity);

      expect(id3, 1);

      EpisodeNote episodeNote = (await serviceLocator<EpisodeNoteDao>()
          .findEpisodeNoteById(id3)
          .first)!;

      expect(episodeNote.episodeId, id);

      //Test delete callback
      await serviceLocator<EpisodeNoteDao>().deleteEpisodeNote(episodeNote);
      EpisodeNote? episodeNoteDeleted =
          await serviceLocator<EpisodeNoteDao>().findEpisodeNoteById(id).first;
      Note? noteDeleted =
          await serviceLocator<NoteDao>().findNoteById(id).first;

      expect(episodeNoteDeleted, null);
      expect(noteDeleted, null);
    });
  });

  testWidgets('Test SuperDAO for Timeslot/MediaTimeslot',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      int seriesId = await serviceLocator<MediaDao>().insertMedia(Media(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: 'Me'));

      await serviceLocator<SeriesDao>()
          .insertSerie(Series(id: seriesId, tagline: 'Super Cool Test'));

      TimeslotMediaTimeslotSuperEntity timeslotMediaTimeslotSuperEntity =
          TimeslotMediaTimeslotSuperEntity(
              title: 'timeslot 1',
              description: 'description 1',
              startDateTime: DateTime.now(),
              endDateTime: DateTime.now().add(const Duration(days: 1)),
              xpMultiplier: 2,
              finished: false,
              userId: 1);

      int id = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
          .insertTimeslotMediaTimeslotSuperEntity(
              timeslotMediaTimeslotSuperEntity);

      expect(id, 1);
    });
  });

  testWidgets('Test SuperDAO for Timeslot/StudentTimeslot',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          name: 'name',
          picture: 'picture',
          type: InstitutionType.education,
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
        name: 'name',
        institutionId: 1,
        acronym: 'acronym',
      ));

      await serviceLocator<TaskGroupDao>().insertTaskGroup(TaskGroup(
        name: 'name',
        description: 'description',
        priority: enums.Priority.high,
        deadline: DateTime.now(),
      ));

      await serviceLocator<TaskDao>().insertTask(Task(
          name: 'name',
          description: 'description',
          priority: enums.Priority.high,
          deadline: DateTime.now().subtract(const Duration(days: 1)),
          taskGroupId: 1,
          subjectId: 1,
          xp: 20,
          finished: false));

      TimeslotStudentTimeslotSuperEntity timeslotStudentTimeslotSuperEntity =
          TimeslotStudentTimeslotSuperEntity(
              title: 'timeslot 1',
              description: 'description 1',
              startDateTime: DateTime.now(),
              endDateTime: DateTime.now().add(const Duration(days: 1)),
              xpMultiplier: 2,
              finished: false,
              userId: 1);

      int id = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
          .insertTimeslotStudentTimeslotSuperEntity(
              timeslotStudentTimeslotSuperEntity);

      expect(id, 1);
    });
  });

  testWidgets('Test SuperDAO for Media/MediaTimeslot',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          imagePath: 'test',
          level: 1));

      int seriesId = await serviceLocator<MediaDao>().insertMedia(Media(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: 'Me'));

      await serviceLocator<SeriesDao>()
          .insertSerie(Series(id: seriesId, tagline: 'Super Cool Test'));

      TimeslotMediaTimeslotSuperEntity timeslotMediaTimeslotSuperEntity =
          TimeslotMediaTimeslotSuperEntity(
              title: 'timeslot 1',
              description: 'description 1',
              startDateTime: DateTime.now(),
              endDateTime: DateTime.now().add(const Duration(days: 1)),
              xpMultiplier: 2,
              finished: false,
              userId: 1);

      int id = await serviceLocator<TimeslotMediaTimeslotSuperDao>()
          .insertTimeslotMediaTimeslotSuperEntity(
              timeslotMediaTimeslotSuperEntity);

      await serviceLocator<MediaMediaTimeslotDao>().insertMediaMediaTimeslot(
          MediaMediaTimeslot(mediaId: seriesId, mediaTimeslotId: id));

      List<Media> mediaList = await serviceLocator<MediaMediaTimeslotDao>()
          .findMediaByMediaTimeslotId(id);

      List<MediaTimeslot> mediaTimeslotList =
          await serviceLocator<MediaMediaTimeslotDao>()
              .findMediaTimeslotByMediaId(seriesId);

      expect(mediaList.length, 1);
      expect(mediaTimeslotList.length, 1);
    });
  });

  testWidgets('Test SuperDAO for Task/StudentTimeslot',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          imagePath: 'test',
          level: 1));

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          name: 'name',
          picture: 'picture',
          type: InstitutionType.education,
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
        name: 'name',
        institutionId: 1,
        acronym: 'acronym',
      ));

      await serviceLocator<TaskGroupDao>().insertTaskGroup(TaskGroup(
        name: 'name',
        description: 'description',
        priority: enums.Priority.high,
        deadline: DateTime.now(),
      ));

      int taskId = await serviceLocator<TaskDao>().insertTask(Task(
          name: 'name',
          description: 'description',
          priority: enums.Priority.high,
          deadline: DateTime.now().subtract(const Duration(days: 1)),
          taskGroupId: 1,
          subjectId: 1,
          finished: false,
          xp: 20));

      TimeslotStudentTimeslotSuperEntity timeslotStudentTimeslotSuperEntity =
          TimeslotStudentTimeslotSuperEntity(
              title: 'timeslot 1',
              description: 'description 1',
              startDateTime: DateTime.now(),
              endDateTime: DateTime.now().add(const Duration(days: 1)),
              xpMultiplier: 2,
              finished: false,
              userId: 1);

      int id = await serviceLocator<TimeslotStudentTimeslotSuperDao>()
          .insertTimeslotStudentTimeslotSuperEntity(
              timeslotStudentTimeslotSuperEntity);

      await serviceLocator<TaskStudentTimeslotDao>().insertTaskStudentTimeslot(
          TaskStudentTimeslot(taskId: taskId, studentTimeslotId: id));

      List<Task> taskList = await serviceLocator<TaskStudentTimeslotDao>()
          .findTaskByStudentTimeslotId(id);

      List<StudentTimeslot> studentTimeslotList =
          await serviceLocator<TaskStudentTimeslotDao>()
              .findStudentTimeslotByTaskId(taskId);

      expect(taskList.length, 1);
      expect(studentTimeslotList.length, 1);
    });
  });

// ---------------------------- TRIGGER TESTS ----------------------------
  testWidgets('Test Trigger timeslot_date', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      users = await serviceLocator<UserDao>().findAllUsers();
      User user = users.first;
      int userId = user.id!;
      expect(users.length, 1);

      DateTime date = DateTime.now();
      DateTime startDateTime = date.add(const Duration(hours: 1));
      DateTime endDateTime = date;
      Timeslot timeslot = Timeslot(
        title: 'title',
        description: 'description',
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        xpMultiplier: 1,
        finished: false,
        userId: userId,
      );

      expect(
          () => serviceLocator<TimeslotDao>().insertTimeslot(timeslot),
          throwsA(isA<DatabaseException>().having(
              (e) => e.toString(),
              'toString',
              contains('start_datetime must be before end_datetime'))));
    });
  });

  testWidgets('Test Trigger book_pages', (WidgetTester tester) async {
    await tester.runAsync(() async {
      MediaBookSuperEntity mediaBookSuperEntity = MediaBookSuperEntity(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: 'Me',
          totalPages: 23,
          progressPages: -1);

      expect(
          () => serviceLocator<MediaBookSuperDao>()
              .insertMediaBookSuperEntity(mediaBookSuperEntity),
          throwsA(isA<DatabaseException>()));

      mediaBookSuperEntity = MediaBookSuperEntity(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          participants: 'Me',
          totalPages: 23,
          progressPages: 30);

      expect(
          () => serviceLocator<MediaBookSuperDao>()
              .insertMediaBookSuperEntity(mediaBookSuperEntity),
          throwsA(isA<DatabaseException>()));
    });
  });

  testWidgets('Test trigger book_note_pages', (WidgetTester tester) async {
    await tester.runAsync(() async {
      MediaBookSuperEntity mediaBookSuperEntity = MediaBookSuperEntity(
        name: 'name',
        description: 'description',
        linkImage: 'linkImage',
        status: Status.goingThrough,
        favorite: true,
        genres: 'genres',
        release: DateTime.now(),
        xp: 23,
        participants: 'Me',
        totalPages: 23,
      );

      await serviceLocator<MediaBookSuperDao>()
          .insertMediaBookSuperEntity(mediaBookSuperEntity);

      NoteBookNoteSuperEntity noteBookNoteSuperEntity = NoteBookNoteSuperEntity(
          title: 'title',
          content: 'content',
          date: DateTime.now(),
          startPage: 4,
          endPage: 1,
          bookId: 1);

      expect(
          () => serviceLocator<NoteBookNoteSuperDao>()
              .insertNoteBookNoteSuperEntity(noteBookNoteSuperEntity),
          throwsA(isA<DatabaseException>()));

      noteBookNoteSuperEntity = NoteBookNoteSuperEntity(
          title: 'title',
          content: 'content',
          date: DateTime.now(),
          startPage: 4,
          endPage: 30,
          bookId: 1);

      expect(
          () => serviceLocator<NoteBookNoteSuperDao>()
              .insertNoteBookNoteSuperEntity(noteBookNoteSuperEntity),
          throwsA(isA<DatabaseException>()));
    });
  });

  testWidgets('Test trigger review_date', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<MediaDao>().insertMedia(Media(
          id: 1,
          name: 'Video 1',
          description: 'Video 1',
          linkImage: 'Video 1',
          status: Status.nothing,
          favorite: false,
          genres: 'Video 1',
          release: DateTime.now(),
          xp: 0,
          participants: 'Me'));

      Review review = Review(
          id: 1,
          review: 'Review 1',
          emoji: Reaction.dislike,
          mediaId: 1,
          startDate: DateTime.utc(1989, 2, 22),
          endDate: DateTime.utc(1989, 2, 21));

      expect(() => serviceLocator<ReviewDao>().insertReview(review),
          throwsA(isA<DatabaseException>()));
    });
  });

  testWidgets('Test Trigger season_number', (WidgetTester tester) async {
    await tester.runAsync(() async {
      int id = await serviceLocator<MediaSeriesSuperDao>()
          .insertMediaSeriesSuperEntity(MediaSeriesSuperEntity(
              name: 'Series 1',
              description: 'Series 1',
              linkImage: 'Series 1',
              status: Status.nothing,
              favorite: false,
              genres: 'Series 1',
              release: DateTime.now(),
              xp: 0,
              participants: "Me",
              tagline: "Super Cool Test"));

      Season season = Season(id: 1, number: -1, seriesId: id);

      expect(() => serviceLocator<SeasonDao>().insertSeason(season),
          throwsA(isA<DatabaseException>()));
    });
  });

  testWidgets('Test Trigger episode_number', (WidgetTester tester) async {
    await tester.runAsync(() async {
      int seriesId = await serviceLocator<MediaSeriesSuperDao>()
          .insertMediaSeriesSuperEntity(MediaSeriesSuperEntity(
              name: 'Series 1',
              description: 'Series 1',
              linkImage: 'Series 1',
              status: Status.nothing,
              favorite: false,
              genres: 'Series 1',
              release: DateTime.now(),
              xp: 0,
              participants: "Me",
              tagline: "Super Cool Test"));

      int seasonId = await serviceLocator<SeasonDao>()
          .insertSeason(Season(id: 1, number: 1, seriesId: seriesId));

      MediaVideoEpisodeSuperEntity mediaVideoEpisodeSuperEntity =
          MediaVideoEpisodeSuperEntity(
              name: 'Episode 1',
              description: 'Episode 1',
              linkImage: 'Episode 1',
              status: Status.nothing,
              favorite: false,
              genres: 'Episode 1',
              release: DateTime.now(),
              xp: 0,
              duration: 1,
              number: -1,
              seasonId: seasonId,
              participants: 'Me');

      expect(
          () => serviceLocator<MediaVideoEpisodeSuperDao>()
              .insertMediaVideoEpisodeSuperEntity(mediaVideoEpisodeSuperEntity),
          throwsA(isA<DatabaseException>()));
    });
  });

  testWidgets('Test Triggers evaluation_grade', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          id: 1,
          name: 'Institution 1',
          picture: 'Institution 1',
          type: InstitutionType.education,
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(
          Subject(id: 1, name: 'Subject 1', institutionId: 1, acronym: 'S'));

      StudentEvaluation studentEvaluation = StudentEvaluation(
          id: 1, name: 'Evaluation 1', grade: -8, subjectId: 1);

      expect(
          () => serviceLocator<StudentEvaluationDao>()
              .insertStudentEvaluation(studentEvaluation),
          throwsA(isA<DatabaseException>()));
    });
  });

  testWidgets('Test Trigger task_deadline', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>().insertUser(User(
          userName: 'Emil',
          password: '1234',
          xp: 23,
          level: 1,
          imagePath: 'test'));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);

      await serviceLocator<TaskGroupDao>().insertTaskGroup(TaskGroup(
          id: 1,
          name: 'Task Group 1',
          description: 'Task Group 1',
          priority: enums.Priority.low,
          deadline: DateTime.utc(2021, 12, 31)));

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          id: 1,
          name: 'Institution 1',
          picture: 'Institution 1',
          type: InstitutionType.education,
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(
          Subject(id: 1, name: 'Subject 1', institutionId: 1, acronym: 'S'));

      Task task = Task(
          id: 1,
          name: 'Task 1',
          description: 'Task 1',
          priority: enums.Priority.low,
          deadline: DateTime.utc(2022, 01, 02),
          taskGroupId: 1,
          subjectId: 1,
          xp: 1,
          finished: false);

      expect(() => serviceLocator<TaskDao>().insertTask(task),
          throwsA(isA<DatabaseException>()));
    });
  });
}
