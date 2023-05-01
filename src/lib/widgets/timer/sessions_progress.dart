import 'package:flutter/material.dart';

class SessionsProgress extends StatefulWidget {
  final int sessions;
  final int currentSession;

  const SessionsProgress({
    Key? key,
    required this.sessions,
    required this.currentSession,
  }) : super(key: key);

  @override
  State<SessionsProgress> createState() => _SessionsProgressState();
}

class _SessionsProgressState extends State<SessionsProgress> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.sessions,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index < widget.currentSession
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
