import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';

class EvaluationForm extends StatefulWidget {
  final int? subjectId;
  final void Function(StudentEvaluation evaluation)? callback,
      deleteEvaluationCallback;
  final StudentEvaluation? evaluation;

  const EvaluationForm(
      {Key? key,
      this.subjectId,
      this.callback,
      this.evaluation,
      this.deleteEvaluationCallback})
      : super(key: key);

  @override
  State<EvaluationForm> createState() => _EvaluationFormState();
}

class _EvaluationFormState extends State<EvaluationForm> {
  final nameController = TextEditingController();
  final gradeController = TextEditingController();

  Map<String, String> errors = {};
  bool init = false;

  Future<int> fillTaskFields() async {
    if (init) {
      return 0;
    }

    if (widget.evaluation != null) {
      nameController.text = widget.evaluation!.name;
      gradeController.text = widget.evaluation!.grade.toString();
    } else {
      nameController.clear();
      gradeController.clear();
    }

    init = true;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fillTaskFields(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Wrap(spacing: 10, children: [
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
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.only(left: 18),
                  child: Column(children: [
                    Text(
                        AppLocalizations.of(context)
                            .add_general_note_callout,
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left),
                    const SizedBox(height: 10),
                  ])),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          flex: 10,
                          child: TextField(
                              key: const Key('nameEvaluationField'),
                              controller: nameController,
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
                                    borderSide:
                                        BorderSide(color: Color(0xFF414554))),
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
                                nameController.clear();
                              }))
                    ]),
              ),
              errors.containsKey('name')
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18, top: 5),
                      child: Text(errors['name']!,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)))
                  : const SizedBox(height: 0),
              Row(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 18, top: 10),
                    child: Text(
                      AppLocalizations.of(context).add_evaluation,
                      style: Theme.of(context).textTheme.displayMedium,
                    ))
              ]),
              const SizedBox(height: 7.5),
              Row(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 200,
                        child: TextField(
                            key: const Key('gradeEvaluationField'),
                            controller: gradeController,
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
                              hintText: AppLocalizations.of(context).grade,
                              hintStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF71788D),
                                  fontWeight: FontWeight.w400),
                            ))))
              ]),
              errors.containsKey('grade')
                  ? Padding(
                      padding: const EdgeInsets.only(left: 18, top: 5.0),
                      child: Text(errors['grade']!,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)))
                  : const SizedBox(height: 0),
              displayEndButtons(),
              const SizedBox(height: 150)
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  validate() {
    errors = {};

    if (nameController.text.isEmpty) {
      errors['name'] = AppLocalizations.of(context).name_error;
    }

    if (gradeController.text.isEmpty) {
      errors['grade'] = AppLocalizations.of(context).grade_error;
    }

    setState(() {});
  }

  save(BuildContext context) async {
    validate();

    if (errors.isEmpty) {
      if (widget.subjectId != null) {
        // evaluation for an existing subject
        StudentEvaluation evaluation;
        StudentEvaluation simpleEvaluation;
        DateTime now = DateTime.now();
        if (widget.evaluation != null) {
          // Edit an already existing evaluation

          evaluation = StudentEvaluation(
              id: widget.evaluation!.id!,
              name: nameController.text,
              grade: double.parse(gradeController.text),
              subjectId: widget.subjectId!);
          await serviceLocator<StudentEvaluationDao>()
              .updateStudentEvaluation(evaluation);

          simpleEvaluation = evaluation;
        } else {
          // Add a new evaluation to an existing subject
          evaluation = StudentEvaluation(
              name: nameController.text,
              grade: double.parse(gradeController.text),
              subjectId: widget.subjectId!);

          int id = await serviceLocator<StudentEvaluationDao>()
              .insertStudentEvaluation(evaluation);
        }
        if (widget.callback != null) {
          widget.callback!(evaluation);
        } else {
          throw Exception(
              'Subject evaluation creator without evaluation should have a callback');
        }
      } else {
        StudentEvaluation evaluation = StudentEvaluation(
            name: nameController.text,
            grade: double.parse(gradeController.text),
            subjectId: widget.subjectId!);
        if (widget.callback != null) {
          widget.callback!(evaluation);
        } else {
          throw Exception(
              'Subject evaluation creator without subject should have a callback');
        }
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  delete(BuildContext context) async {
    StudentEvaluation evaluation = StudentEvaluation(
      id: widget.evaluation!.id,
      name: widget.evaluation!.name,
      grade: widget.evaluation!.grade,
      subjectId: widget.evaluation!.subjectId
    );

    await serviceLocator<StudentEvaluationDao>().deleteStudentEvaluation(evaluation);

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    if (widget.deleteEvaluationCallback != null) {
      widget.deleteEvaluationCallback!(widget.evaluation!);
    }
  }

  Widget displayEndButtons() {
    if (widget.evaluation == null || widget.subjectId == null) {
      return Padding(
          padding: const EdgeInsets.only(left: 40, top: 30),
          child: ElevatedButton(
              key: const Key('saveEvaluationButton'),
              onPressed: () async {
                await save(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.80, 55),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(AppLocalizations.of(context).save,
                  style: Theme.of(context).textTheme.headlineSmall)));
    } else {
      return Padding(
          padding: const EdgeInsets.only(left: 25, top: 30),
          child: Row(
            children: [
              ElevatedButton(
                  key: const Key('saveEvaluationButton'),
                  onPressed: () async {
                    await save(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 55),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).save,
                      style: Theme.of(context).textTheme.headlineSmall)),
              const SizedBox(width: 20),
              ElevatedButton(
                  key: const Key('deleteEvaluationButton'),
                  onPressed: () async {
                    await showDeleteConfirmation(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 55),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).delete,
                      style: Theme.of(context).textTheme.headlineSmall))
            ],
          ));
    }
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
        delete(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).delete_evaluation,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      content: Text(AppLocalizations.of(context).delete_evaluation_message,
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
