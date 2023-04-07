import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeMessage extends StatefulWidget {
  final String name;

  const WelcomeMessage({Key? key, required this.name}) : super(key: key);

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> {
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
