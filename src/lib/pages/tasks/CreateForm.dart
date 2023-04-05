// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'dart:math' as Math;
import 'package:src/utils/enums.dart';

class CreateForm extends StatefulWidget {
  final String title, dueDate, projectTitle, institution, subject, description;
  final Priority priority;
  final List<String> notes;

  const CreateForm(
      {Key? key,
      required this.title,
      required this.dueDate,
      required this.projectTitle,
      required this.institution,
      required this.subject,
      required this.priority,
      required this.description,
      required this.notes})
      : super(key: key);

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  TextEditingController controller = TextEditingController();

  late String title, dueDate, projectTitle, institution, subject, description;
  late Priority priority;
  late List<String> notes;

  @override
  initState() {
    title = widget.title;
    dueDate = widget.dueDate;
    projectTitle = widget.projectTitle;
    institution = widget.institution;
    subject = widget.subject;
    description = widget.description;
    priority = widget.priority;
    notes = widget.notes;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
            ElevatedButton(
                style: ButtonStyle(
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF17181C)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  //TODO: Change the form.
                },
                child: Wrap(children: [
                  Row(children: [
                    const Icon(Icons.task),
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
                child: TextField(
                    controller: controller,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: lightGray)),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(dueDate,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal))
                              ],
                            ),
                            onTap: () async {
                              var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100));

                              String? day = date?.day.toString().padLeft(2, '0'),
                                      month = date?.month.toString().padLeft(2, '0'),
                                      year = date?.year.toString();

                              dueDate = (date == null ? DateTime.now().toString() : "$day/$month/$year");

                              setState(() {});
                            },
                          )
                        ],
                      )
                    ]))
          ]),
          const SizedBox(width: 15),
          const SizedBox(height: 100)
        ]));
  }
}
