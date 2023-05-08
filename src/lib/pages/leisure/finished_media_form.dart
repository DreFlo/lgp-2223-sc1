import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:emojis/emojis.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/daos/media/review_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/review.dart';

class FinishedMediaForm extends StatefulWidget {
  final String startDate, endDate;
  final Reaction rating;
  final bool isFavorite;
  final int mediaId;
  final VoidCallback? refreshStatus;

  const FinishedMediaForm(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.rating,
      required this.mediaId,
      required this.isFavorite,
      required this.refreshStatus})
      : super(key: key);

  @override
  State<FinishedMediaForm> createState() => _FinishedMediaFormState();
}

class _FinishedMediaFormState extends State<FinishedMediaForm> {
  late String startDate, endDate;
  late Reaction rating;
  late bool isFavorite;
  TextEditingController controller = TextEditingController();
  late BuildContext? buildContext;

  @override
  initState() {
    isFavorite = widget.isFavorite;
    rating = widget.rating;
    startDate = widget.startDate;
    endDate = widget.endDate;

    super.initState();
  }

  callBadgeWidget() {
    unlockBadgeForUser(3, buildContext);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Wrap(spacing: 10, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 115,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF414554),
              ),
            )
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Text(AppLocalizations.of(context).finished_media,
                softWrap: true,
                textWidthBasis: TextWidthBasis.longestLine,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left)
          ]),
          Row(children: [
            Text(AppLocalizations.of(context).what_thoughts,
                softWrap: true,
                textWidthBasis: TextWidthBasis.longestLine,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left),
          ]),
          const SizedBox(height: 25),
          Row(children: [
            Text(
              AppLocalizations.of(context).date,
              style: Theme.of(context).textTheme.displayMedium,
            )
          ]),
          const SizedBox(height: 7.5),
          InkWell(
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
                      ),
                    ),
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
              ])),
          const SizedBox(height: 50),
          Row(children: [
            Text(
              AppLocalizations.of(context).what_you_thought,
              style: Theme.of(context).textTheme.displayMedium,
            )
          ]),
          const SizedBox(height: 7.5),
          SizedBox(
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
                                color: (rating == Reaction.hate
                                    ? leisureColor
                                    : lightGray)),
                            child: const Text(Emojis.confoundedFace,
                                style: TextStyle(fontSize: 30)))
                      ],
                    ),
                    onTap: () {
                      rating = Reaction.hate;

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
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            color: (rating == Reaction.dislike
                                ? leisureColor
                                : lightGray),
                            alignment: const Alignment(0, 0),
                            child: const Text(Emojis.pensiveFace,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30)))
                      ],
                    ),
                    onTap: () {
                      rating = Reaction.dislike;
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            color: (rating == Reaction.neutral
                                ? leisureColor
                                : lightGray),
                            alignment: const Alignment(0, 0),
                            child: const Text(Emojis.neutralFace,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30)))
                      ],
                    ),
                    onTap: () {
                      rating = Reaction.neutral;

                      setState(() => {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            color: (rating == Reaction.like
                                ? leisureColor
                                : lightGray),
                            alignment: const Alignment(0, 0),
                            child: const Text(Emojis.smilingFace,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30)))
                      ],
                    ),
                    onTap: () {
                      rating = Reaction.like;

                      setState(() => {});
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: (rating == Reaction.love
                                    ? leisureColor
                                    : lightGray)),
                            alignment: const Alignment(0, 0),
                            child: const Text(Emojis.smilingFaceWithHeartEyes,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30)))
                      ],
                    ),
                    onTap: () {
                      rating = Reaction.love;

                      setState(() => {});
                    },
                  )
                ],
              )),
          const SizedBox(height: 50),
          Row(children: [
            Text(
              AppLocalizations.of(context).any_thoughts,
              style: Theme.of(context).textTheme.displayMedium,
            )
          ]),
          const SizedBox(height: 7.5),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 200,
              child: TextField(
                  controller: controller,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: darkTextField,
                    helperStyle: Theme.of(context).textTheme.labelSmall,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ))),
          const SizedBox(height: 50),
          Row(children: [
            Text(
              AppLocalizations.of(context).is_favorite_question,
              style: Theme.of(context).textTheme.displayMedium,
            )
          ]),
          const SizedBox(height: 7.5),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              isFavorite = true;

                              setState(() {});
                            },
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(Size.copy(
                                    Size(
                                        (((MediaQuery.of(context).size.width *
                                                    0.9) -
                                                10) /
                                            2),
                                        50))),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)))),
                                backgroundColor: MaterialStateProperty.all(
                                    isFavorite ? leisureColor : lightGray)),
                            child: Text(AppLocalizations.of(context).yes,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ))),
                        const VerticalDivider(
                            color: modalLightBackground, thickness: 10),
                        ElevatedButton(
                            onPressed: () {
                              isFavorite = false;

                              setState(() {});
                            },
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(Size.copy(
                                    Size(
                                        (((MediaQuery.of(context).size.width *
                                                    0.9) -
                                                10) /
                                            2),
                                        50))),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)))),
                                backgroundColor: MaterialStateProperty.all(
                                    !isFavorite ? leisureColor : lightGray)),
                            child: Text(AppLocalizations.of(context).no,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                )))
                      ]))),
          const SizedBox(height: 50),
          Padding(
              padding: EdgeInsets.only(
                  top: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ElevatedButton(
                onPressed: () async {
                  String content = controller.text;
                  //We can send the review with no text
                  //Start date can't be after end date -> widget takes care of this constraint
                  DateTime start = DateTime.parse(startDate);
                  DateTime end = DateTime.parse(endDate);

                  Review review = Review(
                      startDate: start,
                      endDate: end,
                      review: content,
                      emoji: rating,
                      mediaId: widget.mediaId);

                  await serviceLocator<ReviewDao>().insertReview(review);

                  bool badge = await insertLogAndCheckStreak();
                  if (badge) {
                    //show badge
                    callBadgeWidget(); //streak
                  }

                  final mediaStream =
                      serviceLocator<MediaDao>().findMediaById(widget.mediaId);
                  Media? firstNonNullMedia =
                      await mediaStream.firstWhere((media) => media != null);
                  Media media = firstNonNullMedia!;
                  Media newMedia = Media(
                      description: media.description,
                      id: media.id,
                      name: media.name,
                      linkImage: media.linkImage,
                      favorite: isFavorite,
                      status: Status.done,
                      genres: media.genres,
                      release: media.release,
                      xp: media.xp,
                      participants: media.participants,
                      type: media.type);
                  await serviceLocator<MediaDao>().updateMedia(newMedia);

                  if (widget.refreshStatus != null) {
                    widget.refreshStatus!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.95, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).save,
                    style: Theme.of(context).textTheme.headlineSmall),
              ))
        ]));
  }
}
