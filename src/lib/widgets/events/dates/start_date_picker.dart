import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/formatters.dart';

class StartDatePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, String> errors;
  final Function setStartDate;

  const StartDatePicker(
      {Key? key,
      required this.startDate,
      required this.endDate,
      required this.setStartDate,
      required this.errors})
      : super(key: key);

  @override
  State<StartDatePicker> createState() => _EventDatePickerState();
}

class _EventDatePickerState extends State<StartDatePicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: widget.startDate,
            firstDate: widget.startDate,
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            Future.delayed(Duration.zero, () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                      hour: widget.startDate.hour,
                      minute: widget.startDate.minute));
              if (pickedTime != null) {
                setState(() {
                  final dateTime = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, pickedTime.hour, pickedTime.minute);

                  widget.setStartDate(dateTime);
                });
              }
            });
          }
        },
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Flexible(
              flex: 1,
              child: Column(children: [
                Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF414554),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_month_sharp,
                      color: Color(0xFF71788D),
                      size: 20,
                    ))
              ])),
          const SizedBox(width: 15),
          Flexible(
              flex: 5,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(children: [
                  Text(AppLocalizations.of(context).start,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF71788D),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                ]),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      highlightColor: lightGray,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatEventTime(widget.startDate),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal)),
                          widget.errors.containsKey('date')
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(widget.errors['date']!,
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)))
                              : const SizedBox(height: 0),
                        ],
                      ),
                    )
                  ],
                )
              ]))
        ]));
  }
}
