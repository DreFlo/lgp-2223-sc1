// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';
import 'dart:math' as Math;
import 'package:src/utils/enums.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/error_text.dart';
import 'package:src/widgets/tasks/task_bar.dart';

class ProjectForm extends StatefulWidget {
  final int? id;
  final void Function(TaskGroup tg)? callback;
  final void Function()? deleteCallback;
  final void Function(List<Task>)? editTasksCallback;
  final ScrollController scrollController;

  const ProjectForm(
      {Key? key,
      required this.scrollController,
      this.id,
      this.callback,
      this.deleteCallback,
      this.editTasksCallback})
      : super(key: key);

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  TextEditingController titleController = TextEditingController();
  late List<List<dynamic>>? priorities;
  String? dueDate, projectTitle, description;
  late DateTime? date;
  late int? id, institutionId, subjectId;
  late Priority? priority;
  late Institution institution;
  late Subject? subject;
  late bool init = false;

  Institution institutionNone =
      Institution(id: -1, name: 'None', type: InstitutionType.other, userId: 0);
  Subject subjectNone = Subject(
    id: -1,
    name: 'None',
    acronym: 'None',
  );

  List<Task> tasks = [];
  List<Task> toRemoveTasks = [];
  Map<String, String> errors = {};

  Future<int> initData() async {
    if (init) {
      return 0;
    }
    id = widget.id;
    if (id != null) {
      TaskGroup taskGroup = await serviceLocator<TaskGroupDao>()
          .findTaskGroupById(id!)
          .first as TaskGroup;
      titleController.text = taskGroup.name;
      date = taskGroup.deadline;
      dueDate = DateFormatter.format(date!);
      priority = taskGroup.priority;
      description = taskGroup.description;
      if (taskGroup.subjectId != null) {
        subject = await serviceLocator<SubjectDao>()
            .findSubjectById(taskGroup.subjectId!)
            .first as Subject;
        if (subject!.institutionId != null) {
          institution = await serviceLocator<InstitutionDao>()
              .findInstitutionById(subject!.institutionId!)
              .first as Institution;
        } else {
          institution = institutionNone;
        }
      } else {
        subject = subjectNone;
        institution = institutionNone;
      }

      //Tasks
      tasks = await serviceLocator<TaskDao>().findTasksByTaskGroupId(id!);
      tasks.sort((a, b) => a.deadline.isBefore(b.deadline) ? 1 : -1);
    } else {
      titleController.text = 'Your new Project';
      date = DateTime.now();
      date = DateTime(date!.year, date!.month, date!.day);
      dueDate = DateFormatter.format(date!);
      priority = null;
      description = 'A description';
      subject = subjectNone;
      institution = institutionNone;
    }
    init = true;

    return 0;
  }

  @override
  initState() {
    super.initState();
  }

  validate() {
    errors = {};
    if (titleController.text == "") {
      AppLocalizations.of(context).studentErrorTitle;
    }

    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    if (date!.isBefore(now)) {
      errors['date'] = AppLocalizations.of(context).studentErrorPastDate;
    }
    if (priority == null) {
      errors['priority'] = AppLocalizations.of(context).studentErrorPriority;
    }
    if (institution.id != -1 && subject!.id == -1) {
      // Must either not have an institution and no subject
      // Or have both an institution and a subject
      errors['subject'] = AppLocalizations.of(context).studentErrorSubject;
    }
  }

