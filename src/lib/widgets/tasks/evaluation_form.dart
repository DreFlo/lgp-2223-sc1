import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/student/evaluation_dao.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';

class EvaluationForm extends StatefulWidget {
  final int? subjectId;
  final void Function(StudentEvaluation evaluation) callback;
  final StudentEvaluation? evaluation;

  const EvaluationForm(
      {Key? key, this.subjectId, required this.callback, this.evaluation})
      : super(key: key);

  @override
  State<EvaluationForm> createState() => _EvaluationFormState();
}

class _EvaluationFormState extends State<EvaluationForm> {
  final nameController = TextEditingController();
  final gradeController = TextEditingController();

  Map<String, String> errors = {};
  bool init = false;

  @override
  void initState() {
    super.initState();
    fillTaskFields();
  }

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
    return Wrap(spacing: 10, children: [
      Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF414554))),
                    hintText: AppLocalizations.of(context).eval_name,
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
                  style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w400)))
          : const SizedBox(height: 0),
      const SizedBox(height: 7.5),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 60,
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
                  style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w400)))
          : const SizedBox(height: 0),
      displayEndButtons()
    ]);
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
        if (widget.evaluation != null) {
          // Edit an already existing evaluation

          evaluation = StudentEvaluation(
              id: widget.evaluation!.id!,
              name: nameController.text,
              grade: double.parse(gradeController.text),
              subjectId: widget.subjectId!);
          await serviceLocator<StudentEvaluationDao>()
              .updateStudentEvaluation(evaluation);
        } else {
          // Add a new evaluation to an existing subject
          evaluation = StudentEvaluation(
              name: nameController.text,
              grade: double.parse(gradeController.text),
              subjectId: widget.subjectId!);

          int id = await serviceLocator<StudentEvaluationDao>()
              .insertStudentEvaluation(evaluation);

          evaluation = StudentEvaluation(
              id: id,
              name: nameController.text,
              grade: double.parse(gradeController.text),
              subjectId: widget.subjectId!);
        }

        widget.callback(evaluation);
      } else {
        StudentEvaluation evaluation = StudentEvaluation(
            name: nameController.text,
            grade: double.parse(gradeController.text),
            subjectId: -1);

        widget.callback(evaluation);
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    bool badge = await insertLogAndCheckStreak();
    if (badge) {
      //show badge
      unlockBadgeForUser(1); //streak
    }
  }

  Widget displayEndButtons() {
    return ElevatedButton(
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
            style: Theme.of(context).textTheme.headlineSmall));
  }
}
