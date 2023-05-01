// make me a simple widget

import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  const HighlightText(this.text, {Key? key}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.normal));
  }
}
