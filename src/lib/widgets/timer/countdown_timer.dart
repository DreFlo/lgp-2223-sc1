import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int seconds;
  final bool focus;

  const CountdownTimerWidget(
      {Key? key, required this.seconds, required this.focus})
      : super(key: key);

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  @override
  void initState() {
    super.initState();
  }

  String get timerText {
    Duration duration = Duration(seconds: widget.seconds);
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.focus ? grayBackground : primaryColor,
            blurRadius: 8,
          ),
        ],
        border: Border.fromBorderSide(
          BorderSide(
            color: widget.focus ? grayBackground : primaryColor,
            width: 8,
          ),
        ),
        shape: BoxShape.circle,
        color: widget.focus ? primaryColor : grayBackground,
      ),
      child: Center(
        child: Text(
          timerText,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 65,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
