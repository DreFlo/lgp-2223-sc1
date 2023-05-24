import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/user.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/user.dart';
import 'package:src/utils/weekly_report/weekly_report_logic.dart';
import 'package:src/widgets/weekly_report/media_carousel.dart';
import 'package:src/widgets/weekly_report/media_stats.dart';
import 'package:src/widgets/weekly_report/project_card.dart';
import 'package:src/widgets/weekly_report/project_horizontal_scrollview.dart';
import 'package:src/widgets/weekly_report/student_stats.dart';

class WeeklyReport extends StatefulWidget {
  const WeeklyReport({Key? key}) : super(key: key);

  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  late DateTime reportDay;
  late int numberFinishedEvents, numberFinishedTasks, numberFinishedTaskGroups;
  late int numberMedia, percentageFavoriteMedia, numberFavoriteMedia;
  late int numberNotes;
  late int xp, level;
  late List<Task> finishedTasks;
  late List<TaskGroup> contributedTaskGroups;
  late TaskGroup? mostFinishedTaskGroup;
  late List<Media> topMedia;

  late String startDate;
  late String endDate;

  bool init = false;

  Future<int> initData() async {
    if (init) {
      return 0;
    }
    DateTime now = DateTime.now();
    reportDay = DateTime(now.year, now.month, now.day);
    numberFinishedEvents = await getNumberFinishedEvents(reportDay) ?? 0;
    finishedTasks = await getFinishedTasks(reportDay);
    numberFinishedTasks = finishedTasks.length;
    contributedTaskGroups = await getContributedTaskGroups(finishedTasks);
    if (contributedTaskGroups.length > 0) {
      mostFinishedTaskGroup = contributedTaskGroups[0];
    }
    numberFinishedTaskGroups = await getNumberFinishedTaskGroups(finishedTasks);

    List<int> mediaStats = await getMediaStats();
    numberMedia = mediaStats[0];
    percentageFavoriteMedia = mediaStats[1];
    numberFavoriteMedia = mediaStats[2];
    numberNotes = await getNumberNotes();
    topMedia = await sortMediaByNumberOfNotes();

    User user = getUser();
    xp = user.xp;
    level = user.level;
    List<String> weekDates = getWeekBounds(reportDay);
    startDate = weekDates[0];
    endDate = weekDates[1];
    init = true;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initData(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    // Background container
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: const Alignment(0, -0.45),
                        colors: [
                          primaryColor,
                          appBackground,
                        ],
                      ),
                    ),
                  ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Flex(direction: Axis.vertical, children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Text(
                                    AppLocalizations.of(context)
                                        .weekly_report
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        )),
                                Container(
                                    margin: const EdgeInsets.only(top: 28),
                                    child: const Image(
                                      image:
                                          AssetImage('assets/images/emil.png'),
                                      height: 125,
                                      width: 125,
                                    ))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${AppLocalizations.of(context).from} $startDate ${AppLocalizations.of(context).to} $endDate",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: grayText,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, bottom: 25),
                                    child: Column(children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        AppLocalizations.of(context)
                                            .weekly_report_message_1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .weekly_report_message_2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                              color: grayText,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(children: [
                                        ProjectHorizontalScrollview(
                                          contributedTaskGroups:
                                              contributedTaskGroups,
                                        )
                                      ]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(colors: [
                                          leisureColor,
                                          studentColor,
                                        ]).createShader(
                                          Rect.fromLTWH(0, 0, bounds.width,
                                              bounds.height),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .you_ve_been_productive
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.copyWith(
                                                fontSize: 22,
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Text(
                                                AppLocalizations.of(context)
                                                    .you_ve_completed,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                      color: grayText,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        StudentStats(
                                                            stat: AppLocalizations
                                                                    .of(context)
                                                                .events
                                                                .toUpperCase(),
                                                            value:
                                                                numberFinishedEvents
                                                                    .toString()),
                                                        StudentStats(
                                                            stat: AppLocalizations
                                                                    .of(context)
                                                                .projects
                                                                .toUpperCase(),
                                                            value:
                                                                numberFinishedTaskGroups
                                                                    .toString()),
                                                        StudentStats(
                                                            stat: AppLocalizations
                                                                    .of(context)
                                                                .tasks
                                                                .toUpperCase(),
                                                            value:
                                                                numberFinishedTasks
                                                                    .toString()),
                                                      ]))
                                            ],
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: grayButton,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: studentColor,
                                                        offset: Offset(5, -5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ProjectCard(
                                                      taskGroup:
                                                          mostFinishedTaskGroup),
                                                ),
                                                // mostFinishedTaskGroup (check if not null)
                                                const SizedBox(height: 10),
                                                Text(AppLocalizations.of(
                                                        context)
                                                    .weekly_report_message_4_1
                                                    .toUpperCase()),
                                                Row(children: [
                                                  Text(
                                                      " ${AppLocalizations.of(context).project.toUpperCase()} ",
                                                      style: const TextStyle(
                                                        color: studentColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                  Text(AppLocalizations.of(
                                                          context)
                                                      .weekly_report_message_4_2
                                                      .toUpperCase())
                                                ]),
                                              ])
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .weekly_report_message_3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                    color: grayText,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ]),
                                      const SizedBox(height: 20),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width: 145,
                                                height: 295,
                                                child: MediaCarousel(
                                                    topMedia: topMedia)),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .weekly_report_message_5
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  MediaStats(
                                                      stat: AppLocalizations.of(
                                                              context)
                                                          .unique
                                                          .toUpperCase(),
                                                      value: numberMedia
                                                          .toString()),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .pieces_of_media
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      height: 1.2,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .with_a_total_of
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      height: 2,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  MediaStats(
                                                      stat: AppLocalizations.of(
                                                              context)
                                                          .notes
                                                          .toUpperCase(),
                                                      value: numberNotes
                                                          .toString()),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .and_you_loved
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  MediaStats(
                                                      stat: AppLocalizations.of(
                                                              context)
                                                          .of_it_all
                                                          .toUpperCase(),
                                                      value:
                                                          "$percentageFavoriteMedia%"),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .and_you_have
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  MediaStats(
                                                      stat: AppLocalizations.of(
                                                              context)
                                                          .favorites
                                                          .toUpperCase(),
                                                      value: numberFavoriteMedia
                                                          .toString(),
                                                      color: leisureColor),
                                                  const SizedBox(height: 10),
                                                  Column(children: [
                                                    Text(
                                                      topMedia[0].name,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: leisureColor,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .got_you_pretty_chatty,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            )),
                                                    const SizedBox(height: 10),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          // TODO navigate to top media notes page
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              primaryColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 5),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                          ),
                                                        ),
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .see_notes,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ))),
                                                  ]),
                                                ])
                                          ]),
                                      const SizedBox(height: 20),
                                      Text(
                                        AppLocalizations.of(context)
                                            .keep_it_up
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 45,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .you_ve_already_reached
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                height: 1,
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              " ${AppLocalizations.of(context).level.toUpperCase()} $level",
                                              style: const TextStyle(
                                                height: 1,
                                                fontSize: 15,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(height: 25),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color(0xFFF52349),
                                            Color(0xFFFFD551),
                                            Color(0xFF6C5DD3),
                                            Color(0xFFB3FF67),
                                            Color(0xFF4690FF)
                                          ]),
                                        ),
                                        child: Text(
                                          "${AppLocalizations.of(context).you_ve_racked_up.toUpperCase()} $xp ${AppLocalizations.of(context).xp}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ])))
                          ])))
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
