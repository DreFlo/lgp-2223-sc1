import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class StartButton extends StatefulWidget {
  final void Function() onStartCallback;

  const StartButton({
    Key? key,
    required this.onStartCallback,
  }) : super(key: key);

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          widget.onStartCallback();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(AppLocalizations.of(context).start_,
            style: Theme.of(context).textTheme.headlineSmall));
  }
}