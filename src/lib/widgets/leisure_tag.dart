import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:like_button/like_button.dart';

class LeisureTag extends StatelessWidget {
  final String text;

  const LeisureTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: lightGray,
        ),
        padding: EdgeInsets.only(bottom: 5, top: 5, left: 7.5, right: 7.5),
        child: Text(this.text.toUpperCase(),
            style: Theme.of(context).textTheme.displaySmall));
  }
}
