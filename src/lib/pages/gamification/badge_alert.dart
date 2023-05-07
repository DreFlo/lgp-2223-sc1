import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/constants.dart';

import 'package:src/themes/colors.dart';

class BadgeAlert extends StatefulWidget {
  final String title;
  final String description;
  final List<String> colors;
  final String icon;

  const BadgeAlert(
      {Key? key,
      required this.title,
      required this.description,
      required this.colors,
      required this.icon})
      : super(key: key);

  @override
  State<BadgeAlert> createState() => _BadgeAlertState();
}

class _BadgeAlertState extends State<BadgeAlert> with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Color> getColors() {
    List<Color> colors = [];
    for (String color in widget.colors) {
      colors.add(Color(int.parse(color, radix: 16)));
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: lightGray,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        content: Wrap(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).won_badge,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(decoration: BoxDecoration(gradient: LinearGradient(colors: getColors())),)
              ]
            ),
          ]
        )
    );
  }
}
