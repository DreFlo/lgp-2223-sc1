// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/widgets/BookNoteBar.dart';

class BookNotesSheet extends StatefulWidget {
  final Map<String, String> notes;

  const BookNotesSheet(
      {Key? key, required this.notes})
      : super(key: key);

  @override
  State<BookNotesSheet> createState() => _BookNotesSheetState();
}

class _BookNotesSheetState extends State<BookNotesSheet>
    with TickerProviderStateMixin {

  List<Widget> getNotes() {
    List<Widget> notes = [];

    for (var range in widget.notes.keys) {
      int startPage = int.parse(range.split('-')[0]),
          endPage = int.parse(range.split('-')[1]);

      notes.add(BookNoteBar(
        startPage: startPage,
        endPage: endPage,
        text: widget.notes[range]!,
      ));

      notes.add(const SizedBox(height: 15));
    }

    return notes;
  }

  @override
  Widget build(BuildContext context) {

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
                color: const Color(0xFF414554),
              ),
            ))
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).notes,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(children: getNotes())),
      const SizedBox(height: 50)
    ]);
  }
}
