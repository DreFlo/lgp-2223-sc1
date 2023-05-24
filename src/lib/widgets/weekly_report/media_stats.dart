import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class MediaStats extends StatelessWidget {
  final String stat;
  final String value;
  final Color? color;

  const MediaStats({Key? key, required this.stat, required this.value, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        "$value ",
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: 25,
          color: color ?? primaryColor,
        ),
      ),
      Text(
        stat,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: 25,
        ),
      ),
    ]);
  }
}
