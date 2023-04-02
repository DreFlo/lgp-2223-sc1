import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class NoteBar extends StatefulWidget {
  final String code;
  String text;

  NoteBar({Key? key, required this.code, required this.text}) : super(key: key);

  @override
  State<NoteBar> createState() => _NoteBarState();
}

class _NoteBarState extends State<NoteBar> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: lightGray),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(widget.code,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600))
              ]),
            ]),
            // Column(children: [
            //   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //     ElevatedButton(
            //         onPressed: () {
            //           setState(() {});

            //           //TODO: Add functionality for editing note.
            //         },
            //         style: ButtonStyle(
            //           minimumSize:
            //               MaterialStateProperty.all(const Size(45, 45)),
            //           backgroundColor: MaterialStateProperty.all(leisureColor),
            //           foregroundColor: MaterialStateProperty.all(Colors.white),
            //           shape: MaterialStateProperty.all<CircleBorder>(
            //               CircleBorder()),
            //         ),
            //         child: Icon(Icons.edit)),
            //   ]),
            // ]),
          ]),
          SizedBox(height: 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
