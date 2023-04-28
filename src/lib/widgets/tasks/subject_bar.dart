import 'package:flutter/material.dart';
import 'package:src/pages/tasks/subject_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/models/student/subject.dart';

class SubjectBar extends StatefulWidget {
  final int? id;
  final bool selectInstitution;
  final Subject subject;
  final Function(int)? removeCallbackById;
  final Function(Subject)? removeCallbackBySubject;
  final Function(Subject)? updateCallbackBySubject;
  final Function()? updateCallback;

  const SubjectBar(
      {Key? key,
      required this.subject,
      this.id,
      this.selectInstitution = true,
      this.removeCallbackById,
      this.removeCallbackBySubject,
      this.updateCallbackBySubject,
      this.updateCallback})
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
                        callback: widget.updateCallback,
                        callbackSubject: widget.updateCallbackBySubject,
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
              ),
              IconButton(
                  color: Colors.white,
                  splashRadius: 0.01,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (widget.id != null) {
                      widget.removeCallbackById!(widget.id!);
                    } else {
                      widget.removeCallbackBySubject!(widget.subject);
                    }
                  })
            ]),
          ),
        ));
  }
}
