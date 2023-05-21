import 'package:flutter/material.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/user.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/user.dart';
import 'package:src/utils/weekly_report/weekly_report_logic.dart';

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
                                const Text(
                                  'WEEKLY REPORT',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 30),
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
                              "from $startDate to $endDate",
                              style: const TextStyle(
                                fontSize: 15,
                                color: grayText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.only(
                                        top: 30, right: 15, left: 15),
                                    child: Column(children: [
                                      const SizedBox(height: 20),
                                      const Text(
                                        "What a ride this [WEEK] was!",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        "Let's go over what you've been doing.",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: grayText,
                                          fontWeight: FontWeight.w400,
                                        ),
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
                                        child: const Text(
                                          "YOU'VE BEEN PRODUCTIVE!",
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "...you've completed",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: grayText,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    numberFinishedEvents
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Text(
                                                    " EVENTS",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    numberFinishedTaskGroups
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Text(
                                                    " PROJECTS",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    numberFinishedTasks
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Text(
                                                    " TASKS",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(), // TODO
                                                // mostFinishedTaskGroup (check if not null)
                                                const Text("THIS WAS THE"),
                                                Row(children: const [
                                                  Text(" PROJECT",
                                                      style: TextStyle(
                                                        color: studentColor,
                                                        // TODO
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                  Text(" THIS TIME")
                                                ]),
                                              ])
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: const [
                                            Text(
                                              "...but that’s not all you should be proud of!",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: grayText,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(height: 20),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    "YOU ENRICHED YOUR LIFE WITH",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      numberMedia.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 30,
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      " UNIQUE",
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ]),
                                                  const Text(
                                                    "PIECES OF MEDIA,",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "WITH A TOTAL OF",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      numberNotes.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 30,
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      " NOTES",
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ]),
                                                  const Text(
                                                    "AND YOU LOVED",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "$percentageFavoriteMedia%",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 30,
                                                            height: 1,
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const Text(
                                                          " OF IT ALL",
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            height: 1,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]),
                                                  const Text(
                                                    "AND YOU HAVE",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          numberFavoriteMedia
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 30,
                                                            height: 1,
                                                            color: leisureColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const Text(
                                                          " FAVORITES",
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            height: 1,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ])
                                                ])
                                          ])
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
