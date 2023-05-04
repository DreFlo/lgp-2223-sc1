import 'package:flutter/material.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/pages/tasks/project_show.dart';
import 'package:src/pages/tasks/task_show.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/utils/enums.dart';
import 'package:src/daos/timeslot/media_media_timeslot_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media.dart';

class DashboardCard extends StatefulWidget {
  final Task? task; //student
  final TaskGroup? taskGroup; //student
  final TimeslotMediaTimeslotSuperEntity? mediaEvent; //media
  final String module;
  final Function()? deleteCallback;
  final void Function() refreshCards;

  const DashboardCard(
      {Key? key,
      required this.module,
      this.task,
      this.taskGroup,
      this.mediaEvent,
      this.deleteCallback,
      required this.refreshCards})
      : super(key: key);

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  final Map<String, Color> moduleColors = {
    'Student': studentColor,
    'Leisure': leisureColor,
    'Personal': personalColor,
    'Fitness': fitnessColor,
  };
  String subjectOrDate = '';
  String taskDates = '';
  String institutionOrMediaType = '';
  int institutionId = 0;
  int nTasks = 0;
  List<MediaDBTypes> mediaTypes = [];
  List<int> mediaIds = [];
  bool isReady = false;

  late Task? task;
  late TaskGroup? taskGroup;
  late TimeslotMediaTimeslotSuperEntity? mediaEvent;

  @override
  void initState() {
    isReady = false;
    task = widget.task;
    taskGroup = widget.taskGroup;
    mediaEvent = widget.mediaEvent;
    super.initState();

    cardInformationUpdate();
  }

  void cardInformationUpdate() {
    Future.wait([
      getMediaIds().then((value) => setState(() {
            mediaIds = value;
            getMediaTypes().then((value) => setState(() {
                  mediaTypes = value;
                }));
          })),
      getSubjectOrDate().then((value) => setState(() {
            subjectOrDate = value;
            getInstitutionOrMediaType().then((value) => setState(() {
                  institutionOrMediaType = value;
                }));
          })),
      getNTasks().then((value) => setState(() {
            nTasks = value;
          })),
    ]).then((value) => setState(() {
          isReady = true;
          taskDates = getTaskDate();
        }));
  }

  String getTitle() {
    if (task != null) {
      return task!.name;
    } else if (taskGroup != null) {
      return taskGroup!.name;
    } else if (mediaEvent != null) {
      return mediaEvent!.title;
    } else {
      return '';
    }
  }

  Future<int> getNTasks() async {
    if (taskGroup != null) {
      return await serviceLocator<TaskDao>()
              .countTasksByTaskGroupId(taskGroup?.id ?? 0) ??
          0;
    } else {
      return 0;
    }
  }

  Future<String> getSubjectOrDate() async {
    if (task != null) {
      return await loadSubject();
    } else if (taskGroup != null) {
      return await loadSubject();
    } else if (mediaEvent != null) {
      String startDate =
          "${mediaEvent!.startDateTime.day.toString()}/${mediaEvent!.startDateTime.month.toString()}";

      return startDate;
    } else {
      return '';
    }
  }

  String getTaskDate() {
    String date = '';
    if (task != null) {
      date =
          "${task!.deadline.day.toString()}/${task!.deadline.month.toString()}";
      return date;
    } else if (taskGroup != null) {
      date =
          "${taskGroup!.deadline.day.toString()}/${taskGroup!.deadline.month.toString()}";
      return date;
    }
    return date;
  }

  Future<String> getInstitutionOrMediaType() async {
    institutionOrMediaType = '';
    if (task != null) {
      return await loadInstitution();
    } else if (taskGroup != null) {
      return await loadInstitution();
    } else if (mediaEvent != null) {
      return mediaTypes.length.toString();
    } else {
      return '';
    }
  }

  Future<String> loadSubject() async {
    subjectOrDate = '';
    int? id;
    if (task != null) {
      id = task?.subjectId;
    } else if (taskGroup != null) {
      id = taskGroup?.subjectId;
    }
    if (id != null) {
      final subjectStream = serviceLocator<SubjectDao>().findSubjectById(id);
      Subject? firstNonNullSubject = await subjectStream
          .firstWhere((subject) => subject != null, orElse: () => null);
      institutionId = firstNonNullSubject?.institutionId ?? 0;
      return firstNonNullSubject?.acronym ?? '';
    }
    return '';
  }

