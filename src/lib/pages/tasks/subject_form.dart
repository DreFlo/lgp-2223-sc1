import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/tasks/evaluation_bar.dart';
import 'package:src/widgets/tasks/evaluation_form.dart';

class SubjectForm extends StatefulWidget {
  final ScrollController scrollController;
  final int? id;
  final Function()? callback;
  final Function(Subject)? callbackSubject;
  final bool selectInstitution;
  final Subject? subject;
  final bool create;

  const SubjectForm(
      {Key? key,
      required this.scrollController,
      this.id,
      this.callback,
      this.callbackSubject,
      this.selectInstitution = true,
      this.subject,
      this.create = false})
      : super(key: key);

  @override
  State<SubjectForm> createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController acronymController = TextEditingController();

  late int institutionId;
  Map<String, String> errors = {};
  bool init = false;

  List<StudentEvaluation> evaluations = [];
  List<StudentEvaluation> toRemoveEvaluations = [];

  @override
  initState() {
    super.initState();
  }

  Future<int> fillSubjectFields() async {
    if (init) {
      return 0;
    }

    if (widget.id != null) {
      Subject? subject =
          await serviceLocator<SubjectDao>().findSubjectById(widget.id!).first;

      nameController.text = subject!.name;
      acronymController.text = subject.acronym;

      if (subject.institutionId != null) {
        Institution? institution = await serviceLocator<InstitutionDao>()
            .findInstitutionById(subject.institutionId!)
            .first;

        institutionId = institution!.id!;
      } else {
        institutionId = -1;
      }

      evaluations = await serviceLocator<StudentEvaluationDao>()
          .findStudentEvaluationsBySubjectId(widget.id!);
    } else if (widget.subject != null) {
      nameController.text = widget.subject!.name;
      acronymController.text = widget.subject!.acronym;

      institutionId = -1;
    } else {
      nameController.clear();
      acronymController.clear();

      institutionId = -1;
    }

    init = true;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fillSubjectFields(),
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
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              flex: 10,
                              child: TextField(
                                  key: const Key('nameField'),
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
                                    nameController.clear();
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
                        AppLocalizations.of(context).acronym,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF71788D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      )
                    ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              flex: 10,
                              child: TextField(
                                  key: const Key('acronymField'),
                                  controller: acronymController,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    hintText:
                                        AppLocalizations.of(context).acronym,
                                    hintStyle: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF71788D),
                                        fontWeight: FontWeight.w400),
                                  )))
                        ]),
                    errors.containsKey('acronym')
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(errors['acronym']!,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)))
                        : const SizedBox(height: 0),
                    const SizedBox(height: 30),
                    ...institutionSelection(),
                    const SizedBox(height: 30),
                    widget.id == null && widget.callbackSubject != null
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                  AppLocalizations.of(context).evaluations,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF71788D),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                IconButton(
                                  key: const Key('addEvaluationButton'),
                                  padding: const EdgeInsets.all(0),
                                  icon: const Icon(Icons.add),
                                  color: const Color(0xFF71788D),
                                  iconSize: 20,
                                  splashRadius: 0.1,
                                  constraints: const BoxConstraints(
                                      maxWidth: 20, maxHeight: 20),
                                  onPressed: () {
                                    //SHOW POP-UP
                                    showEvaluationForm();
                                  },
                                ),
                              ]),
                    const SizedBox(height: 10),
                    ...getEvaluations(),
                    const SizedBox(height: 30),
                    displayEndButtons(context),
                  ]),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<Widget> institutionSelection() {
    List<Widget> widgets = [];

    if (widget.selectInstitution) {
      widgets.add(Row(children: [
        Text(
          AppLocalizations.of(context).institution,
          style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF71788D),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ]));

      widgets.add(const SizedBox(height: 10));

      widgets.add(Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Flexible(
            flex: 10,
            child: FutureBuilder(
                future: serviceLocator<InstitutionDao>().findAllInstitutions(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Institution>> snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data!.insert(
                        0,
                        Institution(
                            id: -1,
                            name: 'None',
                            type: InstitutionType.other,
                            userId: 0));
                    return DropdownButton<Institution>(
                        key: const Key('institutionField'),
                        isExpanded: true,
                        value: institutionId == -1
                            ? snapshot.data!.first
                            : snapshot.data!.firstWhere(
                                (element) => element.id == institutionId),
                        items: snapshot.data!.map((e) {
                          return DropdownMenuItem<Institution>(
                            value: e,
                            child: Text(e.name,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF71788D),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center),
                          );
                        }).toList(),
                        onChanged: (Institution? institution) {
                          setState(() {
                            institutionId = institution!.id!;
                          });
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }))
      ]));

      widgets.add(const SizedBox(height: 30));
    } else {
      widgets.add(const SizedBox());
    }

    return widgets;
  }

  validate() {
    errors = {};

    String name = nameController.text;
    String acronym = acronymController.text;

    if (name.isEmpty) {
      errors['name'] = AppLocalizations.of(context).name_error;
    }
    if (acronym.isEmpty) {
      errors['acronym'] = AppLocalizations.of(context).acronym_error;
    }

    setState(() {});
  }

  save(BuildContext context) async {
    String name = nameController.text;
    String acronym = acronymController.text;

    validate();

    if (errors.isEmpty) {
      Subject subject;
      if (widget.id != null) {
        subject = Subject(
            id: widget.id,
            name: name,
            acronym: acronym,
            institutionId: institutionId != -1 ? institutionId : null);

        await serviceLocator<SubjectDao>().updateSubject(subject);

        if (widget.callback != null) {
          widget.callback!();
        }
      } else {
        if (widget.callbackSubject == null) {
          subject = Subject(
              name: name,
              acronym: acronym,
              institutionId: institutionId != -1 ? institutionId : null);

          int newId = await serviceLocator<SubjectDao>().insertSubject(subject);

          for (int i = 0; i < evaluations.length; i++) {
            StudentEvaluation evaluation = evaluations[i];
            //new evaluation
            StudentEvaluation evaluationWithSubjectId = StudentEvaluation(
                name: evaluation.name,
                grade: evaluation.grade,
                subjectId: newId);
            await serviceLocator<StudentEvaluationDao>()
                .insertStudentEvaluation(evaluationWithSubjectId);
          }
        } else {
          subject = Subject(
            id: widget.subject == null ? null : widget.subject!.id,
            name: name,
            acronym: acronym,
            institutionId: institutionId != -1 ? institutionId : null,
          );

          widget.callbackSubject!(subject);
        }
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(); //streak
    }
  }

  List<Widget> getEvaluations() {
    List<Widget> evaluationsList = [];

    if (evaluations.isEmpty && !widget.create) {
      evaluationsList
          .add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppLocalizations.of(context).no_evaluations,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal))
      ]));
    } else {
      for (int i = 0; i < evaluations.length; i++) {
        evaluationsList.add(EvaluationBar(
          key: ValueKey(evaluations[i]),
          subjectId: widget.id,
          evaluation: evaluations[i],
          removeCallback: removeEvaluation,
          updateCallback: widget.id == null
              ? editTempEvaluationFactory(evaluations[i])
              : editEvaluation,
        ));
      }
    }
    return evaluationsList;
  }

  Widget displayEndButtons(BuildContext context) {
    if (widget.id == null) {
      return ElevatedButton(
          key: const Key('saveSubjectButton'),
          onPressed: () async {
            await save(context);
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
              key: const Key('saveSubjectButton'),
              onPressed: () async {
                await save(context);
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
              key: const Key('deleteSubjectButton'),
              onPressed: () async {
                await showDeleteConfirmation(context);
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

  showDeleteConfirmation(BuildContext context) {
    Widget cancelButton = TextButton(
      key: const Key('cancelDeleteSubjectButton'),
      child: Text(AppLocalizations.of(context).cancel,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget deleteButton = TextButton(
      key: const Key('deleteSubjectConfirmationButton'),
      child: Text(AppLocalizations.of(context).delete,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      onPressed: () async {
        Subject? subject = await serviceLocator<SubjectDao>()
            .findSubjectById(widget.id!)
            .first;

        await serviceLocator<SubjectDao>().deleteSubject(subject!);

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }

        bool badge = await insertLogAndCheckStreak();
        if (badge) {
          //show badge
          callBadgeWidget(); //streak
        }

        if (widget.callback != null) {
          widget.callback!();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).delete_subject,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      content: Text(AppLocalizations.of(context).delete_subject_message,
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

  addEvaluation(StudentEvaluation evaluation) {
    setState(() {
      evaluations.add(evaluation);
    });
  }

  editEvaluation(StudentEvaluation evaluation) {
    setState(() {
      if (widget.id != null) {
        // Our evaluations have an id and were updated in the evaluationForm
        for (int i = 0; i < evaluations.length; i++) {
          if (evaluations[i].id == evaluation.id) {
            evaluations[i] = evaluation;
            break;
          }
        }
      } else {
        throw Exception("Subject id is null for edit evaluation callback");
      }
    });
  }

  editTempEvaluationFactory(StudentEvaluation oldEvaluation) {
    return (StudentEvaluation evaluation) {
      setState(() {
        if (widget.id == null) {
          for (int i = 0; i < evaluations.length; i++) {
            if (evaluations[i] == oldEvaluation) {
              evaluations[i] = evaluation;
              break;
            }
          }
        } else {
          throw Exception(
              "Task id is not null for edit temp evaluation callback");
        }
      });
    };
  }

  removeEvaluation(StudentEvaluation evaluation) async {
    if (evaluation.id != null) {
      await serviceLocator<StudentEvaluationDao>()
          .deleteStudentEvaluation(evaluation);
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      callBadgeWidget(); //streak
    }

    setState(() {
      evaluations.remove(evaluation);
    });
  }

  showEvaluationForm() {
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).add_evaluation,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      backgroundColor: modalBackground,
      content: EvaluationForm(subjectId: widget.id, callback: addEvaluation),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  callBadgeWidget() {
    unlockBadgeForUser(3, context); //streak
  }
}
