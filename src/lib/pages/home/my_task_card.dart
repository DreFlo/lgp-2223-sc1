import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:src/themes/colors.dart';

class MyTaskCard extends StatefulWidget {
  final String name;
  final DateTime deadline;
  final String module;

  const MyTaskCard(
      {Key? key,
      required this.name,
      required this.deadline,
      required this.module})
      : super(key: key);

  @override
  State<MyTaskCard> createState() => _MyTaskCardState();
}

class _MyTaskCardState extends State<MyTaskCard> {
  final Map<String, Color> moduleColors = {
    'Student': studentColor,
    'Leisure': leisureColor,
    'Personal': personalColor,
    'Fitness': fitnessColor,
  };

  formatDeadline(DateTime deadline) {
    Map<int, String> suffixes = {
      1: 'st',
      2: 'nd',
      3: 'rd',
    };

    String ordinalDay = (deadline.day >= 11 && deadline.day <= 13)
        ? 'th'
        : suffixes[deadline.day % 10] ?? 'th';

    return DateFormat("MMM d'$ordinalDay' - ha")
        .format(deadline)
        .replaceAll('AM', 'am')
        .replaceAll('PM', 'pm');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 33),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: grayButton,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(left: 25, right: 19, top: 15, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: moduleColors[widget.module],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200, // Set width of Text widget to 200
                child: Text(widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              const SizedBox(height: 5),
              Text(
                formatDeadline(widget.deadline),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ]),
        Container(
            margin: const EdgeInsets.only(right: 26),
            child: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 17))
      ]),
    );
  }
}
