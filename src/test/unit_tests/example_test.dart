import 'package:flutter_test/flutter_test.dart';
import 'package:src/daos/media/media_video_super_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/database/database.dart';
import 'package:src/models/media/media_video_super_entity.dart';
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
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';
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

import '../utils/service_locator_test_util.dart';

void main() {
  setUp(() async {
    setupServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator<AppDatabase>().close();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>()
          .insertUser(User(userName: 'Emil', password: '1234', xp: 23));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);
    });
  });

  testWidgets('Test SuperDAO', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Just an example test to prove it works
      MediaVideoSuperEntity mediaVideoSuperEntity = MediaVideoSuperEntity(
        name: 'name',
        description: 'description',
        linkImage: 'linkImage',
        status: Status.goingThrough,
        favorite: true,
        genres: 'genres',
        release: DateTime.now(),
        xp: 23,
        duration: 23,
      );

      int id = await serviceLocator<MediaVideoSuperDao>()
          .insertMediaVideoSuperEntity(mediaVideoSuperEntity);

      expect(id, 1);

      Video video = (await serviceLocator<VideoDao>().findVideoById(id).first)!;

      expect(video.duration, 23);
    });
  });

  testWidgets('Test SuperDAO for Note/BookNote', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<MediaDao>().insertMedia(Media(
        name: 'name',
        description: 'description',
        linkImage: 'linkImage',
        status: Status.goingThrough,
        favorite: true,
        genres: 'genres',
        release: DateTime.now(),
        xp: 23,
      ));

      await serviceLocator<BookDao>().insertBook(Book(
          name: 'name',
          description: 'description',
          linkImage: 'linkImage',
          status: Status.goingThrough,
          favorite: true,
          genres: 'genres',
          release: DateTime.now(),
          xp: 23,
          authors: 'Me',
          totalPages: 23,
          progressPages: 0));

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
    });
  });

  testWidgets('Test SuperDAO for Note/TaskNote', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>()
        .insertUser(User(userName: 'Emil', password: '1234', xp: 23));

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          name: 'name',
          picture: 'picture',
          type: InstitutionType.education,
          acronym: 'I',
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
        name: 'name',
        weightAverage: 1.0,
        institutionId: 1,
      ));

      await serviceLocator<TaskGroupDao>().insertTaskGroup(TaskGroup(
        name: 'name',
        description: 'description',
        priority: Priority.high,
        subjectId: 1,
        deadline: DateTime.now(),
      ));

      await serviceLocator<TaskDao>().insertTask(Task(
          name: 'name',
          description: 'description',
          priority: Priority.high,
          deadline: DateTime.now(),
          taskGroupId: 1,
          xp: 20));

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
    });
  });

  testWidgets('Test SuperDAO for Note/SubjectkNote', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<UserDao>()
        .insertUser(User(userName: 'Emil', password: '1234', xp: 23));
        
      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          name: 'name',
          picture: 'picture',
          type: InstitutionType.education,
          acronym: 'I',
          userId: 1));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
        name: 'name',
        weightAverage: 1.0,
        institutionId: 1,
      ));

      NoteSubjectNoteSuperEntity noteSubjectNoteSuperEntity = NoteSubjectNoteSuperEntity(
          title: 'Note 1',
          content: 'Content 1',
          date: DateTime.now(),
          subjectId: 1);

      int id = await serviceLocator<NoteSubjectNoteSuperDao>()
          .insertNoteSubjectNoteSuperEntity(noteSubjectNoteSuperEntity);

      expect(id, 1);

      SubjectNote subjectNote=
          (await serviceLocator<SubjectNoteDao>().findSubjectNoteById(id).first)!;

      expect(subjectNote.subjectId, 1);
    });
  });

  testWidgets('Test Video/Episode SuperDAO', (WidgetTester tester) async {
    await tester.runAsync(() async {

      MediaVideoEpisodeSuperEntity videoEpisodeSuperEntity = MediaVideoEpisodeSuperEntity(
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
      );

      int id = await serviceLocator<MediaVideoEpisodeSuperDao>()
          .insertMediaVideoEpisodeSuperEntity(videoEpisodeSuperEntity);

      expect(id, 1);

      Episode episode = (await serviceLocator<EpisodeDao>().findEpisodeById(id).first)!;

      expect(episode.number, 1);
      
    });
  });

  testWidgets('Test Note/EpisodeNote SuperDAO', (WidgetTester tester) async {
    await tester.runAsync(() async {

      MediaVideoEpisodeSuperEntity videoEpisodeSuperEntity = MediaVideoEpisodeSuperEntity(
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
      );

      int id = await serviceLocator<MediaVideoEpisodeSuperDao>()
          .insertMediaVideoEpisodeSuperEntity(videoEpisodeSuperEntity);

      expect(id, 1);

      Episode episode = (await serviceLocator<EpisodeDao>().findEpisodeById(id).first)!;

      expect(episode.number, 1);

      NoteEpisodeNoteSuperEntity noteEpisodeNoteSuperEntity = NoteEpisodeNoteSuperEntity(
        title: 'title',
        content: 'content',
        date: DateTime.now(),
        episodeId: 1
      );

      int id3 = await serviceLocator<NoteEpisodeNoteSuperDao>()
          .insertNoteEpisodeNoteSuperEntity(noteEpisodeNoteSuperEntity);

      expect(id3, 1);

      EpisodeNote episodeNote = (await serviceLocator<EpisodeNoteDao>().findEpisodeNoteById(id3).first)!;

      expect(episodeNote.episodeId, 1);      
    });
  });
}
