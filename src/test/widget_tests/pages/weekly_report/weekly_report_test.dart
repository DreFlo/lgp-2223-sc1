import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/daos/media/episode_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/daos/notes/episode_note_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/models/media/episode.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/notes/book_note.dart';
import 'package:src/models/notes/episode_note.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/weekly_report/weekly_report.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import '../../../utils/locations_injector.dart';
import '../../../utils/model_mocks_util.mocks.dart';
import '../../../utils/service_locator_test_util.dart';

void main() {
  List<TaskGroup> taskgroups = [
    TaskGroup(
        id: 3,
        name: 'Have dinner',
        description: 'Cook a meal',
        priority: Priority.high,
        deadline: DateTime.now()),
    TaskGroup(
        id: 4,
        name: 'Chores',
        description: 'Do the house chores',
        priority: Priority.high,
        deadline: DateTime.now())
  ];

  List<Task> tasks = [
    Task(
      name: 'Check ingredients',
      description: 'Open the fridge',
      priority: Priority.high,
      deadline: DateTime.now().subtract(const Duration(hours: 1)),
      xp: 0,
      taskGroupId: 3,
      subjectId: 1,
      finished: true,
      finishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      name: 'Boil water',
      description: 'Put wattle in the kettle',
      priority: Priority.high,
      deadline: DateTime.now().subtract(const Duration(hours: 1)),
      xp: 0,
      taskGroupId: 3,
      subjectId: 1,
      finished: true,
      finishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      name: 'Heat up the oven',
      description: 'Turn up the heat',
      priority: Priority.high,
      deadline: DateTime.now().subtract(const Duration(hours: 1)),
      xp: 0,
      taskGroupId: 3,
      subjectId: 1,
      finished: true,
      finishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      name: 'Do laundry',
      description: 'Take clothes out of the washing machine',
      priority: Priority.high,
      deadline: DateTime.now().subtract(const Duration(hours: 1)),
      xp: 0,
      taskGroupId: 4,
      subjectId: 1,
      finished: true,
      finishedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      name: 'Make beds',
      description: 'Change the sheets',
      priority: Priority.high,
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      xp: 0,
      taskGroupId: 4,
      subjectId: 1,
      finished: true,
      finishedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Task(
      name: 'Scrub toilet',
      description: 'That thing is disgusting!',
      priority: Priority.high,
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      xp: 0,
      taskGroupId: 4,
      subjectId: 1,
      finished: false,
    )
  ];

  List<Media> mediaBooks = [
    Media(
        id: 7,
        name: 'Mistborn: The Final Empire',
        description:
            'Three years prior to the start of the novel, a half-skaa thief named Kelsier discovered that he was Mistborn and escapes the Pits of Hathsin, a brutal prison camp of the Lord Ruler. He returned to Luthadel, the capital city of the Final Empire, where he rounded up his old thieving crew for a new job: to overthrow the Final Empire by stealing its treasury and collapsing its economy.',
        linkImage:
            'http://books.google.com/books/content?id=t_ZYYXZq4RgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api',
        status: Status.goingThrough,
        favorite: true,
        genres: 'fantasy',
        release: DateTime(2006, 7, 17),
        xp: 0,
        participants: 'Brandon Sanderson',
        type: MediaDBTypes.book),
    Media(
        id: 8,
        name: 'Mistborn: The Well Of Ascension',
        description:
            "The Final Empire is in turmoil as various regions descend into anarchy following the Lord Ruler's death and the disappearance of the Steel Ministry. Elend Venture has claimed the crown of the capital city, Luthadel, and attempts to restore order, but various hostile forces converge on the city. Three armies lay siege to Luthadel because of its rumored wealth of Atium and political influence. The first army is led by Straff Venture - head of House Venture, and Elend's father. The second army is led by Ashweather Cett, self-declared king of the Western Dominance. The third army consists of Koloss, massive, brutish blue creatures once controlled by the Lord Ruler, and is led by Elend's former friend Jastes, who is buying the Koloss' obedience with counterfeit coins.",
        linkImage:
            '"http://books.google.com/books/content?id=Y-41Q9zk32kC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"',
        status: Status.goingThrough,
        favorite: true,
        genres: 'fantasy',
        release: DateTime(2007, 8, 21),
        xp: 0,
        participants: 'Brandon Sanderson',
        type: MediaDBTypes.book),
  ];

  List<NoteBookNoteSuperEntity> bookNotes = [
    NoteBookNoteSuperEntity(
        id: 5,
        title: 'Vin',
        content: 'Poor urchin Vin',
        date: DateTime.now(),
        startPage: 1,
        endPage: 50,
        bookId: 7),
    NoteBookNoteSuperEntity(
        id: 6,
        title: 'Kelsier',
        content: 'This guy is cool',
        date: DateTime.now(),
        startPage: 51,
        endPage: 100,
        bookId: 7),
    NoteBookNoteSuperEntity(
        id: 7,
        title: 'Mistborn trainnig',
        content: 'Flying around while pushing must be fun',
        date: DateTime.now(),
        startPage: 101,
        endPage: 151,
        bookId: 7),
    NoteBookNoteSuperEntity(
        id: 8,
        title: 'The Lord Ruler',
        content: 'That guy made everything worse',
        date: DateTime.now(),
        startPage: 1,
        endPage: 50,
        bookId: 8),
  ];

  List<BookNote> bookNotesObject = [];
  int bookNotesId = 0;
  for (var bookNote in bookNotes) {
    bookNotesObject.add(BookNote(
        id: bookNotesId, startPage: 1, endPage: 2, bookId: bookNote.bookId));
    bookNotesId++;
  }

  List<Media> mediaSeries = [
    Media(
        id: 9,
        name: 'Snowpiercer',
        description:
            'Seven years after the world has become a frozen wasteland, the remnants of humanity inhabit a perpetually-moving train that circles the globe, where class warfare, social injustice and the politics of survival play out.',
        linkImage: '/3s6ZyZKurx6wDJZMXSsbUsgjWCI.jpg',
        status: Status.goingThrough,
        favorite: true,
        genres: 'drama',
        release: DateTime(2020, 05, 17),
        xp: 0,
        participants: 'Daveed Diggs, Mickey Sumner, Alison Wright',
        type: MediaDBTypes.series),
  ];

  List<Media> allMedia = mediaSeries + mediaBooks;
  List<Season> seasons = [Season(id: 2, number: 1, seriesId: 9)];

  List<MediaVideoEpisodeSuperEntity> episodes = [
    MediaVideoEpisodeSuperEntity(
        id: 10,
        name: 'First, the Weather Changed',
        description:
            "A grisly murder stokes the class division of Snowpiercer; Melanie deputizes a dangerous rebel to help solve the killing - Andre Layton, the world's only surviving homicide detective.",
        linkImage:
            "https://www.imdb.com/title/tt6900132/mediaviewer/rm189366785/?ref_=tt_ov_i",
        status: Status.done,
        favorite: true,
        genres: 'drama',
        release: DateTime(2020, 05, 17),
        xp: 50,
        participants: 'Jennifer Connelly, Daveed Diggs, Mickey Sumner',
        duration: 52,
        number: 1,
        seasonId: 2,
        tmdbId: 1725651),
    MediaVideoEpisodeSuperEntity(
        id: 11,
        name: 'Prepare to Brace',
        description:
            "Layton uses his new position as train detective to investigate the murder while gathering intel for the revolution on the side; Melanie faces a resource crisis, with potentially drastic consequences for the entire train.",
        linkImage:
            "https://www.imdb.com/title/tt8157204/mediaviewer/rm4045713409/?ref_=tt_ov_i",
        status: Status.done,
        favorite: true,
        genres: 'drama',
        release: DateTime(2020, 05, 24),
        xp: 50,
        participants: 'Jennifer Connelly, Daveed Diggs, Mickey Sumner',
        duration: 46,
        number: 2,
        seasonId: 2,
        tmdbId: 2228477),
  ];

  List<Episode> episodesObject = [];
  int episodeObjectId = 0;
  for (var episode in episodes) {
    episodesObject.add(Episode(
        id: episode.id!, number: episode.number, seasonId: episode.seasonId));
    episodeObjectId++;
  }
  List<NoteEpisodeNoteSuperEntity> episodeNotes = [
    NoteEpisodeNoteSuperEntity(
        id: 9,
        title: 'S01E01',
        content: 'Cool premise',
        date: DateTime.now(),
        episodeId: 10),
    NoteEpisodeNoteSuperEntity(
        id: 10,
        title: 'S01E02',
        content: 'Poor train',
        date: DateTime.now().subtract(const Duration(days: 1)),
        episodeId: 11)
  ];

  List<EpisodeNote> episodeNotesObject = [];
  int episodeNoteId = 0;
  for (var episodeNote in episodeNotes) {
    episodeNotesObject
        .add(EpisodeNote(episodeId: episodeNote.episodeId, id: episodeNoteId));
    episodeNoteId++;
  }

  int numberTimeslotsFinished = 5;
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  loadData() {
    // Error when loading data // TODO: fix
    final mockTimeslotDao = serviceLocator<TimeslotDao>();
    when(mockTimeslotDao
        .countFinishedTimeslotsAfterStart(MockDateTime())
        .then((value) => numberTimeslotsFinished));

    final taskDao = serviceLocator<TaskDao>();
    when(taskDao
        .findAllFinishedTasksAfterStart(MockDateTime())
        .then((_) async => tasks));
    for (var taskgroup in taskgroups) {
      when(taskDao.findTasksByTaskGroupId(taskgroup.id!)).thenAnswer(
          (_) async => tasks
              .where((element) => element.taskGroupId == taskgroup.id)
              .toList());
    }

    final taskGroupDao = serviceLocator<TaskGroupDao>();
    for (var taskgroup in taskgroups) {
      when(taskGroupDao.findTaskGroupById(taskgroup.id!))
          .thenAnswer((_) => Stream.value(taskgroup));
    }

    final mediaDao = serviceLocator<MediaDao>();
    when(mediaDao.countAllMedia()).thenAnswer((_) async => allMedia.length);
    when(mediaDao.countFavoriteMedia(true).then((_) =>
        Stream.value(allMedia.where((element) => element.favorite).length)));
    for (var media in allMedia) {
      when(mediaDao.findMediaById(media.id!))
          .thenAnswer((_) => Stream.value(media));
    }

    final episodeNoteDao = serviceLocator<EpisodeNoteDao>();
    when(episodeNoteDao
        .countNotes()
        .then((_) => Stream.value(episodeNotes.length)));
    when(episodeNoteDao.findAllEpisodeNotes())
        .thenAnswer((_) async => episodeNotesObject);
    final bookNoteDao = serviceLocator<BookNoteDao>();
    when(bookNoteDao.countNotes().then((_) => Stream.value(bookNotes.length)));
    when(bookNoteDao.findAllBookNotes())
        .thenAnswer((_) async => bookNotesObject);

    final episodeDao = serviceLocator<EpisodeDao>();
    for (var episode in episodes) {
      when(episodeDao.findEpisodeById(episode.id!)).thenAnswer((_) =>
          Stream.value(episodesObject
              .where((element) => element.id == episode.id)
              .first));
    }

    final seasonDao = serviceLocator<SeasonDao>();
    for (var season in seasons) {
      when(seasonDao.findSeasonById(season.id!)).thenAnswer((_) => Stream.value(
          seasons.where((element) => element.id == season.id).first));
    }
  }

  // testWidgets("View weekly report", (widgetTester) async {
  //   // loadData();

  //   await widgetTester
  //       .pumpWidget(const LocalizationsInjector(child: WeeklyReport()));
  //   await widgetTester.pumpAndSettle();

  //   expect(find.byKey(const Key('mostFinishedTaskGroup')), findsOneWidget);
  //   expect(find.byKey(const Key('noProjectsThisTime')), findsNothing);

  //   expect(find.byKey(const Key('topMedia')), findsOneWidget);
  //   expect(find.byKey(const Key('gotYouChatty')), findsOneWidget);
  //   expect(find.byKey(const Key('noNotesSoFar')), findsNothing);
  // });

  testWidgets("View weekly report - no projects", (widgetTester) async {
    // loadData();

    await widgetTester
        .pumpWidget(const LocalizationsInjector(child: WeeklyReport()));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('mostFinishedTaskGroup')), findsNothing);
    expect(find.byKey(const Key('noProjectsThisTime')), findsOneWidget);
  });

  testWidgets("View weekly report - no notes", (widgetTester) async {
    // loadData();

    await widgetTester
        .pumpWidget(const LocalizationsInjector(child: WeeklyReport()));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('mostFinishedTaskGroup')), findsNothing);
    expect(find.byKey(const Key('noProjectsThisTime')), findsOneWidget);
  });
}