  Future<String> loadInstitution() async {
    if (institutionId != 0) {
      final institutionStream =
          serviceLocator<InstitutionDao>().findInstitutionById(institutionId);
      Institution? firstNonNullInstitution = await institutionStream
          .firstWhere((institution) => institution != null, orElse: () => null);
      return firstNonNullInstitution?.name ?? '';
    }
    return '';
  }

  Future<List<int>> getMediaIds() async {
    if (mediaEvent != null) {
      return await serviceLocator<MediaMediaTimeslotDao>()
          .findMediaIdByMediaTimeslotId(mediaEvent!.id ?? 0);
    } else {
      return [];
    }
  }

  Future<List<MediaDBTypes>> getMediaTypes() async {
    if (mediaEvent != null) {
      List<MediaDBTypes> mediaTypes = [];
      for (int id in mediaIds) {
        final mediaStream = serviceLocator<MediaDao>().findMediaById(id);
        Media? firstNonNullMedia = await mediaStream
            .firstWhere((media) => media != null, orElse: () => null);
        mediaTypes.add(firstNonNullMedia?.type ?? MediaDBTypes.book);
      }
      return mediaTypes;
    }
    return [];
  }

  String mediaDBTypeToString(MediaDBTypes type) {
    if (type == MediaDBTypes.book) {
      return 'Book';
    } else if (type == MediaDBTypes.movie) {
      return 'Movie';
    } else if (type == MediaDBTypes.series) {
      return 'TV Show';
    } else {
      return '';
    }
  }

  Widget mediaTypesOrInstitutionContainer() {
    if (task != null || taskGroup != null) {
      if (institutionOrMediaType == '0') {
        return Container();
      }
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: darkGrayBackground,
        ),
        child: Text(
          institutionOrMediaType,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: moduleColors[widget.module],
              ),
        ),
      );
    } else if (mediaEvent != null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: mediaTypes
              .map((MediaDBTypes type) => Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: darkGrayBackground,
                      ),
                      child: Text(
                        mediaDBTypeToString(type),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: moduleColors[widget.module]),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.module == 'Leisure' &&
            institutionOrMediaType == '' &&
            subjectOrDate == '') ||
        !(widget.module == 'Student' && taskDates == '')) {
      isReady = true;
      return GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color(0xFF22252D),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    child: DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.60,
                      minChildSize: 0.60,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) =>
                          getShowCard(context, scrollController),
                    )));
            // TODO: Navigate to project page
          },
          child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: grayButton,
              ),
              child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(bottom: 9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: moduleColors[widget.module],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            child: Text(
                              getTitle(),
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  flex: 2,
                                  child: Wrap(
                                    spacing: 10,
                                    // runSpacing: 5,
                                    children: [
                                      institutionOrMediaType != ''
                                          ? mediaTypesOrInstitutionContainer()
                                          : Container(),
                                      subjectOrDate != ''
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: darkGrayBackground,
                                              ),
                                              child: Text(
                                                subjectOrDate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge
                                                    ?.copyWith(
                                                      color: moduleColors[
                                                          widget.module],
                                                    ),
                                              ),
                                            )
                                          : Container(),
                                      taskDates != ''
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: darkGrayBackground,
                                              ),
                                              child: Text(
                                                taskDates,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge
                                                    ?.copyWith(
                                                      color: moduleColors[
                                                          widget.module],
                                                    ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )),
                              Flexible(
                                flex: 1,
                                child: nTasks != 0
                                    ? Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: primaryColor,
                                        ),
                                        child: Center(
                                            child: Text(nTasks.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge)),
                                      )
                                    : Container(),
                              ),
                            ])
                      ]))));
    }
    isReady = false;
    return Container();
  }

  getShowCard(BuildContext context, ScrollController scrollController) {
    if (task != null) {
      return TaskShow(
        task: task!,
        scrollController: scrollController,
        callback: editTask,
        deleteCallback: widget.deleteCallback,
      );
    } else if (taskGroup != null) {
      return ProjectShow(
          taskGroup: taskGroup!,
          scrollController: scrollController,
          callback: editTaskGroup,
          deleteCallback: widget.deleteCallback);
    } else if (mediaEvent != null) {
      //TODO MediaShow
      // return MediaShow(
      //   scrollController: scrollController,
      // );
    } else {
      return const SizedBox();
    }
  }

  editTask(Task t) {
    setState(() {
      task = t;
      cardInformationUpdate();
      widget.refreshCards();
    });
  }

  editTaskGroup(TaskGroup tg) {
    setState(() {
      taskGroup = tg;
      cardInformationUpdate();
      widget.refreshCards();
    });
  }
}
