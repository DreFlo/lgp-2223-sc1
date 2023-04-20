// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/daos/student/task_group_dao.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/tasks/subject_bar.dart';

import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';

class InstitutionForm extends StatefulWidget {
  final int? id;
  final ScrollController scrollController;

  const InstitutionForm({Key? key, required this.scrollController, this.id})
      : super(key: key);

  @override
  State<InstitutionForm> createState() => _InstitutionFormState();
}

class _InstitutionFormState extends State<InstitutionForm> {
  TextEditingController controller = TextEditingController();

  late InstitutionType type;
  List<Subject> noDbSubjects = [];
  bool init = false;
  Map<String, String> errors = {};

  @override
  initState() {
    super.initState();
  }

  Future<int> fillInstitutionFields() async {
    if (init) {
      return 0;
    }

    if (widget.id != null) {
      Institution? institution = await serviceLocator<InstitutionDao>()
          .findInstitutionById(widget.id!)
          .first;

      controller.text = institution!.name;
      type = institution.type;
    } else {
      type = InstitutionType.other;
      controller.clear();
    }

    init = true;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fillInstitutionFields(),
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
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              flex: 10,
                              child: TextField(
                                  key: const Key('institutionNameField'),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF414554))),
                                    hintText: AppLocalizations.of(context).name,
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
                    errors.containsKey('name')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(errors['name']!,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)))
                        : const SizedBox(height: 0),
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
                                        color:
                                            (type == InstitutionType.education
                                                ? primaryColor
                                                : lightGray),
                                      ),
                                      alignment: const Alignment(0, 0),
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .education,
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
                                      child: Text(
                                          AppLocalizations.of(context).work,
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
                                    child: Text(
                                        AppLocalizations.of(context).other,
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                            SubjectForm(
                                          scrollController: scrollController,
                                          callback: addNoDbSubject,
                                          selectInstitution: false,
                                        ),
                                      )));
                            },
                          ),
                        ]),
                    const SizedBox(height: 7.5),
                    displaySubjects(),
                    const SizedBox(height: 30),
                    displayEndButtons(),
                  ]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget displaySubjects() {
    if (widget.id == null) {
      if (noDbSubjects.isEmpty) {
        return Text(AppLocalizations.of(context).no_tasks,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal));
      } else {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: noDbSubjects
                .map((e) => SubjectBar(
                      subject: e,
                      callback: editNoDbSubject,
                      selectInstitution: false,
                      removeCallback: removeNoDbSubject,
                    ))
                .toList());
      }
    } else {
      return FutureBuilder(
          future: serviceLocator<SubjectDao>()
              .findSubjectByInstitutionId(widget.id!),
          builder:
              (BuildContext constex, AsyncSnapshot<List<Subject?>> snapshot) {
            if (snapshot.hasData) {
              List<Widget> subjects = [];

              if (snapshot.data!.isEmpty && noDbSubjects.isEmpty) {
                subjects.add(Text(AppLocalizations.of(context).no_tasks,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)));
              } else {
                subjects = snapshot.data!
                    .map((e) => SubjectBar(
                        subject: e!,
                        id: e.id!,
                        callback: onSubjectSave,
                        removeCallback: removeSubject))
                    .toList();

                subjects.addAll(noDbSubjects
                    .map((e) => SubjectBar(
                          subject: e,
                          callback: editNoDbSubject,
                          selectInstitution: false,
                          removeCallback: removeNoDbSubject,
                        ))
                    .toList());
              }

              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: subjects);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    }
  }

  save() async {
    String name = controller.text;

    validate();

    if (errors.isEmpty) {
      //TODO: Change to real user id
      print('NEED TO CHANGE USER ID WHEN AUTH IS DONE');
      int id;
      if (widget.id == null) {
        id = await serviceLocator<InstitutionDao>()
            .insertInstitution(Institution(name: name, type: type, userId: 1));
      } else {
        serviceLocator<InstitutionDao>().updateInstitution(
            Institution(id: widget.id!, name: name, type: type, userId: 1));
        id = widget.id!;
      }

      for (Subject subject in noDbSubjects) {
        Subject newSubject = Subject(
          name: subject.name,
          acronym: subject.acronym,
          weightAverage: subject.weightAverage,
          institutionId: id,
        );
        await serviceLocator<SubjectDao>().insertSubject(newSubject);
      }

      Navigator.pop(context);
    }
  }

  Widget displayEndButtons() {
    if (widget.id == null) {
      return ElevatedButton(
          key: const Key('saveButton'),
          onPressed: () async {
            await save();
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
              key: const Key('saveButton'),
              onPressed: () async {
                await save();
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
              key: const Key('deleteButton'),
              onPressed: () async {
                showDeleteConfirmation(context);
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

  addNoDbSubject(Subject subject) {
    noDbSubjects.add(subject);
    setState(() {});
  }

  editNoDbSubject(Subject subject) {
    noDbSubjects.removeWhere((element) => element.id == subject.id);
    noDbSubjects.add(subject);
    setState(() {});
  }

  removeNoDbSubject(Subject subject) {
    noDbSubjects.removeWhere((element) => element.id == subject.id);
    setState(() {});
  }

  removeSubject(int id) async {
    Subject? subject =
        await serviceLocator<SubjectDao>().findSubjectById(id).first;

    Subject newSubject = Subject(
        id: subject!.id,
        name: subject.name,
        acronym: subject.acronym,
        weightAverage: subject.weightAverage,
        institutionId: null);

    await serviceLocator<SubjectDao>().updateSubject(newSubject);

    setState(() {});
  }

  onSubjectSave() {
    setState(() {});
  }

  validate() {
    errors = {};

    if (controller.text.isEmpty) {
      errors['name'] = AppLocalizations.of(context).name_error;
    }

    setState(() {});
  }

  showDeleteConfirmation(BuildContext context) {
    Widget cancelButton = TextButton(
      key: const Key('cancelConfirmationButton'),
      child: Text(AppLocalizations.of(context).cancel,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget deleteButton = TextButton(
      key: const Key('deleteConfirmationButton'),
      child: Text(AppLocalizations.of(context).delete,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      onPressed: () async {
        Institution? institution = await serviceLocator<InstitutionDao>()
            .findInstitutionById(widget.id!)
            .first;

        await serviceLocator<InstitutionDao>().deleteInstitution(institution!);

        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).delete_institution,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      content: Text(AppLocalizations.of(context).delete_institution_message,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      actions: [
        cancelButton,
        deleteButton,
      ],
      backgroundColor: primaryColor,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
