import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/themes/colors.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage(
      {Key? key})
      : super(key: key);

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  late String image;

  @override
  initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Wrap(spacing: 10, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Container(
                  width: 115,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF414554),
                  ),
                ))
          ]),
          const SizedBox(height: 10),
        ]));
  }
}
