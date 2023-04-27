import 'package:flutter/material.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/daos/student/subject_dao.dart';

class DashboardCard extends StatefulWidget {
  final Task? task; //student
  final TaskGroup? taskGroup; //student
  final TimeslotMediaTimeslotSuperEntity? mediaEvent; //media
  final String module;

  const DashboardCard(
      {Key? key,
      required this.module,
      this.task,
      this.taskGroup,
      this.mediaEvent})
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
  String dateTasks = '';
  String institutionOrMediaType = '';
  int institutionId = 0;
  int nTasks = 0;

  @override
  void initState() {
    super.initState();
    getSubjectOrDate().then((value) => setState(() {
          subjectOrDate = value;
          getInstitutionOrMediaType().then((value) => setState(() {
                institutionOrMediaType = value;
              }));
        }));
    getNTasks().then((value) => setState(() {
          nTasks = value;
        }));
    dateTasks = getTaskDate();
  }

  String getTitle() {
    if (widget.task != null) {
      return widget.task!.name;
    } else if (widget.taskGroup != null) {
      return widget.taskGroup!.name;
    } else if (widget.mediaEvent != null) {
      return widget.mediaEvent!.title;
    } else {
      return '';
    }
  }

  Future<int> getNTasks() async {
    if (widget.taskGroup != null) {
      return await serviceLocator<TaskDao>()
              .countTasksByTaskGroupId(widget.taskGroup?.id ?? 0) ??
          0;
    } else {
      return 0;
    }
  }

  Future<String> getSubjectOrDate() async {
    if (widget.task != null) {
      return await loadSubject();
    } else if (widget.taskGroup != null) {
      return await loadSubject();
    } else if (widget.mediaEvent != null) {
      String startDate =
          "${widget.mediaEvent!.startDateTime.day.toString()}/${widget.mediaEvent!.startDateTime.month.toString()}";

      return startDate;
    } else {
      return '';
    }
  }

  String getTaskDate() {
    String date = '';
    if (widget.task != null) {
      date =
          "${widget.task!.deadline.day.toString()}/${widget.task!.deadline.month.toString()}";
      return date;
    } else if (widget.taskGroup != null) {
      date =
          "${widget.taskGroup!.deadline.day.toString()}/${widget.taskGroup!.deadline.month.toString()}";
      return date;
    }
    return date;
  }

  Future<String> getInstitutionOrMediaType() async {
    if (widget.task != null) {
      return await loadInstitution();
    } else if (widget.taskGroup != null) {
      return await loadInstitution();
    } else if (widget.mediaEvent != null) {
      return widget.mediaEvent!.type;
    } else {
      return '';
    }
  }

  Future<String> loadSubject() async {
    int? id;
    if (widget.task != null) {
      id = widget.task?.subjectId;
    } else if (widget.taskGroup != null) {
      id = widget.taskGroup?.subjectId;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
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
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: grayBackground,
                                            ),
                                            child: Text(
                                              institutionOrMediaType,
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
                                    subjectOrDate != ''
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: grayBackground,
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
                                    dateTasks != ''
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: grayBackground,
                                            ),
                                            child: Text(
                                              dateTasks,
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
                                        borderRadius: BorderRadius.circular(30),
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
}
