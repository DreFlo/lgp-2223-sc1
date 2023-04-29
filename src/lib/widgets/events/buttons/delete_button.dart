import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/widgets/events/dialogs/delete_confirmation_dialog.dart';

class DeleteButton extends StatefulWidget {
  final void Function() onDeleteCallback;

  const DeleteButton({Key? key, required this.onDeleteCallback})
      : super(key: key);

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteConfirmationDialog(
                onDeleteCallback: widget.onDeleteCallback,
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(AppLocalizations.of(context).delete,
            style: Theme.of(context).textTheme.headlineSmall));
  }
}
