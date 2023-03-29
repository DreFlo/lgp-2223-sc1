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

import '../../widgets/leisure_tag.dart';

class FinishedMediaForm extends StatefulWidget {
  String startDate, endDate;

  FinishedMediaForm({Key? key, required this.startDate, required this.endDate})
      : super(key: key);

  @override
  State<FinishedMediaForm> createState() => _FinishedMediaFormState();
}

class _FinishedMediaFormState extends State<FinishedMediaForm> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    return Wrap(spacing: 10, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Container(
              width: 115,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF414554),
              ),
            ))
      ]),
      Padding(
          padding: EdgeInsets.only(left: 18),
          child: Container(
              child: Column(children: [
            Text(AppLocalizations.of(context).finished_media,
                softWrap: true,
                textWidthBasis: TextWidthBasis.longestLine,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left)
          ]))),
      Padding(
          padding: EdgeInsets.only(left: 18),
          child: Container(
            child: Column(children: [
              Text(AppLocalizations.of(context).what_thoughts,
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left),
            ]),
          )),
      SizedBox(height: 50),
      Row(children: [
        Padding(
            padding: EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).date,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      SizedBox(height: 7.5),
      Padding(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: InkWell(
              onTap: () async {
                DateTimeRange? newDateRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.parse(widget.startDate),
                    lastDate: DateTime.now());

                widget.startDate = newDateRange!.start.toString().split(" ")[0];
                widget.endDate = newDateRange.end.toString().split(" ")[0];

                setState(() {});
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF2F3443),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.startDate,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ),
                        VerticalDivider(
                            color: Color(0xFF22252D), thickness: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.endDate,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        )
                      ],
                    ))
              ]))),
      SizedBox(height: 50),
      Padding(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF2F3443),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameInputController,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: Theme.of(context).textTheme.bodySmall),
                    )
                  ],
                ))
          ])),
      SizedBox(height: 100)
    ]);
  }
}
