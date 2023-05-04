import 'package:flutter/material.dart';
import 'package:src/pages/tasks/subject_show.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/subject.dart';

class SubjectBarShow extends StatefulWidget {
  final Subject subject;
  final Function() callback;

  const SubjectBarShow(
      {Key? key, required this.subject, required this.callback})
      : super(key: key);

  @override
  State<SubjectBarShow> createState() => _SubjectBarShowState();
}

class _SubjectBarShowState extends State<SubjectBarShow> {
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
                builder: (context) => Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                    child: DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.75,
                        minChildSize: 0.75,
                        maxChildSize: 0.75,
                        builder: (context, scrollController) => SubjectShow(
                              scrollController: scrollController,
                              id: widget.subject.id!,
                              callback: widget.callback,
                            ))));
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
                            Text(widget.subject.acronym,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(widget.subject.name,
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
