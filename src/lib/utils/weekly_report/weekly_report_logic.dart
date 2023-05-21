// Get all finished events function

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
import 'package:src/models/media/season.dart';
import 'package:src/models/notes/book_note.dart';
import 'package:src/models/notes/episode_note.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/user.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/utils/formatters.dart';
import 'package:src/utils/service_locator.dart';

const int NUMBER_TOP_MEDIA = 3;

Future<int?> getNumberFinishedEvents(DateTime reportDay) {
  DateTime reportWeekStart = reportDay.subtract(const Duration(days: 7));
  Future<int?> countFinishedEvents = serviceLocator<TimeslotDao>()
      .countFinishedTimeslotsAfterStart(reportWeekStart);
  return countFinishedEvents;
}

// Get all finished tasks function
Future<List<Task>> getFinishedTasks(DateTime reportDay) {
  DateTime reportWeekStart = reportDay.subtract(const Duration(days: 7));
  Future<List<Task>> finishedReportTasks =
      serviceLocator<TaskDao>().findAllFinishedTasksAfterStart(reportWeekStart);
  return finishedReportTasks;
}

Future<List<TaskGroup>> getNumberFinishedTaskGroups(
    List<Task> finishedTasks) async {
  List<TaskGroup> finishedTaskGroups = [];
  Map<int, int> taskGroupNumberFinishedTasks = {};
  for (Task task in finishedTasks) {
    if (task.taskGroupId != null) {
      List<Task> tasksTaskGroupsTasks = await serviceLocator<TaskDao>()
          .findTasksByTaskGroupId(task.taskGroupId!);
      bool taskGroupComplete = false;
      for (Task task in tasksTaskGroupsTasks) {
        if (task.finished == false) {
          taskGroupComplete = false;
          break;
        }
      }
      if (!taskGroupComplete) {
        continue;
      }
      if (!taskGroupNumberFinishedTasks.containsKey(task.taskGroupId)) {
        taskGroupNumberFinishedTasks[task.taskGroupId!] = 0;
      }
      taskGroupNumberFinishedTasks[task.taskGroupId!] =
          taskGroupNumberFinishedTasks[task.taskGroupId!]! + 1;
    }

    //sort taskGroupNumberFinishedTasks by highest value
    taskGroupNumberFinishedTasks = Map.fromEntries(
        taskGroupNumberFinishedTasks.entries.toList()
          ..sort((e1, e2) => e2.value.compareTo(e1.value)));

    for (int taskGroupId in taskGroupNumberFinishedTasks.keys) {
      TaskGroup taskGroup = (await serviceLocator<TaskGroupDao>()
          .findTaskGroupById(taskGroupId)
          .first)!;
      finishedTaskGroups.add(taskGroup);
    }
  }
  return finishedTaskGroups;
}

Future<List<int>> getMediaStats() async {
  int numberMedia = await serviceLocator<MediaDao>().countAllMedia() ?? 0;
  int count = await serviceLocator<MediaDao>().countFavoriteMedia(true) ?? 0;
  int percentageFavoriteMedia = (count / numberMedia * 100).round();
  // return numberMedia, percentageFavoriteMedia, count
  return [numberMedia, percentageFavoriteMedia, count];
}

Future<int> getNumberNotes() async {
  int numberNotes = await serviceLocator<EpisodeNoteDao>().countNotes() ?? 0;
  numberNotes =
      numberNotes + (await serviceLocator<BookNoteDao>().countNotes() ?? 0);
  return numberNotes;
}

