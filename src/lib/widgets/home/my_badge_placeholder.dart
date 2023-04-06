import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class MyBadgePlaceholder extends StatefulWidget {
  const MyBadgePlaceholder({Key? key}) : super(key: key);

  @override
  State<MyBadgePlaceholder> createState() => _MyBadgePlaceholderState();
}

class _MyBadgePlaceholderState extends State<MyBadgePlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 101,
      margin: const EdgeInsets.only(top: 25, right: 36, left: 36),
      decoration: const BoxDecoration(
        color: grayButton,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(5, 8), // changes position of shadow
          ),
        ],
      ),
      // TODO - add content here
    );
  }
}