  save(BuildContext context) async {
    validate();
    if (errors.isNotEmpty) {
      widget.scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      setState(() {});
      return;
    }
    TaskGroup taskGroup;
    int? subjectId;
    if (subject!.id != -1) {
      subjectId = subject!.id;
    } else {
      subjectId = null;
    }

    int? newId;
    if (id == null) {
      taskGroup = TaskGroup(
        name: titleController.text,
        deadline: date!,
        priority: priority!,
        subjectId: subjectId,
        description: description!,
      );
      newId = await serviceLocator<TaskGroupDao>().insertTaskGroup(taskGroup);
    } else {
      taskGroup = TaskGroup(
        id: id,
        name: titleController.text,
        deadline: date!,
        priority: priority!,
        subjectId: subjectId,
        description: description!,
      );
      await serviceLocator<TaskGroupDao>().updateTaskGroup(taskGroup);
    }

    if (id == null) {
      for (int i = 0; i < tasks.length; i++) {
        if (toRemoveTasks.contains(tasks[i])) {
          await serviceLocator<TaskDao>().deleteTask(tasks[i]);
        } else {
          Task oldTask = tasks[i];
          Task newTask = Task(
              id: oldTask.id,
              name: oldTask.name,
              deadline:
                  date!.isBefore(oldTask.deadline) ? date! : oldTask.deadline,
              priority: oldTask.priority,
              description: oldTask.description,
              taskGroupId: newId,
              subjectId: subjectId,
              finished: false,
              xp: oldTask.xp);
          await serviceLocator<TaskDao>().insertTask(newTask);
          // await serviceLocator<TaskDao>().updateTask(newTask);
        }
      }
    } else {
      for (int i = 0; i < tasks.length; i++) {
        if (toRemoveTasks.contains(tasks[i])) {
          await serviceLocator<TaskDao>().deleteTask(tasks[i]);
        }
      }
    }

    if (widget.callback != null) {
      widget.callback!(taskGroup);
    }

    if (context.mounted) {
      Navigator.pop(context);
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(); //streak
    }
  }