Future<List<Media>> sortMediaByNumberOfNotes() async {
  List<EpisodeNote> episodeNotes =
      await serviceLocator<EpisodeNoteDao>().findAllEpisodeNotes();
  List<BookNote> bookNotes =
      await serviceLocator<BookNoteDao>().findAllBookNotes();

  Map<int, int> seriesNumberNotes = {};
  for (EpisodeNote episodeNote in episodeNotes) {
    // Get the season
    int episodeId = episodeNote.episodeId;
    Episode episode =
        (await serviceLocator<EpisodeDao>().findEpisodeById(episodeId).first)!;
    int seasonId = episode.seasonId;
    Season season =
        (await serviceLocator<SeasonDao>().findSeasonById(seasonId).first)!;
    int seriesId = season.seriesId;
    if (!seriesNumberNotes.containsKey(seriesId)) {
      seriesNumberNotes[seriesId] = 0;
    }

    seriesNumberNotes[seriesId] = seriesNumberNotes[seriesId]! + 1;
  }
  // sort map by highest value
  seriesNumberNotes = Map.fromEntries(seriesNumberNotes.entries.toList()
    ..sort((e1, e2) => e2.value.compareTo(e1.value)));

  Map<int, int> bookNumberNotes = {};
  for (BookNote bookNote in bookNotes) {
    int bookId = bookNote.bookId;
    if (!bookNumberNotes.containsKey(bookId)) {
      bookNumberNotes[bookId] = 0;
    }
    bookNumberNotes[bookId] = bookNumberNotes[bookId]! + 1;
  }

  Map<Media, int> mediaNumberNotes = {};
  for (int seriesId in seriesNumberNotes.keys) {
    Media media =
        (await serviceLocator<MediaDao>().findMediaById(seriesId).first)!;
    mediaNumberNotes[media] = seriesNumberNotes[seriesId]!;
  }
  for (int bookId in bookNumberNotes.keys) {
    Media media =
        (await serviceLocator<MediaDao>().findMediaById(bookId).first)!;
    mediaNumberNotes[media] = bookNumberNotes[bookId]!;
  }
  mediaNumberNotes = Map.fromEntries(mediaNumberNotes.entries.toList()
    ..sort((e1, e2) => e2.value.compareTo(e1.value)));

  // get the top 3 from the aglmoreate of values from bookNumberNotes and seriesNumberNotes
  List<Media> topMedia = [];
  // iterate mediaNumberNotes
  for (Media media in mediaNumberNotes.keys) {
    if (topMedia.length >= NUMBER_TOP_MEDIA) {
      break;
    }
    topMedia.add(media);
  }
  return topMedia;
}

List<String> getWeekBounds(DateTime reportDay) {
  DateTime reportWeekStart = reportDay.subtract(const Duration(days: 7));
  DateTime reportWeekEnd = reportDay;
  return [formatDeadline(reportWeekStart), formatDeadline(reportWeekEnd)];
}

void weekly_initData() async {
  DateTime now = DateTime.now();
  DateTime reportDay = DateTime(now.year, now.month, now.day);
  int numberFinishedEvents = await getNumberFinishedEvents(reportDay) ?? 0;
  List<Task> finishedTasks = await getFinishedTasks(reportDay);
  int numberFinishedTasks = finishedTasks.length;
  List<TaskGroup> finishedTaskGroups =
      await getNumberFinishedTaskGroups(finishedTasks);
  TaskGroup? mostFinishedTaskGroup;
  if (finishedTaskGroups.length > 0) {
    mostFinishedTaskGroup = finishedTaskGroups[0];
  }
  int numberFinishedTaskGroups = finishedTaskGroups.length;

  int numberMedia, percentageFavoriteMedia, countFavoriteMedia;
  List<int> mediaStats = await getMediaStats();
  numberMedia = mediaStats[0];
  percentageFavoriteMedia = mediaStats[1];
  countFavoriteMedia = mediaStats[2];
  int numberNotes = await getNumberNotes();
  List<Media> topMedia = await sortMediaByNumberOfNotes();

  User user = serviceLocator<AuthenticationService>().isUserLoggedIn()
      ? serviceLocator<AuthenticationService>().getLoggedInUser()!
      : User(
          name: '',
          email: '',
          password: '',
          xp: 0,
          level: 0,
          imagePath: 'assets/images/no_image.jpg');
  int xp = user.xp;
  int level = user.level;
  List<String> weekDates = getWeekBounds(reportDay);
  print("STUFF");
}
