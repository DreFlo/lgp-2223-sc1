// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/pages/events/choose_activity_form.dart';
import 'package:src/themes/colors.dart';

class ChooseActivityBar extends StatefulWidget {
  final ChooseActivity activity;

  const ChooseActivityBar({Key? key, required this.activity}) : super(key: key);

  @override
  State<ChooseActivityBar> createState() => _ChooseActivityBarState();
}

class _ChooseActivityBarState extends State<ChooseActivityBar> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: lightGray),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(widget.activity.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(widget.activity.description,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 127, 127, 127),
                        fontSize: 16,
                        fontWeight: FontWeight.normal))
              ])
            ]),
            Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            widget.activity.isSelected = !widget.activity.isSelected;
                          });
                        },
                        child: widget.activity.isSelected
                            ? const Icon(Icons.check_box,
                            color: Colors.white, size: 30)
                            : const Icon(Icons.check_box_outline_blank,
                            color: Colors.white, size: 30))
                  ],
                )
              ],
            )
          ]),
        ));
  }
}
