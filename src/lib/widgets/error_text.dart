import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String text;

  const ErrorText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFFE74C3C),
            fontSize: 12,
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center);
  }
}
