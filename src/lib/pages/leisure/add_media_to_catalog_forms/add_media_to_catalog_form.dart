import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/models/media/media.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/gamification/game_logic.dart';

abstract class AddMediaToCatalogForm<T extends Media> extends StatefulWidget {
  final String startDate, endDate;
  final Status status;
  final VoidCallback? refreshStatus;
  final Future Function() showReviewForm;
  final void Function(int) setMediaId;
  final T item; //What we have from the api

  const AddMediaToCatalogForm(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.item,
      required this.setMediaId,
      required this.showReviewForm,
      required this.refreshStatus})
      : super(key: key);

  @override
  State<AddMediaToCatalogForm> createState();
}

abstract class AddMediaToCatalogFormState<T extends Media>
    extends State<AddMediaToCatalogForm<T>> {
  late String startDate, endDate;
  late Status status;
  bool isLoading = false;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    status = widget.status;

    super.initState();
  }

  callBadgeWidget() {
    unlockBadgeForUser(3, context);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: [
      Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 115,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF414554),
              ),
            )
          ])),
      const SizedBox(height: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
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
                                color: (status == Status.planTo
                                    ? leisureColor
                                    : lightGray)),
                            child: Text(AppLocalizations.of(context).plan_to,
                                style: Theme.of(context).textTheme.bodySmall)),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        status = Status.planTo;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                    child: InkWell(
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
                              color: (status == Status.goingThrough
                                  ? leisureColor
                                  : lightGray)),
                          child: Text(
                              AppLocalizations.of(context).going_through,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      status = Status.goingThrough;
                    });
                  },
                )),
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(width: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: InkWell(
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
                              color: (status == Status.done
                                  ? leisureColor
                                  : lightGray)),
                          child: Text(AppLocalizations.of(context).done,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      status = Status.done;
                    });
                  },
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: InkWell(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: (status == Status.dropped
                                  ? leisureColor
                                  : lightGray)),
                          child: Text(AppLocalizations.of(context).dropped,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      status = Status.dropped;
                    });
                  },
                ))
              ],
            )
          ])),
      const SizedBox(height: 30),
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
          padding: const EdgeInsets.symmetric(horizontal: 18),
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
                  firstDate: DateTime(1),
                  lastDate: DateTime(9999),
                );

                if (newDateRange != null &&
                    newDateRange.start.isBefore(newDateRange.end)) {
                  startDate = newDateRange.start.toString().split(" ")[0];
                  endDate = newDateRange.end.toString().split(" ")[0];
                  setState(() {});
                }
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                              startDate,
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
                              endDate,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        )
                      ],
                    ))
              ]))),
      const SizedBox(height: 30),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              int mediaId = await storeMediaInDatabase(status);

              bool badge = await insertLogAndCheckStreak();
              if (badge) {
                //show badge
                callBadgeWidget(); //streak
              }

              widget.setMediaId(mediaId);

              if (widget.refreshStatus != null) {
                widget.refreshStatus!();
              }
              if (status == Status.done) {
                widget.showReviewForm();
              }

              setState(() {
                isLoading = false;
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
              backgroundColor: leisureColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: isLoading
        ? const CircularProgressIndicator() // Display circular progress indicator if loading
        : Text(
            AppLocalizations.of(context).save,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          )),
    ]);
  }

  Future<int> storeMediaInDatabase(Status status);
}
