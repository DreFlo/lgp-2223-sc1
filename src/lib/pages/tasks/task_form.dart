// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/note_task_note_super_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/note_task_note_super_entity.dart';
import 'package:src/models/notes/task_note.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/notes/add_task_note_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';
import 'dart:math' as Math;
import 'package:src/utils/enums.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/error_text.dart';
import 'package:src/widgets/notes/note_bar.dart';

class TaskForm extends StatefulWidget {
  final int? id;
  final Task? task;
  final int? taskGroupId;
  final void Function(Task t)? callback;
  final void Function()? deleteCallback;
  final void Function(List<Note>)? editNotesCallback;
  final ScrollController scrollController;
  final bool createProject;

  const TaskForm(
      {Key? key,
      required this.scrollController,
      this.id,
      this.taskGroupId,
      this.callback,
      this.editNotesCallback,
      this.deleteCallback,
      this.task,
      this.createProject = true})
      : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  TextEditingController titleController = TextEditingController();
  late String? title, dueDate, description;
  late DateTime? date;
  late Priority? priority;
  late Institution institution;
  late Subject? subject;
  late TaskGroup? taskGroup;
  late int? id;
  bool init = false;

  TaskGroup taskGroupNone = TaskGroup(
      id: -1,
      name: "None",
      description: "",
      priority: Priority.high,
      deadline: DateFormatter.day(DateTime.now()));
  Institution institutionNone =
      Institution(id: -1, name: 'None', type: InstitutionType.other, userId: 0);
  Subject subjectNone = Subject(
    id: -1,
    name: 'None',
    acronym: 'None',
  );

  List<Note> notes = [];
  List<Note> toRemoveNotes = [];
  Map<String, String> errors = {};

