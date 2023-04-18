// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
import 'dart:math' as Math;
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/note_bar.dart';

final DateFormat formatter = DateFormat('dd/MM/yyyy');

class TaskForm extends StatefulWidget {
  final int? id;
  final ScrollController scrollController;

  const TaskForm({
    Key? key,
    required this.scrollController,
    this.id,
  }) : super(key: key);

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

  Institution institutionNone =
      Institution(id: -1, name: 'None', type: InstitutionType.other, userId: 1);
  TaskGroup taskGroupNone = TaskGroup(
      id: -1,
      name: "None",
      description: "",
      priority: Priority.high,
      deadline: DateTime.now());

  List<Note> notes = [];
  List<Note> toRemoveNotes = [];

  List<Widget> getNotes() {
    List<Widget> notesList = [];

    if (notes == []) {
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
        ));
      }
    }
    return notesList;
  }

  Future<int> initData() async {
    if (init) {
      return 0;
    }
    id = widget.id;
    if (id != null) {
      Task task =
          await serviceLocator<TaskDao>().findTaskById(id!).first as Task;
      titleController.text = task.name;
      date = task.deadline;
      dueDate = formatter.format(date!);
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
        subject = null;
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
      titleController.text = 'Your new task';
      date = DateTime.now();
      date = DateTime(date!.year, date!.month, date!.day);
      dueDate = formatter.format(date!);
      institution = institutionNone;
      subject = null;
      priority = null;
      description = "Your new task description";
      notes = [];
      taskGroup = taskGroupNone;
    }

    init = true;
    return 0;
  }

  @override
  initState() {
    super.initState();
  }

  List<Widget> getSubject() {
    // if (institution.id == -1) {
    //   return [];
    // }
    return [
      InkWell(
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                  FutureBuilder(
                      future: serviceLocator<SubjectDao>()
                          .findSubjectByInstitutionId(institution.id!),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Subject>> snapshot) {
                        if (snapshot.hasData) {
                          if (subject != null) {
                            for (final s in snapshot.data!) {
                              if (s.id == subject!.id) {
                                subject = s;
                                break;
                              }
                            }
                          }

                          return DropdownButton<Subject>(
                            value: subject,
                            items: snapshot.data!.map((s) {
                              return DropdownMenuItem<Subject>(
                                  value: s,
                                  child: Text(s.acronym,
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
                      }),
                ],
              )
            ]))
      ])),
      const SizedBox(height: 30)
    ];
  }

  Map<String, String> validate() {
    Map<String, String> errors = {};
    if (titleController.text == "") {
      errors['title'] = 'Please enter a title';
    }

    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    if (date!.isBefore(now)) {
      errors['date'] = 'Please select a date in the future';
    }
    if (priority == null) {
      errors['priority'] = 'Please select a priority';
    }
    if (institution.id != -1 && subject!.id == -1) {
      // Must either not have an institution and no subject
      // Or have both an institution and a subject
      errors['subject'] = 'Please select a subject';
    }

    return errors;
  }

  void save() async {
    Map<String, String> errors = validate();
    if (errors.isNotEmpty) {
      return;
    }
    Task task;
    int? subjectId, taskGroupId;
    if (subject != null) {
      subjectId = subject!.id;
    }
    if (taskGroup!.id != -1) {
      taskGroupId = taskGroup!.id;
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
          xp: 0);
      newId = await serviceLocator<TaskDao>().insertTask(task);
    } else {
      task = Task(
          id: id,
          name: titleController.text,
          deadline: date!,
          priority: priority!,
          subjectId: subjectId,
          description: description!,
          taskGroupId: taskGroupId,
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

    // My idea
    // Create here the new notes
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initData(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 7.5),
                          Flexible(
                              flex: 1,
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Transform.rotate(
                                      angle: -Math.pi / 4,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            alignment: const Alignment(0, 0),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    studentColor)),
                                        onPressed: () {
                                          //TODO: Change the associated module (?)
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                      )))),
                          const SizedBox(width: 15),
                          Flexible(
                              flex: 10,
                              child: TextField(
                                  controller: titleController,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF414554))),
                                    hintText:
                                        AppLocalizations.of(context).title,
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
                        ]),
                    const SizedBox(height: 30),
                    // priority
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                          AppLocalizations.of(context).priority,
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFF71788D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center),
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          highlightColor: lightGray,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    color: (priority ==
                                                            Priority.low
                                                        ? primaryColor
                                                        : lightGray),
                                                  ),
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .low,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal)))
                                            ],
                                          ),
                                          onTap: () {
                                            priority = Priority.low;
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          highlightColor: lightGray,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  color: (priority ==
                                                          Priority.medium
                                                      ? primaryColor
                                                      : lightGray),
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .medium,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal)))
                                            ],
                                          ),
                                          onTap: () {
                                            priority = Priority.medium;
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          highlightColor: lightGray,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    color: (priority ==
                                                            Priority.high
                                                        ? primaryColor
                                                        : lightGray),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .high,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal)))
                                            ],
                                          ),
                                          onTap: () {
                                            priority = Priority.high;
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    )
                                  ]))
                        ]),
                    const SizedBox(height: 30),
                    InkWell(
                        //TODO: Maybe customize the splash?
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));

                          setState(() {
                            this.date = date;
                            dueDate = formatter.format(this.date!);
                          });
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text(
                                              AppLocalizations.of(context)
                                                  .due_date,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xFF71788D),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.center),
                                        ]),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              highlightColor: lightGray,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      (dueDate == null
                                                          ? DateTime.now()
                                                              .toString()
                                                          : dueDate!),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .normal))
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ]))
                            ])),
                    const SizedBox(height: 30),
                    // Project
                    InkWell(
                        //TODO: Maybe customize the splash?
                        onTap: () {
                          //TODO: Institution selection - need to have it here to work with it.
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text(
                                              AppLocalizations.of(context)
                                                  .project,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xFF71788D),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.center),
                                        ]),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FutureBuilder(
                                                    future: serviceLocator<
                                                            TaskGroupDao>()
                                                        .findAllTaskGroups(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                List<TaskGroup>>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        bool taskGroupFound =
                                                            false;
                                                        bool
                                                            taskGroupNoneFound =
                                                            false;
                                                        for (final i
                                                            in snapshot.data!) {
                                                          if (i.id ==
                                                              taskGroup!.id) {
                                                            taskGroup = i;
                                                            taskGroupFound =
                                                                true;
                                                          }
                                                          if (i.id ==
                                                              taskGroupNone
                                                                  .id) {
                                                            taskGroupNoneFound =
                                                                true;
                                                          }
                                                        }
                                                        if (!taskGroupFound) {
                                                          taskGroup =
                                                              taskGroupNone;
                                                        }
                                                        if (!taskGroupNoneFound) {
                                                          snapshot.data!.insert(
                                                              0, taskGroupNone);
                                                        }

                                                        return DropdownButton<
                                                            TaskGroup>(
                                                          value: taskGroup,
                                                          items: snapshot.data!
                                                              .map((t) {
                                                            return DropdownMenuItem<
                                                                    TaskGroup>(
                                                                value: t,
                                                                child: Text(
                                                                    t.name,
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: Color(
                                                                            0xFF71788D),
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center));
                                                          }).toList(),
                                                          onChanged: (TaskGroup?
                                                              newTaskGroup) async {
                                                            if (taskGroup!.id !=
                                                                newTaskGroup!
                                                                    .id) {
                                                              //We might have changes to institution/subject
                                                              if (newTaskGroup
                                                                      .subjectId ==
                                                                  null) {
                                                                institution =
                                                                    institutionNone;
                                                                subject = null;
                                                              } else {
                                                                if (subject !=
                                                                        null &&
                                                                    subject!.id ==
                                                                        newTaskGroup
                                                                            .subjectId) {
                                                                  //do nothing
                                                                } else {
                                                                  subject = await serviceLocator<SubjectDao>()
                                                                      .findSubjectById(
                                                                          newTaskGroup
                                                                              .subjectId!)
                                                                      .first as Subject;
                                                                  if (subject!
                                                                          .institutionId ==
                                                                      null) {
                                                                    institution =
                                                                        institutionNone;
                                                                  } else {
                                                                    institution = await serviceLocator<InstitutionDao>()
                                                                        .findInstitutionById(
                                                                            subject!.institutionId!)
                                                                        .first as Institution;
                                                                  }
                                                                }
                                                              }
                                                              taskGroup =
                                                                  newTaskGroup;
                                                            }

                                                            setState(() {
                                                              institution =
                                                                  institution;
                                                              subject = subject;
                                                              taskGroup =
                                                                  taskGroup;
                                                            });
                                                          },
                                                        );
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    }),
                                              ],
                                            )
                                          ],
                                        )
                                      ]))
                            ])),
                    const SizedBox(height: 30),
                    // Insitution
                    InkWell(
                        //TODO: Maybe customize the splash?
                        onTap: () {
                          //TODO: Project selection - need to have it here to work with it.
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text(
                                              AppLocalizations.of(context)
                                                  .institution,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xFF71788D),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.center),
                                        ]),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            FutureBuilder(
                                                future: serviceLocator<
                                                        InstitutionDao>()
                                                    .findAllInstitutions(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            List<Institution>>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    bool institutionFound =
                                                        false;
                                                    bool institutionNoneFound =
                                                        false;
                                                    for (final i
                                                        in snapshot.data!) {
                                                      if (i.id ==
                                                          institution.id) {
                                                        institution = i;
                                                        institutionFound = true;
                                                      }
                                                      if (i.id ==
                                                          institutionNone.id) {
                                                        institutionNoneFound =
                                                            true;
                                                      }
                                                    }
                                                    if (!institutionFound) {
                                                      institution =
                                                          institutionNone;
                                                    }
                                                    if (!institutionNoneFound) {
                                                      snapshot.data!.insert(
                                                          0, institutionNone);
                                                    }

                                                    return DropdownButton<
                                                        Institution>(
                                                      value: institution,
                                                      items: snapshot.data!
                                                          .map((i) {
                                                        return DropdownMenuItem<
                                                                Institution>(
                                                            value: i,
                                                            child: Text(i.name,
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0xFF71788D),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center));
                                                      }).toList(),
                                                      onChanged: (Institution?
                                                          newInstitution) {
                                                        setState(() {
                                                          if (institution.id !=
                                                              newInstitution!
                                                                  .id) {
                                                            taskGroup =
                                                                taskGroupNone;
                                                            subject = null;
                                                          }
                                                          institution =
                                                              newInstitution;
                                                        });
                                                      },
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                }),
                                          ],
                                        )
                                      ]))
                            ])),
                    const SizedBox(height: 30),
                    // Subject
                    ...getSubject(),

                    Row(children: [
                      Text(AppLocalizations.of(context).description,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF71788D),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ]),
                    const SizedBox(height: 7.5),
                    Row(children: [
                      Flexible(
                          flex: 1,
                          child: TextField(
                            controller:
                                TextEditingController(text: description),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF17181C),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            maxLines: 5,
                            onChanged: (input) {
                              description = input;
                            },
                          ))
                    ]),
                    const SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context).notes,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF71788D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.add),
                            color: const Color(0xFF71788D),
                            iconSize: 20,
                            splashRadius: 0.1,
                            constraints: const BoxConstraints(
                                maxWidth: 20, maxHeight: 20),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: const Color(0xFF22252D),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30.0)),
                                  ),
                                  builder: (builder) => SingleChildScrollView(
                                      child: AddTaskNoteForm(
                                          taskId: id, callback: addNote)));
                            },
                          ),
                        ]),
                    const SizedBox(height: 7.5),
                    ...getNotes(),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () {
                          save();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.95, 55),
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context).save,
                            style: Theme.of(context).textTheme.headlineSmall))
                  ]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  addNote(Note note) {
    setState(() {
      notes.insert(0, note);
    });
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
      }else{
        throw Exception("Task id is null for edit note callback");
      }
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
    };
  }
}
