import 'package:flutter_test/flutter_test.dart';
//import 'package:src/daos/media/media_dao.dart';
import 'package:src/database/database.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/models/user.dart';
/*
import 'package:src/daos/media/season_dao.dart';
import 'package:src/models/media/season.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/models/media/series.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/utils/enums.dart';
import 'package:src/models/media/video.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/media/episode.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/models/media/book.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/models/media/review.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/models/notes/book_note.dart';
import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/models/student/task.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/daos/student/task_group_dao.dart';
*/

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
}

/*
testWidgets('Book Notes test', (WidgetTester tester) async{
  await tester.runAsync(() async{
    await serviceLocator<BookDao>().insertBook(Book(
          id: 1,
          name: 'Book 1',
          description: 'Book 1',
          linkImage: 'Book 1',
          status: Status.nothing,
          favorite: false,
          genres: 'Book 1',
          release: DateTime.now(),
          xp: 0,
          authors: 'Me',
          progressPages: 1,
          totalPages: 1));

      await serviceLocator<BookNoteDao>().insertBookNote(BookNote(
          id: 1,
          bookId: 1,
          startPage: 1,
          endPage: 4,
          date: DateTime.now(),
          title: 'Note 1',
          content: 'Note 1'));
  });

});
*/
  /*
  testWidgets('Date Review test', (WidgetTester tester) async {
    await tester.runAsync(() async {

      await serviceLocator<MediaDao>().insertMedia(Video(
          id: 1,
          name: 'Video 1',
          description: 'Video 1',
          linkImage: 'Video 1',
          status: Status.nothing,
          favorite: false,
          genres: 'Video 1',
          release: DateTime.now(),
          xp: 0,
          duration: 1));

      await serviceLocator<ReviewDao>().insertReview(Review(
          id: 1,
          review: 'Review 1',
          emoji: Reaction.dislike,
          mediaId: 1,
          startDate: DateTime.utc(1989, 2, 22),
          endDate: DateTime.utc(1989, 2, 21)

          ));
  });
  */

  /*
  testWidgets('Book pages test', (WidgetTester tester) async {
    await tester.runAsync(() async {

      await serviceLocator<BookDao>().insertBook(Book(
          id: 1,
          name: 'Book 1',
          description: 'Book 1',
          linkImage: 'Book 1',
          status: Status.nothing,
          favorite: false,
          genres: 'Book 1',
          release: DateTime.now(),
          xp: 0,
          authors: 'Me',
          progressPages: -1,
          totalPages: 1));
    });
  });
  */

/*
  testWidgets('Series number test', (WidgetTester tester) async {
    await tester.runAsync(() async {

      await serviceLocator<SeriesDao>().insertSerie(Series(
          id: 1,
          name: 'Series 1',
          description: 'Series 1',
          linkImage: 'Series 1',
          status: Status.nothing,
          favorite: false,
          genres: 'Series 1',
          release: DateTime.now(),
          xp: 0));

      await serviceLocator<SeasonDao>()
          .insertSeason(Season(id: 1, number: -1, seriesId: 1));

      List<Season> seasons = await serviceLocator<SeasonDao>().findAllSeason();

      expect(seasons.length, 0);
    });
  });
  */

/*
  testWidgets('Episode number test', (WidgetTester tester) async {
    await tester.runAsync(() async {

      await serviceLocator<SeriesDao>().insertSerie(Series(
          id: 1,
          name: 'Series 1',
          description: 'Series 1',
          linkImage: 'Series 1',
          status: Status.nothing,
          favorite: false,
          genres: 'Series 1',
          release: DateTime.now(),
          xp: 0));

      await serviceLocator<SeasonDao>()
          .insertSeason(Season(id: 1, number: 1, seriesId: 1));

      await serviceLocator<EpisodeDao>().insertEpisode(Episode(
          id: 1,
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
          seasonId: 1));
    });
  });
  */

/*
   testWidgets('Video constraint test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await serviceLocator<VideoDao>().insertVideo(Video(
          id: 1,
          name: 'Video 1',
          description: 'Video 1',
          linkImage: 'Video 1',
          status: Status.nothing,
          favorite: false,
          genres: 'Video 1',
          release: DateTime.now(),
          xp: 0,
          duration: -1));
      
      //List<Video> videos = await serviceLocator<VideoDao>().findAllVideos();

      //expect(videos.length, 0);



    });
  });
  */

/*
testWidgets('Weight average Subject', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>()
          .insertUser(User(userName: 'Emil', password: '1234', xp: 23));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          id: 1,
          name: 'Institution 1',
          picture: 'Institution 1',
          type: InstitutionType.education,
          acronym: 'I',
          userId: 1
         ));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
          id: 1,
          name: 'Subject 1',
          weightAverage: -8,
          institutionId: 1));
    });
*/

/*
 testWidgets('Subject mininum/overall weight', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>()
          .insertUser(User(userName: 'Emil', password: '1234', xp: 23));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);

      await serviceLocator<InstitutionDao>().insertInstitution(Institution(
          id: 1,
          name: 'Institution 1',
          picture: 'Institution 1',
          type: InstitutionType.education,
          acronym: 'I',
          userId: 1
         ));

      await serviceLocator<SubjectDao>().insertSubject(Subject(
          id: 1,
          name: 'Subject 1',
          weightAverage: 8,
          institutionId: 1));

      await serviceLocator<StudentEvaluationDao>().insertStudentEvaluation(StudentEvaluation(
          id: 1,
          name: 'Evaluation 1',
          weight: 0.4,
          minimum: 8,
          grade: 8,
          subjectId: 1));

      await serviceLocator<StudentEvaluationDao>().insertStudentEvaluation(StudentEvaluation(
          id: 2,
          name: 'Evaluation 2',
          weight: 0.7,
          minimum: 8,
          grade: 8,
          subjectId: 1));

    });
  });*/

  /*
  testWidgets('Task deadline test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<User> users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 0);

      await serviceLocator<UserDao>()
          .insertUser(User(userName: 'Emil', password: '1234', xp: 23));

      users = await serviceLocator<UserDao>().findAllUsers();

      expect(users.length, 1);

      await serviceLocator<TaskGroupDao>().insertTaskGroup(TaskGroup(
          id: 1,
          name: 'Task Group 1',
          description: 'Task Group 1',
          priority: Priority.low,
          deadline: DateTime.utc(2021, 12, 31)));

      await serviceLocator<TaskDao>().insertTask(Task(
          id: 1,
          name: 'Task 1',
          description: 'Task 1',
          priority: Priority.low,
          deadline: DateTime.utc(2022,01,02),
          taskGroupId:1,
          xp:1
         ));


    });
  });*/