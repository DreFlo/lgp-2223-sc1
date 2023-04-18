// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/subject.dart';

class SubjectBar extends StatefulWidget {
  final int? id;
  final Function? callback;
  final bool selectInstitution;
  final Subject subject;

  const SubjectBar(
      {Key? key,
      required this.subject,
      this.id,
      this.callback,
      this.selectInstitution = true})
      : super(key: key);

  @override
  State<SubjectBar> createState() => _SubjectBarState();
}

class _SubjectBarState extends State<SubjectBar> {
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
                      builder: (context, scrollController) => SubjectForm(
                        id: widget.id,
                        scrollController: scrollController,
                        callback: widget.callback,
                        selectInstitution: widget.selectInstitution,
                        subject: widget.id == null ? widget.subject : null,
                      ),
                    )));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: lightGray),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(widget.subject.acronym,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600))
                ])
              ]),
              const SizedBox(width: 10),
              Flexible(
                  flex: 1,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.subject.name,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal))
                      ]))
            ]),
          ),
        ));
  }
}