  Future<int> initData() async {
    if (init) {
      return 0;
    }
    id = widget.id;
    if (id != null) {
      //Edit created task
      //Edit created task from created project
      Task task =
          await serviceLocator<TaskDao>().findTaskById(id!).first as Task;
      titleController.text = task.name;
      date = task.deadline;
      dueDate = DateFormatter.format(date!);
      priority = task.priority;
      description = task.description;

      if (task.subjectId != null) {
        subject = await serviceLocator<SubjectDao>()
            .findSubjectById(task.subjectId!)
            .first as Subject;
        if (subject!.institutionId != null) {
          institution = await serviceLocator<InstitutionDao>()
              .findInstitutionById(subject!.institutionId!)
              .first as Institution;
        } else {
          institution = institutionNone;
        }
      } else {
        institution = institutionNone;
        subject = subjectNone;
      }

      if (task.taskGroupId != null) {
        taskGroup = await serviceLocator<TaskGroupDao>()
            .findTaskGroupById(task.taskGroupId!)
            .first as TaskGroup;
      } else {
        taskGroup = taskGroupNone;
      }

      List<TaskNote> taskNotes =
          await serviceLocator<TaskNoteDao>().findTaskNotesByTaskId(task.id!);

      for (int i = 0; i < taskNotes.length; i++) {
        notes.add(await serviceLocator<NoteDao>()
            .findNoteById(taskNotes[i].id)
            .first as Note);
      }
      notes.sort((a, b) => a.date.isBefore(b.date) ? 1 : -1);
    } else {
      // Create task
      // Create task from created project
      // Create task from non-created project
      // Edit task from non-created project

      if (widget.task != null) {
        // Edit task from non-created project
        titleController.text = widget.task!.name;
        date = widget.task!.deadline;
        dueDate = DateFormatter.format(date!);
        priority = widget.task!.priority;
        description = widget.task!.description;
        notes = [];
        //Non created project: Can't select institution, subject, task group
      } else {
        // Create task
        // Create task from non-created project
        // Create task from created project
        titleController.text = 'Your new task';
        date = DateTime.now();
        date = DateTime(date!.year, date!.month, date!.day);
        dueDate = DateFormatter.format(date!);
        priority = null;
        description = "Your new task description";
        notes = [];
        if (widget.taskGroupId != null) {
          // Create task from created project
          taskGroup = await serviceLocator<TaskGroupDao>()
              .findTaskGroupById(widget.taskGroupId!)
              .first as TaskGroup;
          if (taskGroup!.subjectId != null) {
            subject = await serviceLocator<SubjectDao>()
                .findSubjectById(taskGroup!.subjectId!)
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
        } else {
          // Create task (base case)
          // Create task from non-created project
          // Distinction will be made on the options for the user through isChildOfNotCreated()
          institution = institutionNone;
          subject = subjectNone;
          taskGroup = taskGroupNone;
        }
      }
    }

    init = true;
    return 0;
  }

  @override
  initState() {
    super.initState();
  }

  validateDate() {
    DateTime now = DateTime.now();
    now = DateFormatter.day(now);

    if (taskGroup!.id != -1) {
      if (date!.isAfter(taskGroup!.deadline)) {
        errors['date'] =
            AppLocalizations.of(context).studentErrorTaskGroupAfterDate;
      }
    } else if (isChildOfNotCreated()) {
      // The not created project will change the date to the earliest date between this and the project itself
    } else {
      if (now.isAfter(date!)) {
        errors['date'] = AppLocalizations.of(context).studentErrorPastDate;
      }
    }
  }

  validate() {
    errors = {};
    if (titleController.text == "") {
      errors['title'] = AppLocalizations.of(context).studentErrorTitle;
    }

    if (priority == null) {
      errors['priority'] = AppLocalizations.of(context).studentErrorPriority;
    }
    validateDate();
    if (institution.id != -1 && subject!.id == -1) {
      // Must either not have an institution and no subject
      // Or have both an institution and a subject
      errors['subject'] = AppLocalizations.of(context).studentErrorSubject;
    }
  }

  Future<int> save(BuildContext context) async {
    int badgeReturn = 0;
    validate();
    if (errors.isNotEmpty) {
      widget.scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      setState(() {});
      return 0;
    }
    Task task;
    int? subjectId, taskGroupId;
    if (subject!.id != -1) {
      subjectId = subject!.id;
    } else {
      subjectId = null;
    }
    if (taskGroup!.id != -1) {
      taskGroupId = taskGroup!.id;
    } else {
      taskGroupId = null;
    }

    int? newId;
    if (id == null) {
      task = Task(
          name: titleController.text,
          deadline: date!,
          priority: priority!,
          subjectId: subjectId,
          description: description!,
          taskGroupId: taskGroupId,
          finished: false,
          xp: 0);
      newId = await serviceLocator<TaskDao>().insertTask(task);

      // check if it's the first task ever
      if (await serviceLocator<TaskDao>().countTasks() == 1) {
        // check if the user has the badge
        bool hasBadge = await checkUserHasBadge(1);
        if (!hasBadge) {
          // win badge + show badge
          //unlockBadgeForUser(1, context);
          badgeReturn = 1;
        }
      }
    } else {
      task = Task(
          id: id,
          name: titleController.text,
          deadline: date!,
          priority: priority!,
          subjectId: subjectId,
          description: description!,
          taskGroupId: taskGroupId,
          finished: false,
          xp: 0);
      await serviceLocator<TaskDao>().updateTask(task);
    }

    //Save notes
    if (id != null) {
      // Notes are being updated directly upon edit
      for (int i = 0; i < notes.length; i++) {
        Note note = notes[i];
        if (toRemoveNotes.contains(note)) {
          NoteTaskNoteSuperEntity noteTaskNoteSuperEntity =
              NoteTaskNoteSuperEntity(
                  id: note.id,
                  title: note.title,
                  content: note.content,
                  date: note.date,
                  taskId: id!);
          await serviceLocator<NoteTaskNoteSuperDao>()
              .deleteNoteTaskNoteSuperEntity(noteTaskNoteSuperEntity);
        }
      }
    } else {
      // Create notes for the task that was just made
      for (int i = 0; i < notes.length; i++) {
        Note note = notes[i];
        if (toRemoveNotes.contains(note)) {
          continue;
        } else {
          NoteTaskNoteSuperEntity noteTaskNoteSuperEntity =
              NoteTaskNoteSuperEntity(
                  title: note.title,
                  content: note.content,
                  date: note.date,
                  taskId: newId!);
          await serviceLocator<NoteTaskNoteSuperDao>()
              .insertNoteTaskNoteSuperEntity(noteTaskNoteSuperEntity);
        }
      }
    }

    if (widget.callback != null) {
      widget.callback!(task);
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      //unlockBadgeForUser(3, context); //streak
      badgeReturn = 3;
    }

    if (badgeReturn == 0) {
      // My idea
      // Create here the new notes
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    return badgeReturn;
  }

  delete(BuildContext context) async {
    if (id != null) {
      Task task =
          await serviceLocator<TaskDao>().findTaskById(id!).first as Task;
      serviceLocator<TaskDao>().deleteTask(task);
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(3);
      if (context.mounted) {
        Navigator.pop(context);
      }
      return;
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
                              const Icon(Icons.task,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Text(AppLocalizations.of(context).task,
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
                    // priority
                    ...getPriority(context),
                    const SizedBox(height: 30),
                    ...getDate(context),
                    const SizedBox(height: 30),
                    // Project
                    getProject(context),
                    const SizedBox(height: 30),
                    // Insitution
                    getInstitution(context),
                    const SizedBox(height: 30),
                    // Subject
                    ...getSubject(),
                    const SizedBox(height: 30),
                    ...getLabelDescription(context),
                    const SizedBox(height: 7.5),
                    getDescription(),
                    const SizedBox(height: 30),
                    getAddNoteButton(context),
                    const SizedBox(height: 7.5),
                    ...getNotes(),
                    const SizedBox(height: 30),
                    getEndButtons(context),
                  ]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Row getDescription() {
    return Row(children: [
      Flexible(
          flex: 1,
          child: TextField(
            key: const Key('taskDescription'),
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
      Expanded(
          flex: 5,
          child: TextField(
              key: const Key('taskTitle'),
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

  List<Widget> getLabelDescription(BuildContext context) {
    Widget descriptionWidget = Row(children: [
      Text(AppLocalizations.of(context).description,
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF71788D),
              fontSize: 16,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
    ]);
    bool isError = errors.containsKey('description');
    if (!isError) {
      return [descriptionWidget];
    }
    Widget errorWidget = ErrorText(text: errors['description']!);
    return [descriptionWidget, errorWidget];
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
                          Text(
                              (dueDate == null
                                  ? DateTime.now().toString()
                                  : dueDate!),
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
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
      Expanded(
          flex: 5,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)))
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)))
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)))
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

  Widget getProject(BuildContext context) {
    if (isChildOfNotCreated()) {
      return const SizedBox();
    }
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
                  Icons.list_rounded,
                  color: Color(0xFF71788D),
                  size: 20,
                ))
          ])),
      const SizedBox(width: 15),
      Flexible(
          flex: 5,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(children: [
              Text(AppLocalizations.of(context).project,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                      key: ValueKey(taskGroup),
                      future:
                          serviceLocator<TaskGroupDao>().findAllTaskGroups(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<TaskGroup>> snapshot) {
                        return projectFutureBuilder(snapshot);
                      }),
                ],
              ))
            ])
          ]))
    ]));
  }

  Widget projectFutureBuilder(AsyncSnapshot<List<TaskGroup>> snapshot) {
    if (isChild()) {
      return DropdownMenuItem<TaskGroup>(
          key: const Key('taskTaskGroup'),
          value: taskGroup,
          child: Text(taskGroup!.name,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF71788D),
                  fontSize: 16,
                  fontWeight: FontWeight.w400)));
    }
    if (snapshot.hasData) {
      bool taskGroupFound = false;
      bool taskGroupNoneFound = false;
      for (final i in snapshot.data!) {
        if (i.id == taskGroup!.id) {
          taskGroup = i;
          taskGroupFound = true;
        }
        if (i.id == taskGroupNone.id) {
          taskGroupNoneFound = true;
        }
      }
      if (!taskGroupFound) {
        taskGroup = taskGroupNone;
      }
      if (!taskGroupNoneFound) {
        snapshot.data!.insert(0, taskGroupNone);
      }

      return DropdownButton<TaskGroup>(
        key: const Key('taskTaskGroup'),
        value: taskGroup,
        isExpanded: true,
        items: snapshot.data!.map((t) {
          return DropdownMenuItem<TaskGroup>(
              value: t,
              child: Text(t.name,
                  key: Key("taskTaskGroup_${t.name}"),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center));
        }).toList(),
        onChanged: (TaskGroup? newTaskGroup) async {
          if (taskGroup!.id != newTaskGroup!.id) {
            //We might have changes to institution/subject
            if (newTaskGroup.subjectId == null) {
              institution = institutionNone;
              subject = subjectNone;
            } else {
              subject = await serviceLocator<SubjectDao>()
                  .findSubjectById(newTaskGroup.subjectId!)
                  .first as Subject;
              if (subject!.institutionId == null) {
                institution = institutionNone;
              } else {
                institution = await serviceLocator<InstitutionDao>()
                    .findInstitutionById(subject!.institutionId!)
                    .first as Institution;
              }
            }
          }
          taskGroup = newTaskGroup;

          setState(() {
            institution = institution;
            subject = subject;
            taskGroup = taskGroup;
          });
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getInstitution(BuildContext context) {
    if (isChildOfNotCreated()) {
      return const SizedBox();
    }
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
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                      key: ValueKey(institution),
                      future: serviceLocator<InstitutionDao>()
                          .findAllInstitutions(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Institution>> snapshot) {
                        return institutionFutureBuilder(snapshot);
                      }),
                ],
              ))
            ])
          ]))
    ]));
  }

  Widget institutionFutureBuilder(AsyncSnapshot<List<Institution>> snapshot) {
    if (isChild()) {
      if (subject == null) {
        return const SizedBox();
      }
      return DropdownMenuItem(
          key: const Key("taskInstitution"),
          value: institution,
          child: Text(institution.name,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF71788D),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center));
    }
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
        key: const Key('taskInstitution'),
        value: institution,
        isExpanded: true,
        items: snapshot.data!.map((i) {
          return DropdownMenuItem<Institution>(
              value: i,
              child: Text(i.name,
                  key: Key("taskInstitution_${i.name}"),
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
              taskGroup = taskGroupNone;
              subject = subjectNone;
            }
            institution = newInstitution;
          });
        },
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> getSubject() {
    if (isChildOfNotCreated()) {
      return [];
    }
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
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                      key: ValueKey(subject),
                      future: institution.id == -1
                          ? serviceLocator<SubjectDao>()
                              .findSubjectByInstitutionIdNull()
                          : serviceLocator<SubjectDao>()
                              .findSubjectByInstitutionId(institution.id!),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Subject>> snapshot) {
                        return subjectFutureBuilder(snapshot);
                      }),
                ],
              ))
            ])
          ]))
    ]));
    bool isError = errors.containsKey('subject');
    if (!isError) {
      return [subjectWidget];
    }
    Widget errorWidget = ErrorText(text: errors['subject']!);
    return [subjectWidget, errorWidget];
  }

  Widget subjectFutureBuilder(AsyncSnapshot<List<Subject>> snapshot) {
    if (isChild()) {
      if (subject == null) {
        return const SizedBox();
      }
      return DropdownMenuItem(
          key: const Key('taskSubject'),
          value: subject!,
          child: Text(subject!.name,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF71788D),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center));
    }
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
        key: const Key('taskSubject'),
        value: subject,
        isExpanded: true,
        items: snapshot.data!.map((s) {
          return DropdownMenuItem<Subject>(
              value: s,
              child: Text(s.acronym,
                  key: Key("taskSubject_${s.acronym}"),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF71788D),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center));
        }).toList(),
        onChanged: (Subject? newSubject) {
          setState(() {
            taskGroup = taskGroupNone;
            subject = newSubject!;
          });
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getAddNoteButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(AppLocalizations.of(context).notes,
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF71788D),
              fontSize: 16,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
      IconButton(
        key: const Key('addNoteButton'),
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
              builder: (builder) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                  child: SingleChildScrollView(
                      child: AddTaskNoteForm(taskId: id, callback: addNote))));
        },
      ),
    ]);
  }

  List<Widget> getNotes() {
    List<Widget> notesList = [];

    if (notes.isEmpty && !widget.createProject) {
      notesList.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppLocalizations.of(context).no_notes,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal))
      ]));
    } else {
      for (int i = 0; i < notes.length; i++) {
        notesList.add(NoteBar(
          key: ValueKey(notes[i]),
          taskId: id,
          note: notes[i],
          onSelected: removeNote,
          onUnselected: unremoveNote,
          editNote: id == null ? editTempNoteFactory(notes[i]) : editNote,
          deleteNote: deleteNote,
        ));

        notesList.add(const SizedBox(height: 10));
      }
    }
    return notesList;
  }

  Widget getEndButtons(BuildContext context) {
    if (widget.id == null) {
      return ElevatedButton(
          key: const Key('taskSaveButton'),
          onPressed: () async {
            int badge = await save(context);
            if (badge != 0) {
              callBadgeWidget(badge);
            }
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
              key: const Key('taskSaveButton'),
              onPressed: () async {
                int badge = await save(context);
                if (badge != 0) {
                  callBadgeWidget(badge);
                }
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
              key: const Key('taskDeleteButton'),
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
        backgroundColor: Colors.red[600]
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
      title: Text(AppLocalizations.of(context).delete_task,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      content: Text(AppLocalizations.of(context).delete_task_message,
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

  addNote(Note note) {
    setState(() {
      notes.insert(0, note);
    });
    editNotesCallback();
  }

  removeNote(Note note) {
    setState(() {
      toRemoveNotes.add(note);
    });
  }

  unremoveNote(Note note) {
    setState(() {
      toRemoveNotes.remove(note);
    });
  }

  editNote(Note note) {
    setState(() {
      if (id != null) {
        // Our notes have an id and were updated in the addTaskNoteForm
        for (int i = 0; i < notes.length; i++) {
          if (notes[i].id == note.id) {
            notes[i] = note;
            break;
          }
        }
      } else {
        throw Exception("Task id is null for edit note callback");
      }
      editNotesCallback();
    });
  }

  editTempNoteFactory(Note oldNote) {
    return (Note note) {
      setState(() {
        if (id == null) {
          for (int i = 0; i < notes.length; i++) {
            if (notes[i] == oldNote) {
              notes[i] = note;
              break;
            }
          }
        } else {
          throw Exception("Task id is not null for edit temp note callback");
        }
      });
      editNotesCallback();
    };
  }

  deleteNote(Note note) {
    setState(() {
      notes.remove(note);
      toRemoveNotes.remove(note);
    });
    editNotesCallback();
  }

  isChild() {
    //If we are making a new task inside of a taks group
    return widget.taskGroupId != null;
  }

  isChildOfNotCreated() {
    return widget.taskGroupId == -1;
  }

  editNotesCallback() {
    if (widget.editNotesCallback != null) {
      widget.editNotesCallback!(notes);
    }
  }

  callBadgeWidget(int badge) {
    unlockBadgeForUser(badge, context);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
