// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/pages/tasks/task_form.dart';
import 'package:src/themes/colors.dart';
import 'dart:math' as Math;
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';

final DateFormat formatter = DateFormat('dd/MM/yyyy');

class ProjectForm extends StatefulWidget {
  final int? id;
  final ScrollController scrollController;

  const ProjectForm({Key? key, required this.scrollController, this.id})
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
  late TaskGroup? taskGroup;
  late bool init = false;

  Institution institutionNone =
      Institution(id: -1, name: 'None', type: InstitutionType.other, userId: 1);

  Future<int> initData() async {
    if (init) {
      return 0;
    }
    id = widget.id;
    if (id != null) {
      taskGroup = await serviceLocator<TaskGroupDao>()
          .findTaskGroupById(id!)
          .first as TaskGroup;
      titleController.text = taskGroup!.name;
      date = taskGroup!.deadline;
      dueDate = formatter.format(date!);
      priority = taskGroup!.priority;
      description = taskGroup!.description;
      if (taskGroup!.subjectId != null) {
        subject = await serviceLocator<SubjectDao>()
            .findSubjectById(taskGroup!.subjectId!)
            .first as Subject;
        if (subject!.institutionId != null) {
          institution = await serviceLocator<InstitutionDao>()
              .findInstitutionById(subject!.institutionId!)
              .first as Institution;
        } else {
          subject = null;
          institution = institutionNone;
        }
      } else {
        subject = null;
        institution = institutionNone;
      }
    } else {
      titleController.text = 'Your new Project';
      date = DateTime.now();
      date = DateTime(date!.year, date!.month, date!.day);
      dueDate = formatter.format(date!);
      priority = null;
      description = 'A description';
      subject = null;
      institution = institutionNone;
    }
    init = true;

    return 0;
  }

  @override
  initState() {
    super.initState();
  }

  List<Widget> getSubject() {
    if (institution.id == -1) {
      return [];
    }
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
    List<Widget> getTasks() {
    List<Widget> tasksList = [];

    // //TODO: Task bar + add it to the list.
    // for (int i = 0; i < tasks!.length; i++) {
    //   tasksList.add(
    //       const TaskBar(title: "Title", dueDate: 'Due Date', taskStatus: true));
    //   if (i != tasks!.length - 1) {
    //     tasksList.add(const SizedBox(height: 15));
    //   }
    // }

    // if (tasks == null) {
    //   tasksList.add(Text(AppLocalizations.of(context).no_tasks,
    //       style: const TextStyle(
    //           color: Colors.white,
    //           fontSize: 16,
    //           fontWeight: FontWeight.normal)));
    // }

    return tasksList;
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
    TaskGroup taskGroup;
    if (subject != null) {
      taskGroup = TaskGroup(
        id: id,
        name: titleController.text,
        deadline: date!,
        priority: priority!,
        subjectId: subject!.id,
        description: description!,
      );
    } else {
      taskGroup = TaskGroup(
        id: id,
        name: titleController.text,
        deadline: date!,
        priority: priority!,
        subjectId: null,
        description: description!,
      );
    }
    if (id != null) {
      if (subject != null) {
        taskGroup = TaskGroup(
          id: id,
          name: titleController.text,
          deadline: date!,
          priority: priority!,
          subjectId: subject!.id,
          description: description!,
        );
      } else {
        taskGroup = TaskGroup(
          id: id,
          name: titleController.text,
          deadline: date!,
          priority: priority!,
          subjectId: null,
          description: description!,
        );
      }
      //Update
      await serviceLocator<TaskGroupDao>().updateTaskGroup(taskGroup);
    } else {
      if (subject != null) {
        taskGroup = TaskGroup(
          name: titleController.text,
          deadline: date!,
          priority: priority!,
          subjectId: subject!.id,
          description: description!,
        );
      } else {
        taskGroup = TaskGroup(
          name: titleController.text,
          deadline: date!,
          priority: priority!,
          subjectId: null,
          description: description!,
        );
      }
      //Create
      id = await serviceLocator<TaskGroupDao>().insertTaskGroup(taskGroup);
    }
    Navigator.pop(context);
  }

  // else {
  //   serviceLocator<TaskGroupDao>().updateTaskGroup(TaskGroup(
  //     id: id,
  //     name: title,
  //     deadline: dueDate,
  //     priority: priority,
  //     subjectId: subject.id,
  //     description: description,
  //   ));
  // }

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
                                                  Text(dueDate!,
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
                    // Priority
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
                    // Institution
                    InkWell(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                            future:
                                                serviceLocator<InstitutionDao>()
                                                    .findAllInstitutions(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<Institution>>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                bool institutionFound = false;
                                                bool institutionNoneFound =
                                                    false;
                                                for (final i
                                                    in snapshot.data!) {
                                                  if (i.id == institution.id) {
                                                    institution = i;
                                                    institutionFound = true;
                                                  }
                                                  if (i.id ==
                                                      institutionNone.id) {
                                                    institutionNoneFound = true;
                                                  }
                                                }
                                                if (!institutionFound) {
                                                  institution = institutionNone;
                                                }
                                                if (!institutionNoneFound) {
                                                  snapshot.data!.insert(
                                                      0, institutionNone);
                                                }

                                                return DropdownButton<
                                                    Institution>(
                                                  value: institution,
                                                  items:
                                                      snapshot.data!.map((i) {
                                                    return DropdownMenuItem<Institution>(
                                                        value: i,
                                                        child: Text(i.name,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xFF71788D),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            textAlign: TextAlign
                                                                .center));
                                                  }).toList(),
                                                  onChanged: (Institution?
                                                      newInstitution) {
                                                    setState(() {
                                                      if (institution.id !=
                                                          newInstitution!.id) {
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
                    //Subject
                    ...getSubject(),

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
                          Text(AppLocalizations.of(context).tasks,
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
                                  builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              50),
                                      child: DraggableScrollableSheet(
                                        expand: false,
                                        initialChildSize: 0.60,
                                        minChildSize: 0.60,
                                        maxChildSize: 0.60,
                                        builder: (context, scrollController) =>
                                            TaskForm(
                                          scrollController: scrollController,
                                        ),
                                      )));
                            },
                          ),
                        ]),
                    const SizedBox(height: 7.5),
            ...getTasks(),
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
}
