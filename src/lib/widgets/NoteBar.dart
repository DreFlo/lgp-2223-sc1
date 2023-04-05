// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class NoteBar extends StatefulWidget {
  final String text;

  const NoteBar({Key? key, required this.text}) : super(key: key);

  @override
  State<NoteBar> createState() => _NoteBarState();
}

class _NoteBarState extends State<NoteBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: lightGray),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Flexible(
                child: Text(widget.text,
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)))
          ])
        ]));
  }
}
