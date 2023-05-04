import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final bool focus;

  const CountdownTimer({Key? key, required this.seconds, required this.focus})
      : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  @override
  void initState() {
    super.initState();
  }

  String get timerText {
    Duration duration = Duration(seconds: widget.seconds);
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Color get mainColor {
    return widget.focus ? primaryColor : darkGrayBackground;
  }

  Color get borderColor {
    return widget.focus ? darkGrayBackground : primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: borderColor,
            blurRadius: 8,
          ),
        ],
        border: Border.fromBorderSide(
          BorderSide(
            color: borderColor,
            width: 8,
          ),
        ),
        shape: BoxShape.circle,
        color: mainColor,
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
