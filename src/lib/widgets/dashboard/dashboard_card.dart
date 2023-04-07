import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final String module;
  final String subject;
  final String institution;
  final int nTasks;

  const DashboardCard(
      {Key? key,
      required this.title,
      required this.subject,
      required this.module,
      required this.institution,
      required this.nTasks})
      : super(key: key);

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  final Map<String, Color> moduleColors = {
    'Student': studentColor,
    'Leisure': leisureColor,
    'Personal': personalColor,
    'Fitness': fitnessColor,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // TODO: Navigate to project page
        },
        child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: grayButton,
            ),
            child: Container(
                margin: const EdgeInsets.all(12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(bottom: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: moduleColors[widget.module],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.labelLarge,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.institution != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: grayBackground,
                                      ),
                                      child: Text(
                                        widget.institution,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(
                                              color:
                                                  moduleColors[widget.module],
                                            ),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: grayBackground,
                                ),
                                child: Text(
                                  widget.subject,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        color: moduleColors[widget.module],
                                      ),
                                ),
                              ),
                            ],
                          ),
                          widget.nTasks != 0
                              ? Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: primaryColor,
                                  ),
                                  child: Center(
                                      child: Text(widget.nTasks.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge)),
                                )
                              : Container(),
                        ],
                      )
                    ]))));
  }
}
