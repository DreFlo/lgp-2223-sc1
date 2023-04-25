import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/widgets/events/dialogs/delete_confirmation_dialog.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const DeleteConfirmationDialog();
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
