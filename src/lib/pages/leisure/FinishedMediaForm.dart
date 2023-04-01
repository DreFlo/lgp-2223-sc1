import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/enums.dart';
import 'package:emojis/emojis.dart';

import '../../widgets/LeisureTag.dart';

class FinishedMediaForm extends StatefulWidget {
  String startDate, endDate;
  Reaction rating;
  bool isFavorite;

  FinishedMediaForm(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.rating,
      required this.isFavorite})
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
            padding: const EdgeInsets.only(top: 15, bottom: 15),
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
          padding: const EdgeInsets.only(left: 18),
          child: Container(
              child: Column(children: [
            Text(AppLocalizations.of(context).finished_media,
                softWrap: true,
                textWidthBasis: TextWidthBasis.longestLine,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left)
          ]))),
      Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Container(
            child: Column(children: [
              Text(AppLocalizations.of(context).what_thoughts,
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left),
            ]),
          )),
      const SizedBox(height: 50),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).date,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Padding(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: InkWell(
              onTap: () async {
                DateTimeRange? newDateRange = await showDateRangePicker(
                    builder: (context, Widget? child) => Theme(
                          data: ThemeData.from(
                              textTheme: const TextTheme(
                                labelMedium: TextStyle(
                                    color: Colors.white, fontFamily: "Poppins"),
                                labelSmall: TextStyle(
                                    color: Colors.white, fontFamily: "Poppins"),
                              ),
                              colorScheme: const ColorScheme.dark(
                                primary: leisureColor,
                              )),
                          child: child!,
                        ),
                    initialEntryMode: DatePickerEntryMode.input,
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
      const SizedBox(height: 50),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).what_you_thought,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                highlightColor: lightGray,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        alignment: const Alignment(0, 0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            color: (widget.rating == Reaction.hate
                                ? leisureColor
                                : lightGray)),
                        child: const Text(Emojis.confoundedFace,
                            style: TextStyle(fontSize: 30)))
                  ],
                ),
                onTap: () {
                  widget.rating = Reaction.hate;

                  setState(() {});
                },
              ),
              InkWell(
                highlightColor: lightGray,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        color: (widget.rating == Reaction.dislike
                            ? leisureColor
                            : lightGray),
                        alignment: const Alignment(0, 0),
                        child: Text(Emojis.pensiveFace,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30)))
                  ],
                ),
                onTap: () {
                  widget.rating = Reaction.dislike;
                  setState(() {});
                },
              ),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        color: (widget.rating == Reaction.neutral
                            ? leisureColor
                            : lightGray),
                        alignment: const Alignment(0, 0),
                        child: const Text(Emojis.neutralFace,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30)))
                  ],
                ),
                onTap: () {
                  widget.rating = Reaction.neutral;

                  setState(() => {});
                },
              ),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        color: (widget.rating == Reaction.like
                            ? leisureColor
                            : lightGray),
                        alignment: const Alignment(0, 0),
                        child: const Text(Emojis.smilingFace,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30)))
                  ],
                ),
                onTap: () {
                  widget.rating = Reaction.like;

                  setState(() => {});
                },
              ),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: (widget.rating == Reaction.love
                                ? leisureColor
                                : lightGray)),
                        alignment: const Alignment(0, 0),
                        child: const Text(Emojis.smilingFaceWithHeartEyes,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30)))
                  ],
                ),
                onTap: () {
                  widget.rating = Reaction.love;

                  setState(() => {});
                },
              )
            ],
          )),
      const SizedBox(height: 50),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).any_thoughts,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: 200,
            child: TextField(
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 10,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: lightGray,
                  helperStyle: Theme.of(context).textTheme.labelSmall,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ))),
      ),
      const SizedBox(height: 50),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).is_favorite_question,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () {
                  widget.isFavorite = !widget.isFavorite;

                  setState(() {});
                },
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.copy(
                      Size(
                        (((MediaQuery.of(context).size.width * 0.9) - 10) /
                            2), 50))),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)))),
                    backgroundColor: MaterialStateProperty.all(
                        widget.isFavorite ? leisureColor : lightGray)),
                child: Text(AppLocalizations.of(context).yes,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ))),
            const VerticalDivider(color: modalBackground, thickness: 10),
            ElevatedButton(
                onPressed: () {
                  widget.isFavorite = !widget.isFavorite;

                  setState(() {});
                },
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.copy(
                      Size(
                        (((MediaQuery.of(context).size.width * 0.9) - 10) /
                            2), 50))),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)))),
                    backgroundColor: MaterialStateProperty.all(
                        !widget.isFavorite ? leisureColor : lightGray)),
                child: Text(AppLocalizations.of(context).no,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    )))
          ])),
      const SizedBox(height: 100)
    ]);
  }
}
