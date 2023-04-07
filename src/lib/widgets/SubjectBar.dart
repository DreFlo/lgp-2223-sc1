// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/pages/tasks/SubjectForm.dart';
import 'package:src/themes/colors.dart';

class SubjectBar extends StatefulWidget {
  final String name, acronym;

  const SubjectBar({Key? key, required this.name, required this.acronym})
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
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: const Color(0xFF22252D),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
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
                    name: widget.name,
                    acronym: widget.acronym,
                    scrollController: scrollController,
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
              Text(widget.acronym,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600))
            ])
          ]),
          const SizedBox(width: 10),
          Flexible(
              flex: 1,
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(widget.name,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal))
              ]))
        ]),
      ),
    );
  }
}
