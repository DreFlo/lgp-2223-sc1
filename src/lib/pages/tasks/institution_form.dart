// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/tasks/subject_bar.dart';

class InstitutionForm extends StatefulWidget {
  final String? name;
  final InstitutionType? type;
  final Map<String, String>? subjects;
  final ScrollController scrollController;

  const InstitutionForm(
      {Key? key,
      required this.scrollController,
      this.name,
      this.type,
      this.subjects})
      : super(key: key);

  @override
  State<InstitutionForm> createState() => _InstitutionFormState();
}

class _InstitutionFormState extends State<InstitutionForm> {
  TextEditingController controller = TextEditingController();

  late String? name;
  late InstitutionType? type;
  late Map<String, String>? subjects;

  @override
  initState() {
    name = widget.name;
    type = widget.type;
    subjects = widget.subjects;

    controller.text = widget.name!;

    super.initState();
  }

  List<Widget> getSubjects() {
    List<Widget> subjectsList = [];

    if (subjects == null) {
      subjectsList.add(Text(AppLocalizations.of(context).no_tasks,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal)));
    } else {
      for (var key in subjects!.keys) {
        //subjectsList.add(SubjectBar(acronym: key, name: subjects![key]!));
      }
    }

    return subjectsList;
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
                      const Icon(Icons.account_balance_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context).institution,
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
              Flexible(
                  flex: 10,
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
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
            Row(children: [
              Text(
                AppLocalizations.of(context).type,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF71788D),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ]),
            const SizedBox(height: 7.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    flex: 1,
                    child: InkWell(
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
                                color: (type == InstitutionType.education
                                    ? primaryColor
                                    : lightGray),
                              ),
                              alignment: const Alignment(0, 0),
                              child: Text(
                                  AppLocalizations.of(context).education,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)))
                        ],
                      ),
                      onTap: () {
                        type = InstitutionType.education;
                        setState(() {});
                      },
                    )),
                const SizedBox(width: 5),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      highlightColor: lightGray,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              color: (type == InstitutionType.work
                                  ? primaryColor
                                  : lightGray),
                              alignment: const Alignment(0, 0),
                              child: Text(AppLocalizations.of(context).work,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)))
                        ],
                      ),
                      onTap: () {
                        type = InstitutionType.work;
                        setState(() {});
                      },
                    )),
                const SizedBox(width: 5),
                Flexible(
                  flex: 1,
                  child: InkWell(
                    highlightColor: lightGray,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: (type == InstitutionType.other
                                  ? primaryColor
                                  : lightGray),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            alignment: const Alignment(0, 0),
                            child: Text(AppLocalizations.of(context).other,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)))
                      ],
                    ),
                    onTap: () {
                      type = InstitutionType.other;
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                AppLocalizations.of(context).subjects,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF71788D),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
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
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.60,
                            minChildSize: 0.60,
                            maxChildSize: 0.60,
                            builder: (context, scrollController) => SubjectForm(
                              scrollController: scrollController,
                            ),
                          )));
                },
              ),
            ]),
            const SizedBox(height: 7.5),
            ...getSubjects(),
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
