import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  const DeleteConfirmationDialog({Key? key}) : super(key: key);

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).delete_event,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.start),
      content: Text(AppLocalizations.of(context).delete_event_message,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.start),
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context).cancel,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context).delete,
              style: const TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          onPressed: () {
            // TODO(eventos): delete event from database
          },
        )
      ],
      backgroundColor: lightGray,
    );
  }
}
