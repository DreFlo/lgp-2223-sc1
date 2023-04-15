// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:flutter/services.dart';

class SubjectForm extends StatefulWidget {
  final int? id;
  final ScrollController scrollController;

  const SubjectForm({Key? key, required this.scrollController, this.id})
      : super(key: key);

  @override
  State<SubjectForm> createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  late String name, acronym, weightAverage;
  late int institutionId;

  @override
  initState() {
    fillSubjectFields();

    super.initState();
  }

  fillSubjectFields() async {
    if (widget.id != null) {
      Subject? subject =
          await serviceLocator<SubjectDao>().findSubjectById(widget.id!).first;

      controller.text = subject!.name;
      controller2.text = subject.acronym;
      controller3.text = subject.weightAverage.toString();

      if (subject.institutionId != null) {
        Institution? institution = await serviceLocator<InstitutionDao>()
            .findInstitutionById(subject.institutionId!)
            .first;

        institutionId = institution!.id!;
        controller4.text = institution.name;
      }
    } else {
      controller.clear();
      controller2.clear();
      controller3.clear();
      controller4.clear();

      name = '';
      acronym = '';
      weightAverage = '';
      institutionId = -1;
    }
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
                      const Icon(Icons.subject_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context).subject,
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
                AppLocalizations.of(context).acronym,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF71788D),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ]),
            const SizedBox(height: 7.5),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Flexible(
                  flex: 10,
                  child: TextField(
                      controller: controller2,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        hintText: AppLocalizations.of(context).acronym,
                        hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF71788D),
                            fontWeight: FontWeight.w400),
                      )))
            ]),
            const SizedBox(height: 30),
            Row(children: [
              Text(
                AppLocalizations.of(context).weight_average,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF71788D),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ]),
            const SizedBox(height: 7.5),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Flexible(
                  flex: 10,
                  child: TextField(
                      controller: controller3,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+([.][0-9]*)?|[.][0-9]+'))
                      ],
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        hintText: AppLocalizations.of(context).weight_average,
                        hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF71788D),
                            fontWeight: FontWeight.w400),
                      )))
            ]),
            const SizedBox(height: 30),
            Row(children: [
              Text(
                AppLocalizations.of(context).institution,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF71788D),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ]),
            const SizedBox(height: 7.5),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Flexible(
                  flex: 10,
                  child: FutureBuilder(
                      future: serviceLocator<InstitutionDao>()
                          .findAllInstitutions(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Institution>> snapshot) {
                        if (snapshot.hasData) {
                          snapshot.data!.insert(
                              0,
                              Institution(
                                  id: -1,
                                  name: 'None',
                                  type: InstitutionType.other,
                                  userId: 1));
                          return DropdownMenu<Institution>(
                            controller: controller4,
                            dropdownMenuEntries: snapshot.data!.map((e) {
                              return DropdownMenuEntry<Institution>(
                                  value: e, label: e.name);
                            }).toList(),
                            onSelected: (Institution? institution) {
                              setState(() {
                                institutionId = institution!.id!;
                              });
                            },
                            initialSelection: snapshot.data![0],
                            textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                            width: MediaQuery.of(context).size.width * 0.85,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }))
            ]),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () async {
                  String name = controller.text;
                  String acronym = controller2.text;
                  String weightAverage = controller3.text;

                  //TODO: Save stuff + send to database.
                  bool valid = true;
                  if (name == null || name == '') {
                    print('Name is null or empty');
                    valid = false;
                  }
                  if (acronym == null || acronym == '') {
                    print('Acronym is null or empty');
                    valid = false;
                  }
                  if (weightAverage == null || weightAverage == '') {
                    print('Weight average is null or empty');
                    valid = false;
                  }
                  if (institutionId == null) {
                    print('Institution id is null');
                    valid = false;
                  }

                  if (valid) {
                    Subject subject;

                    if (widget.id != null) {
                      if (institutionId != -1) {
                        subject = Subject(
                            id: widget.id,
                            name: name,
                            acronym: acronym,
                            weightAverage: double.parse(weightAverage),
                            institutionId: institutionId);
                      } else {
                        subject = Subject(
                            id: widget.id,
                            name: name,
                            acronym: acronym,
                            weightAverage: double.parse(weightAverage));
                      }

                      await serviceLocator<SubjectDao>().updateSubject(subject);

                      Subject? found = await serviceLocator<SubjectDao>()
                          .findSubjectById(widget.id!)
                          .first;

                    } else {
                      if (institutionId != -1) {
                        subject = Subject(
                            name: name,
                            acronym: acronym,
                            weightAverage: double.parse(weightAverage),
                            institutionId: institutionId);
                      } else {
                        subject = Subject(
                            name: name,
                            acronym: acronym,
                            weightAverage: double.parse(weightAverage));
                      }

                      await serviceLocator<SubjectDao>().insertSubject(subject);
                    }

                    Navigator.pop(context);
                  }
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
