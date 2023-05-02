import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/task_note_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/task_note.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';
import 'dart:math' as math;
import 'package:src/utils/enums.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/highlight_text.dart';
import 'package:src/widgets/notes/note_show_bar.dart';

class TaskShow extends StatefulWidget {
  final Task task;
  final TaskGroup? taskGroup;
  final void Function(Task t)? callback;
  final void Function()? deleteCallback;
  final ScrollController scrollController;

  const TaskShow({
    Key? key,
    required this.task,
    this.taskGroup,
    this.callback,
    this.deleteCallback,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<TaskShow> createState() => _TaskShowState();
}

class _TaskShowState extends State<TaskShow> {
  late String priorityText;
  late Institution institution;
  late Subject subject;
  late TaskGroup? taskGroup;
  late Task task;
  late bool finished;
  bool init = false;

  TaskGroup taskGroupNone = TaskGroup(
      id: -1,
      name: "None",
      description: "",
      priority: Priority.high,
      deadline: DateFormatter.day(DateTime.now()));
  Institution institutionNone =
      Institution(id: -1, name: 'None', type: InstitutionType.other, userId: 1);
  Subject subjectNone = Subject(
    id: -1,
    name: 'None',
    acronym: 'None',
  );

  List<Note> notes = [];

  initNotes() async {
    List<TaskNote> taskNotes =
        await serviceLocator<TaskNoteDao>().findTaskNotesByTaskId(task.id!);
    notes = [];
    for (int i = 0; i < taskNotes.length; i++) {
      notes.add(await serviceLocator<NoteDao>()
          .findNoteById(taskNotes[i].id)
          .first as Note);
    }
    notes.sort((a, b) => a.date.isBefore(b.date) ? 1 : -1);
  }

  Future<int> initData() async {
    if (init) {
      return 0;
    }

    //Edit created task
    //Edit created task from created project
    // Task task = await serviceLocator<TaskDao>().findTaskById(id!).first as Task;
    task = widget.task;
    if (task.subjectId != null) {
      subject = await serviceLocator<SubjectDao>()
          .findSubjectById(task.subjectId!)
          .first as Subject;
      if (subject.institutionId != null) {
        institution = await serviceLocator<InstitutionDao>()
            .findInstitutionById(subject.institutionId!)
            .first as Institution;
      } else {
        institution = institutionNone;
      }
    } else {
      institution = institutionNone;
      subject = subjectNone;
    }

    if (widget.taskGroup != null) {
      taskGroup = widget.taskGroup;
    } else {
      if (task.taskGroupId != null) {
        taskGroup = await serviceLocator<TaskGroupDao>()
            .findTaskGroupById(task.taskGroupId!)
            .first as TaskGroup;
      } else {
        taskGroup = taskGroupNone;
      }
    }

    await initNotes();
    init = true;
    return 0;
  }

  @override
  initState() {
    super.initState();

    finished = widget.task.finished;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initData(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            if (task.priority == Priority.low) {
              priorityText = AppLocalizations.of(context).low;
            } else if (task.priority == Priority.medium) {
              priorityText = AppLocalizations.of(context).medium;
            } else {
              priorityText = AppLocalizations.of(context).high;
            }
            return ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30.0)),
                child: Scaffold(
                    primary: false,
                    backgroundColor: modalBackground,
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      controller: widget.scrollController,
                      child: Wrap(spacing: 10, children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                  ])),
                              InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () async {
                                    if (!finished) {
                                      checkNonEventNonTask(
                                          task, context, false);
                                    } else {
                                      //lose xp
                                      removePoints(getImmediatePoints(), task);
                                    }
                                    setState(() {
                                      finished = !finished;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (finished
                                            ? Colors.white
                                            : Colors.green)),
                                    child: Icon(Icons.check_rounded,
                                        color: (!finished
                                            ? Colors.white
                                            : Colors.green)),
                                  ))
                            ]),
                        const SizedBox(height: 15),
                        getTitle(context),
                        const SizedBox(height: 30),
                        // priority
                        getPriority(context),
                        const SizedBox(height: 30),
                        getDate(context),
                        const SizedBox(height: 30),
                        // Project
                        getProject(context),
                        const SizedBox(height: 30),
                        // Insitution
                        getInstitution(context),
                        const SizedBox(height: 30),
                        // Subject
                        getSubject(),
                        const SizedBox(height: 30),
                        getLabelDescription(context),
                        const SizedBox(height: 7.5),
                        getDescription(),
                        const SizedBox(height: 30),
                        getAddNoteButton(context),
                        const SizedBox(height: 7.5),
                        ...getNotes(),
                        const SizedBox(height: 30),
                        getEndButtons(context),
                      ]),
                    )));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Row getDescription() {
    return Row(children: [
      Flexible(
          flex: 1,
          child: Text(
            task.description,
            key: const Key("taskDescription"),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ))
    ]);
  }

  Widget getTitle(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(width: 7.5),
      Flexible(
          flex: 1,
          child: AspectRatio(
              aspectRatio: 1,
              child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0),
                        alignment: const Alignment(0, 0),
                        backgroundColor:
                            MaterialStateProperty.all(studentColor)),
                    onPressed: () {
                      //TODO: Change the associated module (?)
                    },
                    child: Container(
                        decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    )),
                  )))),
      const SizedBox(width: 15),
      Flexible(
          flex: 10,
          child: Text(
            task.name,
            key: const Key('taskTitle'),
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
            maxLines: 1,
          )),
    ]);
  }

  Widget getLabelDescription(BuildContext context) {
    return Row(children: [
      Text(AppLocalizations.of(context).description,
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF71788D),
              fontSize: 16,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
    ]);
  }

  Widget getDate(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                      HighlightText(DateFormatter.format(task.deadline),
                          key: const Key('projectDeadline'))
                    ],
                  ),
                )
              ],
            )
          ]))
    ]);
  }

  Widget getPriority(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                HighlightText(priorityText, key: const Key("projectPriority")),
              ],
            )
          ]))
    ]);
  }

  Widget getProject(BuildContext context) {
    // if (taskGroup!.id! == -1) {
    //   return const SizedBox();
    // }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HighlightText(taskGroup!.name,
                        key: const Key("taskProject")),
                  ],
                )
              ],
            )
          ]))
    ]));
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
                HighlightText(institution.name,
                    key: const Key("taskInstitution")),
              ],
            )
          ]))
    ]));
  }

  Widget getSubject() {
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
                HighlightText(subject.acronym, key: const Key("taskSubject")),
              ],
            )
          ]))
    ]));
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
    ]);
  }

  List<Widget> getNotes() {
    List<Widget> notesList = [];

    if (notes.isEmpty) {
      notesList.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppLocalizations.of(context).no_notes,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal))
      ]));
    } else {
      for (int i = 0; i < notes.length; i++) {
        notesList.add(NoteShowBar(
            key: ValueKey(notes[i]),
            task: task,
            note: notes[i],
            editNote: editNote,
            deleteNote: deleteNote(notes[i])));
      }
    }
    return notesList;
  }

  Widget getEndButtons(BuildContext context) {
    return ElevatedButton(
        key: const Key('taskEditButton'),
        onPressed: () async {
          edit(context);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(AppLocalizations.of(context).edit,
            style: Theme.of(context).textTheme.headlineSmall));
  }

  edit(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF22252D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        builder: (context) => Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 50),
            child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.75,
                minChildSize: 0.75,
                maxChildSize: 0.75,
                builder: (context, scrollController) => TaskForm(
                      id: task.id,
                      taskGroupId: task.taskGroupId ?? -1,
                      callback: editTask,
                      deleteCallback: deleteTask,
                      editNotesCallback: editTaskNotes,
                      scrollController: scrollController,
                    ))));
  }

  editTask(Task task) async {
    await initNotes();
    setState(() {
      this.task = task;
      notes = notes;
    });
    if (widget.callback != null) {
      widget.callback!(task);
    }
  }

  deleteTask() {
    Navigator.pop(context);
    if (widget.deleteCallback != null) {
      widget.deleteCallback!();
    }
  }

  editTaskNotes(List<Note> notes) async {
    setState(() {
      this.notes = notes;
    });
  }

  editNote(Note note) {
    setState(() {
      // Our notes have an id and were updated in the addTaskNoteForm
      for (int i = 0; i < notes.length; i++) {
        if (notes[i].id == note.id) {
          notes[i] = note;
          break;
        }
      }
    });
  }

  deleteNote(Note note) {
    return () {
      setState(() {
        notes.remove(note);
      });
    };
  }
}
