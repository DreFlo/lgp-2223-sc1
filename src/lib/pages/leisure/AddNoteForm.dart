import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class AddNoteForm extends StatefulWidget {
  String code;

  AddNoteForm({Key? key, required this.code}) : super(key: key);

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    return Wrap(spacing: 10, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Container(
              width: 115,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF414554),
              ),
            ))
      ]),
      Container(
          padding: const EdgeInsets.only(left: 18),
          child: Column(children: [
            Text(AppLocalizations.of(context).add_note_callout,
                softWrap: true,
                textWidthBasis: TextWidthBasis.longestLine,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left),
            const SizedBox(height: 10),
          ])),
      Padding(
          padding: EdgeInsets.only(left: 18),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 200,
              child: TextField(
                  autofocus: true,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: lightGray,
                    helperStyle: Theme.of(context).textTheme.labelSmall,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )))),
      Padding(
          padding: const EdgeInsets.only(left: 18, top: 30),
          child: ElevatedButton(
              onPressed: () {
                //TODO: Add functionality for adding note.
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.90, 55),
                backgroundColor: leisureColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(AppLocalizations.of(context).save,
                  style: Theme.of(context).textTheme.headlineSmall))),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SizedBox(height: 100)])
    ]);
  }
}
