import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final void Function() onDeleteCallback;

  const DeleteConfirmationDialog({Key? key, required this.onDeleteCallback})
      : super(key: key);

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
          key: const Key('cancelDeleteButton'),
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
          key: const Key('deleteButton'),
          child: Text(AppLocalizations.of(context).delete,
              style: const TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          onPressed: () async {
            widget.onDeleteCallback();
            Navigator.pop(context);
          },
        )
      ],
      backgroundColor: lightGray,
    );
  }
}
