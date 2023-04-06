import 'package:flutter/material.dart';

class MyWelcomeMessage extends StatefulWidget {
  final String name;

  const MyWelcomeMessage({Key? key, required this.name}) : super(key: key);

  @override
  State<MyWelcomeMessage> createState() => _MyWelcomeMessageState();
}

class _MyWelcomeMessageState extends State<MyWelcomeMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Hello,',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      Text(
        widget.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ]);
  }
}
