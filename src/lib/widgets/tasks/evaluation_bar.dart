import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/widgets/tasks/evaluation_form.dart';

class EvaluationBar extends StatefulWidget {
  final StudentEvaluation evaluation;
  final int? subjectId;
  final Function(StudentEvaluation) removeCallback;
  final Function(StudentEvaluation)? updateCallback;

  const EvaluationBar(
      {Key? key,
      required this.evaluation,
      this.subjectId,
      required this.removeCallback,
      this.updateCallback})
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
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    child: DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.5,
                      minChildSize: 0.5,
                      maxChildSize: 0.5,
                      builder: (context, scrollController) => EvaluationForm(
                        subjectId: widget.subjectId,
                        evaluation: widget.evaluation,
                        callback: widget.updateCallback,
                        deleteEvaluationCallback: widget.removeCallback,
                      ),
                    )));
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
                    widget.removeCallback(widget.evaluation);
                  })
            ]),
          ),
        ));
  }
}
