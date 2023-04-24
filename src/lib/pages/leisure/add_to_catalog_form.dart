// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/daos/media/media_book_super_dao.dart';
import 'package:src/daos/media/media_series_super_dao.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/daos/media/season_dao.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/utils/service_locator.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:src/env/env.dart';

class AddToCatalogForm extends StatefulWidget {
  final String startDate, endDate;
  final Status status;
  final VoidCallback? refreshStatus;
  //final VoidCallback? setMediaId;
  final ValueSetter<Status> onStatusChanged;
  final dynamic item; //What we have from the api

  const AddToCatalogForm(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.item,
      //required this.setMediaId,
      required this.refreshStatus,
      required this.onStatusChanged})
      : super(key: key);

  @override
  State<AddToCatalogForm> createState() => _AddToCatalogFormState();
}

class _AddToCatalogFormState extends State<AddToCatalogForm> {
  late String startDate, endDate;
  late Status status;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    status = widget.status;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));

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
                color: const Color(0xFF414554),
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
                      widget.onStatusChanged(status);
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
                    widget.onStatusChanged(status);
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
                    widget.onStatusChanged(status);
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
                    widget.onStatusChanged(status);
                  },
                ))
              ],
            )
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
                    firstDate: DateTime.parse(startDate),
                    lastDate: DateTime.now());

                startDate = newDateRange!.start.toString().split(" ")[0];
                endDate = newDateRange.end.toString().split(" ")[0];

                setState(() {});
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
      const SizedBox(height: 50),
      //save button and actions -> will need to check what's the type of media
      //need also to pass the item
      /*Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ElevatedButton(
                onPressed: () async {
                  final details = await getDetails(widget.item['id'], 'Movie');

                  MediaVideoMovieSuperEntity movie = MediaVideoMovieSuperEntity(
                    name: widget.item['title'],
                    description: widget.item['overview'],
                    linkImage: widget.item['poster_path'],
                    status: status,
                    favorite: false,
                    genres: 'genres',
                    release: DateTime.parse(widget.item['release_date']),
                    xp: 0,
                    duration: details['runtime'] ?? 0,
                    participants: makeCastList(
                            await tmdb.v3.movies.getCredits(widget.item['id']))
                        .join(', '),
                    tagline: details['tagline'],
                  );

                  int mediaId = await serviceLocator<MediaVideoMovieSuperDao>()
                      .insertMediaVideoMovieSuperEntity(movie);
                      

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
              )))*/
    ]);
  }
}
