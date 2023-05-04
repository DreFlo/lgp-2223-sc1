import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/widgets/tasks/evaluation_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EvaluationBar extends StatefulWidget {
  final StudentEvaluation evaluation;
  final int? subjectId;
  final Function(StudentEvaluation) removeCallback;
  final Function(StudentEvaluation) updateCallback;

  const EvaluationBar(
      {Key? key,
      required this.evaluation,
      this.subjectId,
      required this.removeCallback,
      required this.updateCallback})
      : super(key: key);

  @override
  State<EvaluationBar> createState() => _EvaluationBarState();
}

class _EvaluationBarState extends State<EvaluationBar> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 10),
        child: InkWell(
          onTap: () {
            showEvaluationForm(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: lightGray),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.evaluation.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(widget.evaluation.grade.toString(),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal)))
                          ])
                    ]),
              ),
              IconButton(
                  color: Colors.white,
                  splashRadius: 0.01,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    showDeleteConfirmation(context);
                  })
            ]),
          ),
        ));
  }

  showDeleteConfirmation(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      key: const Key('cancelConfirmationButton'),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5))),
      child: Text(AppLocalizations.of(context).cancel,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget deleteButton = ElevatedButton(
      key: const Key('deleteConfirmationButton'),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red[600]),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5))),
      child: Text(AppLocalizations.of(context).delete,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      onPressed: () async {
        widget.removeCallback(widget.evaluation);
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).delete_evaluation,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      content: Text(AppLocalizations.of(context).delete_evaluation_message,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      actions: [
        cancelButton,
        deleteButton,
      ],
      backgroundColor: modalDarkBackground,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showEvaluationForm(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).add_evaluation,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center),
      backgroundColor: modalDarkBackground,
      content: EvaluationForm(
          subjectId: widget.subjectId,
          evaluation: widget.evaluation,
          callback: widget.updateCallback),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
