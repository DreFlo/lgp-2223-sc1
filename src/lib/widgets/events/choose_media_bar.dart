// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/pages/events/choose_media_form.dart';
import 'package:src/themes/colors.dart';

class ChooseMediaBar extends StatefulWidget {
  final ChooseMedia media;

  const ChooseMediaBar(
      {Key? key,
        required this.media})
      : super(key: key);

  @override
  State<ChooseMediaBar> createState() => _ChooseMediaBarState();
}

class _ChooseMediaBarState extends State<ChooseMediaBar> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          //TODO: Open media form filled out.
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: lightGray),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(widget.media.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(widget.media.type,
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
                            widget.media.isSelected = !widget.media.isSelected;
                          });
                        },
                        child: widget.media.isSelected
                            ? const Icon(Icons.check_box,
                            color: Colors.white, size: 30)
                            : const Icon(Icons.check_box_outline_blank,
                            color: Colors.white, size: 30)
                    )
                  ],
                )
              ],
            )
          ]),
        ));
  }
}
