import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class StudentStats extends StatelessWidget {
  final String stat;
  final String value;

  const StudentStats({Key? key, required this.stat, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$value ",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
              ),
        ),
        Text(
          stat,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                color: primaryColor,
              ),
        ),
      ],
    );
  }
}