  delete(BuildContext context) async {
    if (id != null) {
      TaskGroup taskGroup = await serviceLocator<TaskGroupDao>()
          .findTaskGroupById(id!)
          .first as TaskGroup;
      await serviceLocator<TaskGroupDao>().deleteTaskGroup(taskGroup);
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(); //streak
    }

    if (widget.deleteCallback != null) {
      widget.deleteCallback!();
    }

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    priorities = [
      [Priority.low, AppLocalizations.of(context).low],
      [Priority.medium, AppLocalizations.of(context).medium],
      [Priority.high, AppLocalizations.of(context).high]
    ];
    return FutureBuilder(
        future: initData(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Wrap(spacing: 10, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            width: 115,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF414554),
                            ),
                          ))
                    ]),
                    Row(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xFF17181C),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10)),
                          child: Wrap(children: [
                            Row(children: [
                              const Icon(Icons.list_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Text(AppLocalizations.of(context).project,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ])
                          ]))
                    ]),
                    const SizedBox(height: 15),
                    ...getTitle(context),
                    const SizedBox(height: 30),
                    ...getDate(context),
                    const SizedBox(height: 30),
                    // Priority
                    ...getPriority(context),
                    const SizedBox(height: 30),
                    // Institution
                    getInstitution(context),
                    const SizedBox(height: 30),
                    //Subject
                    ...getSubject(),
                    const SizedBox(height: 30),

                    // Description
                    ...getDescription(),
                    const SizedBox(height: 30),
                    getAddTask(context),
                    const SizedBox(height: 7.5),
                    ...getTasks(),
                    const SizedBox(height: 30),
                    getEndButtons(context),
                  ]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<Widget> getTitle(BuildContext context) {
    Widget titleWidget =
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Flexible(
          flex: 1,
          child: Transform.rotate(
            angle: -Math.pi / 4,
            child:
                const Icon(Icons.square_rounded, size: 50, color: studentColor),
          )),
      const SizedBox(width: 15),
      Flexible(
          flex: 5,
          child: TextField(
              key: const Key('projectTitle'),
              controller: titleController,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF414554))),
                hintText: AppLocalizations.of(context).title,
                hintStyle: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF71788D),
                    fontWeight: FontWeight.w400),
              ))),
      const SizedBox(width: 5),
      Flexible(
          flex: 1,
          child: IconButton(
              color: Colors.white,
              splashRadius: 0.01,
              icon: const Icon(Icons.close),
              onPressed: () {
                titleController.clear();
              }))
    ]);
    bool isError = errors.containsKey('title');
    if (!isError) {
      return [titleWidget];
    }
    Widget errorWidget = ErrorText(text: errors['title']!);
    return [titleWidget, errorWidget];
  }

  List<Widget> getDate(BuildContext context) {
    Widget dateWidget = InkWell(
        //TODO: Maybe customize the splash?
        onTap: () async {
          var date = await showDatePicker(
              context: context,
              initialDate: id != null ? this.date! : DateTime.now(),
              firstDate: id != null ? this.date! : DateTime.now(),
              lastDate: DateTime(2100));
          if (date == null) {
            return;
          }
          setState(() {
            this.date = DateFormatter.day(date);
            dueDate = DateFormatter.format(this.date!);
          });
        },
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Flexible(
              flex: 1,
              child: Column(children: [
                Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF414554),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_month_sharp,
                      color: Color(0xFF71788D),
                      size: 20,
                    ))
              ])),
          const SizedBox(width: 15),
          Flexible(
              flex: 5,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(children: [
                  Text(AppLocalizations.of(context).due_date,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF71788D),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                ]),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      highlightColor: lightGray,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(dueDate!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal))
                        ],
                      ),
                    )
                  ],
                )
              ]))
        ]));
    bool isError = errors.containsKey('date');
    if (!isError) {
      return [dateWidget];
    }
    Widget errorWidget = ErrorText(text: errors['date']!);
    return [dateWidget, errorWidget];
  }

  List<Widget> getPriority(BuildContext context) {
    Widget priorityWidget =
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Flexible(
          flex: 1,
          child: Column(children: [
            Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF414554),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.priority_high_rounded,
                  color: Color(0xFF71788D),
                  size: 20,
                ))
          ])),
      const SizedBox(width: 15),
      Flexible(
          flex: 5,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(children: [
              Text(AppLocalizations.of(context).priority,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: InkWell(
                  highlightColor: lightGray,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          key: const Key('priorityLow'),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color: (priority == Priority.low
                                ? primaryColor
                                : lightGray),
                          ),
                          alignment: const Alignment(0, 0),
                          child: Text(AppLocalizations.of(context).low,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal)))
                    ],
                  ),
                  onTap: () {
                    priority = Priority.low;
                    setState(() {});
                  },
                )),
                const SizedBox(width: 5),
                Expanded(
                    child: InkWell(
                  highlightColor: lightGray,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          key: const Key('priorityMedium'),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          color: (priority == Priority.medium
                              ? primaryColor
                              : lightGray),
                          alignment: const Alignment(0, 0),
                          child: Text(AppLocalizations.of(context).medium,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal)))
                    ],
                  ),
                  onTap: () {
                    priority = Priority.medium;
                    setState(() {});
                  },
                )),
                const SizedBox(width: 5),
                Expanded(
                    child: InkWell(
                  highlightColor: lightGray,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          key: const Key('priorityHigh'),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: (priority == Priority.high
                                ? primaryColor
                                : lightGray),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          alignment: const Alignment(0, 0),
                          child: Text(AppLocalizations.of(context).high,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal)))
                    ],
                  ),
                  onTap: () {
                    priority = Priority.high;
                    setState(() {});
                  },
                )),
              ],
            )
          ]))
    ]);

    bool isError = errors.containsKey('priority');
    if (!isError) {
      return [priorityWidget];
    }
    Widget errorWidget = ErrorText(text: errors['priority']!);
    return [priorityWidget, errorWidget];
  }

  Widget getInstitution(BuildContext context) {
    return InkWell(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Flexible(
          flex: 1,
          child: Column(children: [
            Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF414554),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Color(0xFF71788D),
                  size: 20,
                ))
          ])),
      const SizedBox(width: 15),
      Flexible(
          flex: 5,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(children: [
              Text(AppLocalizations.of(context).institution,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      FutureBuilder(
                          future: serviceLocator<InstitutionDao>()
                              .findAllInstitutions(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Institution>> snapshot) {
                            if (snapshot.hasData) {
                              bool institutionFound = false;
                              bool institutionNoneFound = false;
                              for (final i in snapshot.data!) {
                                if (i.id == institution.id) {
                                  institution = i;
                                  institutionFound = true;
                                }
                                if (i.id == institutionNone.id) {
                                  institutionNoneFound = true;
                                }
                              }
                              if (!institutionFound) {
                                institution = institutionNone;
                              }
                              if (!institutionNoneFound) {
                                snapshot.data!.insert(0, institutionNone);
                              }

                              return DropdownButton<Institution>(
                                key: const Key('projectInstitution'),
                                value: institution,
                                isExpanded: true,
                                items: snapshot.data!.map((i) {
                                  return DropdownMenuItem<Institution>(
                                      value: i,
                                      child: Text(i.name,
                                          key: Key(
                                              'projectInstitution_${i.name}'),
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFF71788D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center));
                                }).toList(),
                                onChanged: (Institution? newInstitution) {
                                  setState(() {
                                    if (institution.id != newInstitution!.id) {
                                      subject = subjectNone;
                                    }
                                    institution = newInstitution;
                                  });
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ]))
              ],
            )
          ]))
    ]));
  }

  List<Widget> getSubject() {
    Widget subjectWidget = InkWell(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Flexible(
          flex: 1,
          child: Column(children: [
            Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF414554),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Color(0xFF71788D),
                  size: 20,
                ))
          ])),
      const SizedBox(width: 15),
      Flexible(
          flex: 5,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(children: [
              Text(AppLocalizations.of(context).subject,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      FutureBuilder(
                          future: institution.id == -1
                              ? serviceLocator<SubjectDao>()
                                  .findSubjectByInstitutionIdNull()
                              : serviceLocator<SubjectDao>()
                                  .findSubjectByInstitutionId(institution.id!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Subject>> snapshot) {
                            if (snapshot.hasData) {
                              bool subjectFound = false;
                              bool subjectNoneFound = false;

                              for (final s in snapshot.data!) {
                                if (s.id == subject!.id) {
                                  subject = s;
                                  subjectFound = true;
                                }
                                if (s.id == subjectNone.id) {
                                  subjectNoneFound = true;
                                }
                              }

                              if (!subjectFound) {
                                subject = subjectNone;
                              }
                              if (!subjectNoneFound) {
                                snapshot.data!.insert(0, subjectNone);
                              }

                              return DropdownButton<Subject>(
                                key: const Key('projectSubject'),
                                value: subject,
                                isExpanded: true,
                                items: snapshot.data!.map((s) {
                                  return DropdownMenuItem<Subject>(
                                      value: s,
                                      child: Text(s.acronym,
                                          key: Key(
                                              'projectSubject_${s.acronym}'),
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFF71788D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center));
                                }).toList(),
                                onChanged: (Subject? newSubject) {
                                  setState(() {
                                    subject = newSubject!;
                                  });
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    ]))
              ],
            )
          ]))
    ]));
    bool isError = errors.containsKey('subject');
    if (!isError) {
      return [subjectWidget];
    }
    Widget errorWidget = ErrorText(text: errors['subject']!);
    return [subjectWidget, errorWidget];
  }

  List<Widget> getDescription() {
    Widget descriptionLabelWidget = Row(children: [
      Text(AppLocalizations.of(context).description,
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF71788D),
              fontSize: 16,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
    ]);

    Widget descriptionWidget = Row(children: [
      Flexible(
          flex: 1,
          child: TextField(
            key: const Key('projectDescription'),
            controller: TextEditingController(text: description),
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.normal),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFF17181C),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            maxLines: 5,
            onChanged: (input) {
              description = input;
            },
          ))
    ]);

    bool isError = errors.containsKey('description');
    if (!isError) {
      return [
        descriptionLabelWidget,
        const SizedBox(height: 7.5),
        descriptionWidget
      ];
    }

    Widget errorWidget = ErrorText(text: errors['description']!);
    return [
      descriptionLabelWidget,
      const SizedBox(height: 7.5),
      descriptionWidget,
      errorWidget
    ];
  }

  Row getAddTask(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(AppLocalizations.of(context).tasks,
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF71788D),
              fontSize: 16,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
      IconButton(
        key: const Key('addTaskButton'),
        padding: const EdgeInsets.all(0),
        icon: const Icon(Icons.add),
        color: const Color(0xFF71788D),
        iconSize: 20,
        splashRadius: 0.1,
        constraints: const BoxConstraints(maxWidth: 20, maxHeight: 20),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: const Color(0xFF22252D),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.80,
                    minChildSize: 0.80,
                    maxChildSize: 0.85,
                    builder: (context, scrollController) => TaskForm(
                        taskGroupId: id ?? -1,
                        callback: addTask,
                        scrollController: scrollController,
                        createProject: true),
                  )));
        },
      )
    ]);
  }

  List<Widget> getTasks() {
    List<Widget> taskList = [];

    if (tasks.isEmpty) {
      taskList.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppLocalizations.of(context).no_tasks,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal))
      ]));
    } else {
      for (int i = 0; i < tasks.length; i++) {
        taskList.add(TaskBar(
          key: ValueKey(tasks[i]),
          taskStatus: true,
          task: tasks[i],
          onSelected: removeTask,
          onUnselected: unremoveTask,
          editTask: id == null ? editTempTask(tasks[i]) : editTask,
          deleteTask: deleteTask(tasks[i]),
          taskGroupId: id,
        ));

        taskList.add(const SizedBox(height: 10));
      }
    }

    return taskList;
  }

  Widget getEndButtons(BuildContext context) {
    if (widget.id == null) {
      return ElevatedButton(
          key: const Key('projectSaveButton'),
          onPressed: () async {
            await save(context);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(AppLocalizations.of(context).save,
              style: Theme.of(context).textTheme.headlineSmall));
    } else {
      return Row(
        children: [
          ElevatedButton(
              key: const Key('projectSaveButton'),
              onPressed: () async {
                await save(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 55),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(AppLocalizations.of(context).save,
                  style: Theme.of(context).textTheme.headlineSmall)),
          const SizedBox(width: 20),
          ElevatedButton(
              key: const Key('projectDeleteButton'),
              onPressed: () async {
                await showDeleteConfirmation(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 55),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(AppLocalizations.of(context).delete,
                  style: Theme.of(context).textTheme.headlineSmall))
        ],
      );
    }
  }

  showDeleteConfirmation(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      key: const Key('cancelConfirmationButton'),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
      ),
      child: Text(AppLocalizations.of(context).cancel,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget deleteButton = ElevatedButton(
      key: const Key('deleteConfirmationButton'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
      ),
      child: Text(AppLocalizations.of(context).delete,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      onPressed: () async {
        await delete(context);
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 0,
      title: Text(AppLocalizations.of(context).delete_task_group,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      content: Text(AppLocalizations.of(context).delete_task_group_message,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      actions: [
        cancelButton,
        deleteButton,
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: modalBackground,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  addTask(Task task) {
    setState(() {
      tasks.insert(0, task);
    });
    editTasksCallback();
  }

  removeTask(Task task) {
    setState(() {
      toRemoveTasks.add(task);
    });
  }

  unremoveTask(Task task) {
    setState(() {
      toRemoveTasks.remove(task);
    });
  }

  editTask(Task task) {
    setState(() {
      if (id != null) {
        for (int i = 0; i < tasks.length; i++) {
          if (tasks[i].id == task.id) {
            tasks[i] = task;
            break;
          }
        }
      } else {
        throw Exception("Task group id is null for edit task calblack");
      }
    });
    editTasksCallback();
  }

  editTempTask(Task oldTask) {
    return (Task task) {
      setState(() {
        if (id == null) {
          for (int i = 0; i < tasks.length; i++) {
            if (tasks[i] == oldTask) {
              tasks[i] = task;
              break;
            }
          }
        } else {
          throw Exception("Task id is not null for edit temp task calback");
        }
      });
      editTasksCallback();
    };
  }

  deleteTask(Task oldTask) {
    return () {
      setState(() {
        for (int i = 0; i < tasks.length; i++) {
          if (tasks[i].id == oldTask.id) {
            tasks.removeAt(i);
            break;
          }
        }
        for (int i = 0; i < toRemoveTasks.length; i++) {
          if (toRemoveTasks[i].id == oldTask.id) {
            toRemoveTasks.removeAt(i);
            break;
          }
        }
      });
      editTasksCallback();
    };
  }

  editTasksCallback() {
    if (widget.editTasksCallback != null) {
      widget.editTasksCallback!(tasks);
    }
  }

  callBadgeWidget() {
    unlockBadgeForUser(3, context);
  }
}
