import 'package:flutter/material.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';

class ProjectCard extends StatefulWidget {
  final Task? task;
  final TaskGroup? taskGroup;

  const ProjectCard({Key? key, this.task, this.taskGroup}) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  String subjectOrDate = '';
  String taskDates = '';
  String institutionType = '';
  int institutionId = 0;
  int nTasks = 0;
  bool isReady = false;

  late Task? task;
  late TaskGroup? taskGroup;

  @override
  void initState() {
    isReady = false;
    task = widget.task;
    taskGroup = widget.taskGroup;
    super.initState();

    cardInformationUpdate();
  }

  void cardInformationUpdate() {
    Future.wait([
      getSubjectOrDate().then((value) => setState(() {
            subjectOrDate = value;
            getInstitutionType().then((value) => setState(() {
                  institutionType = value;
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

  Future<String> getInstitutionType() async {
    institutionType = '';
    if (task != null) {
      return await loadInstitution();
    } else if (taskGroup != null) {
      return await loadInstitution();
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

  Widget institutionContainer() {
    if (task != null || taskGroup != null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: grayBackground,
        ),
        child: Text(
          institutionType,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: studentColor,
              ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(taskDates == '')) {
      isReady = true;
      return Container(
          margin: const EdgeInsets.all(5),
          child: Container(
              margin: const EdgeInsets.all(12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      margin: const EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: studentColor,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          getTitle(),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 10),
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
                                  institutionType != ''
                                      ? institutionContainer()
                                      : Container(),
                                  subjectOrDate != ''
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: grayBackground,
                                          ),
                                          child: Text(
                                            subjectOrDate,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge
                                                ?.copyWith(
                                                  fontSize: 5,
                                                  color: studentColor,
                                                ),
                                          ),
                                        )
                                      : Container(),
                                  taskDates != ''
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: grayBackground,
                                          ),
                                          child: Text(
                                            taskDates,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge
                                                ?.copyWith(
                                                  fontSize: 8,
                                                  color: studentColor,
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
                                    width: 20,
                                    height: 20,
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
                  ])));
    }
    isReady = false;
    return Container();
  }
}
