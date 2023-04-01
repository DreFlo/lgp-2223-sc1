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

import '../../widgets/leisure_tag.dart';

class AddToCatalogForm extends StatefulWidget {
  String startDate, endDate;
  Status? status;

  AddToCatalogForm(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.status})
      : super(key: key);

  @override
  State<AddToCatalogForm> createState() => _AddToCatalogFormState();
}

class _AddToCatalogFormState extends State<AddToCatalogForm> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    return Wrap(
      spacing: 10, 
      children: [
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
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).status,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  highlightColor: lightGray,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          alignment: const Alignment(0, 0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: (widget.status == Status.planTo
                                  ? leisureColor
                                  : lightGray)),
                          child: Text(AppLocalizations.of(context).plan_to,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                  onTap: () {
                    widget.status = Status.planTo;

                    setState(() {});
                  },
                ),
                InkWell(
                  highlightColor: lightGray,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          alignment: const Alignment(0, 0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: (widget.status == Status.goingThrough
                                  ? leisureColor
                                  : lightGray)),
                          child: Text(AppLocalizations.of(context).going_through,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                  onTap: () {
                    widget.status = Status.goingThrough;

                    setState(() {});
                  },
                ),
                InkWell(
                  highlightColor: lightGray,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          alignment: const Alignment(0, 0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: (widget.status == Status.done
                                  ? leisureColor
                                  : lightGray)),
                          child: Text(
                              AppLocalizations.of(context).done,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                  onTap: () {
                    widget.status = Status.done;

                    setState(() {});
                  },
                ),
              ],
            ),
            
            SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                highlightColor: lightGray,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        alignment: const Alignment(0, 0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: (widget.status == Status.nothing
                                ? leisureColor
                                : lightGray)),
                        child: Text(AppLocalizations.of(context).nothing,
                            style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ),
                onTap: () {
                  widget.status = Status.nothing;

                  setState(() {});
                },
              ),
              InkWell(
                highlightColor: lightGray,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        alignment: const Alignment(0, 0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: (widget.status == Status.dropped
                                ? leisureColor
                                : lightGray)),
                        child: Text(AppLocalizations.of(context).dropped,
                            style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ),
                onTap: () {
                  widget.status = Status.dropped;

                  setState(() {});
                },
              )],)
          ])),
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
          padding: const EdgeInsets.only(left: 18, right: 18),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F3443),
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
                        const VerticalDivider(
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
      const SizedBox(height: 50)
    ]);
  }
}
