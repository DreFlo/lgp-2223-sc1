import 'package:flutter/material.dart';

class SeasonTag extends StatelessWidget {
  final String text;
  bool selected;

  SeasonTag({Key? key, required this.text, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    return Expanded(
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)));
  }
}
