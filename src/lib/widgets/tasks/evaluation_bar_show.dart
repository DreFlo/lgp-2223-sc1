import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/evaluation.dart';

class EvaluationBarShow extends StatefulWidget {
  final StudentEvaluation evaluation;

  const EvaluationBarShow({
    Key? key,
    required this.evaluation,
  }) : super(key: key);

  @override
  State<EvaluationBarShow> createState() => _EvaluationBarShowState();
}

class _EvaluationBarShowState extends State<EvaluationBarShow> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 10),
        child: InkWell(
          onTap: () {},
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
              )
            ]),
          ),
        ));
  }
}
