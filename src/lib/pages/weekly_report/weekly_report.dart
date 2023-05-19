import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class WeeklyReport extends StatefulWidget {
  const WeeklyReport({Key? key}) : super(key: key);

  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  String startDate = 'May 7th';
  String endDate = 'May 13th';

  @override
  Widget build(BuildContext context) {
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
                              image: AssetImage('assets/images/emil.png'),
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
                                  Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height),
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
                                        children: const [
                                          Text(
                                            "11",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            " EVENTS",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            "10",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            " PROJECTS",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            "30",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            " TASKS",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
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
                                        const Text("THIS WAS THE"),
                                        Row(children: const [
                                          Text(" PROJECT",
                                              style: TextStyle(
                                                color: studentColor,
                                                // TODO
                                                fontWeight: FontWeight.w600,
                                              )),
                                          Text(" THIS TIME")
                                        ]),
                                      ])
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(children: const [
                                            Text(
                                              "72",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              " UNIQUE",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ]),
                                          const Text(
                                            "PIECES OF MEDIA,",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text(
                                            "WITH A TOTAL OF",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(children: const [
                                            Text(
                                              "20",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              " NOTES",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ]),
                                          const Text(
                                            "AND YOU LOVED",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  "73%",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    height: 1,
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " OF IT ALL",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    height: 1,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ]),
                                          const Text(
                                            "AND YOU HAVE",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  "15",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    height: 1,
                                                    color: leisureColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " FAVORITES",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    height: 1,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
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
  }
}
