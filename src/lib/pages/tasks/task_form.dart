// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/notes/add_task_note_form.dart';
import 'package:src/themes/colors.dart';
import 'dart:math' as Math;
import 'package:src/utils/enums.dart';
import 'package:src/widgets/note_bar.dart';

class TaskForm extends StatefulWidget {
  final String? title, dueDate, project, institution, subject, description;
  final Priority? priority;
  final List<String>? notes;
  final ScrollController scrollController;

  const TaskForm(
      {Key? key,
      required this.scrollController,
      this.title,
      this.dueDate,
      this.project,
      this.institution,
      this.subject,
      this.priority,
      this.description,
      this.notes})
      : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  TextEditingController controller = TextEditingController();

  late String? title, dueDate, projectTitle, institution, subject, description;
  late Priority? priority;
  late List<String>? notes;

  List<Widget> getNotes() {
    List<Widget> notesList = [];

    if (notes == null) {
      notesList.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppLocalizations.of(context).no_notes,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal))
      ]));
    } else {
      for (int i = 0; i < notes!.length; i++) {
        notesList.add(NoteBar(text: notes![i]));
      }
    }

    return notesList;
  }

  @override
  initState() {
    title = widget.title;
    dueDate = widget.dueDate;
    projectTitle = widget.project;
    institution = widget.institution;
    subject = widget.subject;
    description = widget.description;
    priority = widget.priority;
    notes = widget.notes;

    if (title != null) {
      controller.text = title!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF17181C),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  child: Wrap(children: [
                    Row(children: [
                      const Icon(Icons.task, color: Colors.white, size: 20),
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
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(width: 7.5),
              Flexible(
                  flex: 1,
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Transform.rotate(
                          angle: -Math.pi / 4,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
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
                  child: TextField(
                      controller: controller,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
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
                        controller.clear();
                      }))
            ]),
            const SizedBox(height: 30),
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              highlightColor: lightGray,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
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
                                      child: Text(
                                          AppLocalizations.of(context).low,
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
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              highlightColor: lightGray,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      color: (priority == Priority.medium
                                          ? primaryColor
                                          : lightGray),
                                      alignment: const Alignment(0, 0),
                                      child: Text(
                                          AppLocalizations.of(context).medium,
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
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              highlightColor: lightGray,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
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
                                      child: Text(
                                          AppLocalizations.of(context).high,
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

                  String? day = date?.day.toString().padLeft(2, '0'),
                      month = date?.month.toString().padLeft(2, '0'),
                      year = date?.year.toString();

                  dueDate = (date == null
                      ? DateTime.now().toString()
                      : "$day/$month/$year");

                  setState(() {});
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              (dueDate == null
                                                  ? DateTime.now().toString()
                                                  : dueDate!),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ]))
                    ])),
            const SizedBox(height: 30),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            (projectTitle == null
                                                ? AppLocalizations.of(context)
                                                    .input
                                                : projectTitle!),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    )
                                  ],
                                )
                              ]))
                    ])),
            const SizedBox(height: 30),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                    Text(
                                        (institution == null
                                            ? AppLocalizations.of(context).input
                                            : institution!),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal))
                                  ],
                                )
                              ]))
                    ])),
            const SizedBox(height: 30),
            InkWell(
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
                                  Icons.subject_rounded,
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
                                  Text(
                                      (subject == null
                                          ? AppLocalizations.of(context).input
                                          : subject!),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal))
                                ],
                              ),
                            ],
                          ))
                    ])),
            const SizedBox(height: 30),
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
            ]),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                constraints: const BoxConstraints(maxWidth: 20, maxHeight: 20),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFF22252D),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (builder) => const SingleChildScrollView(
                          //TODO: change to real taskId
                          child: AddTaskNoteForm(taskId: 1)));
                },
              ),
            ]),
            const SizedBox(height: 7.5),
            ...getNotes(),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  //TODO: Save stuff + send to database.
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.95, 55),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).save,
                    style: Theme.of(context).textTheme.headlineSmall))
          ]),
        ));
  }
}
