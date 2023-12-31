import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class LeisureTag extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;

  const LeisureTag(
      {Key? key, required this.text, this.textColor, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: (backgroundColor ?? lightGray),
        ),
        padding:
            const EdgeInsets.only(bottom: 5, top: 5, left: 7.5, right: 7.5),
        child: Text(text.toUpperCase(),
            style: TextStyle(
                color: (textColor ?? Colors.white),
                fontSize: 13,
                fontWeight: FontWeight.w600)));
  }
}
