import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        '${AppLocalizations.of(context).hello}, \n${widget.name}',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    ]);
  }
}
