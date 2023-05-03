import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/project_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/date_formatter.dart';
import 'dart:math' as math;
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/highlight_text.dart';
import 'package:src/widgets/tasks/task_show_bar.dart';

class ProjectShow extends StatefulWidget {
  final TaskGroup taskGroup;
  final ScrollController scrollController;
  final Function(TaskGroup tg)? callback;
  final Function()? deleteCallback;

  const ProjectShow(
      {Key? key,
      required this.scrollController,
      required this.taskGroup,
      this.callback,
      this.deleteCallback})
      : super(key: key);

  @override
  State<ProjectShow> createState() => _ProjectShowState();
}

class _ProjectShowState extends State<ProjectShow> {
  late TaskGroup taskGroup;
  late String priorityText;
  late Institution institution;
  late Subject subject;
  late bool init = false;

  Institution institutionNone =
      Institution(id: -1, name: 'None', type: InstitutionType.other, userId: 1);
  Subject subjectNone = Subject(
    id: -1,
    name: 'None',
    acronym: 'None',
  );

  List<Task> tasks = [];

  initTasks() async {
    tasks =
        await serviceLocator<TaskDao>().findTasksByTaskGroupId(taskGroup.id!);
    tasks.sort((a, b) => a.deadline.isBefore(b.deadline) ? 1 : -1);
  }

  Future<int> initData() async {
    if (init) {
      return 0;
    }

    taskGroup = widget.taskGroup;
    await initSubjectInstitution();

    //Tasks
    await initTasks();

    init = true;

    return 0;
  }

  Future<void> initSubjectInstitution() async {
    if (taskGroup.subjectId != null) {
      subject = await serviceLocator<SubjectDao>()
          .findSubjectById(taskGroup.subjectId!)
          .first as Subject;
      if (subject.institutionId != null) {
        institution = await serviceLocator<InstitutionDao>()
            .findInstitutionById(subject.institutionId!)
            .first as Institution;
      } else {
        institution = institutionNone;
      }
    } else {
      subject = subjectNone;
      institution = institutionNone;
    }
  }

  @override
  initState() {
    taskGroup = widget.taskGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initData(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            if (taskGroup.priority == Priority.low) {
              priorityText = AppLocalizations.of(context).low;
            } else if (taskGroup.priority == Priority.medium) {
              priorityText = AppLocalizations.of(context).medium;
            } else {
              priorityText = AppLocalizations.of(context).high;
            }
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
                                  const Icon(Icons.list_rounded,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 10),
                                  Text(AppLocalizations.of(context).project,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center),
                                ]),
                              ]))
                        ]),
                    const SizedBox(height: 15),
                    getTitle(context),
                    const SizedBox(height: 30),
                    getDate(context),
                    const SizedBox(height: 30),
                    // Priority
                    getPriority(context),
                    const SizedBox(height: 30),
                    // Institution
                    getInstitution(context),
                    const SizedBox(height: 30),
                    //Subject
                    getSubject(),
                    const SizedBox(height: 30),

                    // Description
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
                    getDescription(),
                    const SizedBox(height: 7.5),
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
            taskGroup.name,
            key: const Key('projectTitle'),
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
            maxLines: 1,
          )),
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
                      HighlightText(DateFormatter.format(taskGroup.deadline),
                          key: const Key('projectDeadline')),
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
                    key: const Key("projectInstitution")),
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
                HighlightText(subject.acronym,
                    key: const Key("projectSubject")),
              ],
            )
          ]))
    ]));
  }

  Widget getDescription() {
    return Row(children: [
      Flexible(
          flex: 1,
          child: HighlightText(taskGroup.description,
              key: const Key("projectDescription")))
    ]);
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
        taskList.add(TaskShowBar(
          key: ValueKey(tasks[i]),
          taskGroup: taskGroup,
          task: tasks[i],
          editTask: editTask,
          deleteTask: deleteTask(tasks[i]),
        ));

        taskList.add(const SizedBox(height: 15));
      }
    }

    return taskList;
  }

  Widget getEndButtons(BuildContext context) {
    return ElevatedButton(
        key: const Key('projectEditButton'),
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
                builder: (context, scrollController) => ProjectForm(
                      id: taskGroup.id,
                      callback: editTaskGroup,
                      deleteCallback: deleteTaskGroup,
                      editTasksCallback: editTaskGroupTasks,
                      scrollController: scrollController,
                    ))));
  }

  editTaskGroup(TaskGroup taskGroup) async {
    setState(() {
      this.taskGroup = taskGroup;
    });
    await initTasks();
    await initSubjectInstitution();
    callCallback();
  }

  deleteTaskGroup() {
    Navigator.pop(context);

    if (widget.deleteCallback != null) {
      widget.deleteCallback!();
    }
  }

  editTaskGroupTasks(List<Task> tasks) {
    setState(() {
      this.tasks = tasks;
    });
    callCallback();
  }

  editTask(Task task) {
    setState(() {
      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].id == task.id) {
          tasks[i] = task;
          return;
        }
      }
    });
  }

  deleteTask(Task oldTask) {
    return () {
      setState(() {
        tasks.remove(oldTask);
      });
    };
  }

  callCallback() {
    if (widget.callback != null) {
      widget.callback!(taskGroup);
    }
  }
}
