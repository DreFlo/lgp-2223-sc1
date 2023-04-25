import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class SaveButton extends StatefulWidget {
  final Function onSaveCallback;

  const SaveButton({
    Key? key,
    required this.onSaveCallback,
  }) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          widget.onSaveCallback();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(AppLocalizations.of(context).save,
            style: Theme.of(context).textTheme.headlineSmall));
  }
}
