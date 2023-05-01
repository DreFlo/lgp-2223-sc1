import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:src/themes/colors.dart';

class TimerFormField extends StatefulWidget {
  final ScrollController scrollController;
  final String title;
  final IconData icon;
  final int currentValue;
  final int minValue;
  final int maxValue;
  final int step;
  final String unit;
  final void Function(int) onValueChanged;

  const TimerFormField(
      {Key? key,
      required this.scrollController,
      required this.title,
      required this.icon,
      required this.currentValue,
      required this.minValue,
      required this.maxValue,
      required this.step,
      required this.unit,
      required this.onValueChanged})
      : super(key: key);

  @override
  State<TimerFormField> createState() => _TimerFormFieldState();
}

class _TimerFormFieldState extends State<TimerFormField> {
  int initValue = 0;

  @override
  void initState() {
    super.initState();
    initValue = widget.currentValue;
  }

  showPickerNumber() {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: widget.minValue,
              end: widget.maxValue,
              initValue: initValue,
              jump: widget.step)
        ]),
        hideHeader: true,
        backgroundColor: lightGray,
        textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white),
        title: Text(widget.title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryColor)),
        onConfirm: (Picker picker, List value) {
          setState(() {
            widget.onValueChanged(picker.getSelectedValues()[0]);
          });
        }).showDialog(context, backgroundColor: lightGray);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await showPickerNumber();
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
                    child: Icon(
                      widget.icon,
                      color: const Color(0xFF71788D),
                      size: 20,
                    ))
              ])),
          const SizedBox(width: 15),
          Flexible(
              flex: 5,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF71788D),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      highlightColor: lightGray,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${widget.currentValue} ${widget.unit}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))
                        ],
                      ),
                    )
                  ],
                ),
              ]))
        ]));
  }
}
