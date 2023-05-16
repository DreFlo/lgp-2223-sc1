import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/pages/leisure/finished_media_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';

import 'package:src/utils/enums.dart';

class AddBookNoteForm extends StatefulWidget {
  final MediaBookSuperEntity book;
  final VoidCallback? refreshStatus;
  const AddBookNoteForm({Key? key, required this.book, this.refreshStatus})
      : super(key: key);

  @override
  State<AddBookNoteForm> createState() => _AddBookNoteFormState();
}

class _AddBookNoteFormState extends State<AddBookNoteForm> {
  int startPage = 0, endPage = 0;
  final TextEditingController _controller = TextEditingController();

  callBadgeWidget() {
    unlockBadgeForUser(3, context);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: [
      Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 115,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF414554),
              ),
            )
          ])),
      // const SizedBox(height: 15),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(children: [
            Text(AppLocalizations.of(context).progress_callout,
                softWrap: true,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left),
          ])),
      const SizedBox(height: 20),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context).what_page,
              style: Theme.of(context).textTheme.displayMedium,
            )
          ])),
      const SizedBox(height: 7.5),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Flexible(
                flex: 2,
                child: TextField(
                    onChanged: (input) {
                      setState(() {
                        startPage = int.parse(input);
                      });
                    },
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: textField,
                      helperStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ))),
            const SizedBox(width: 10),
            Flexible(
                flex: 2,
                child: TextField(
                    onChanged: (input) {
                      setState(() {
                        endPage = int.parse(input);
                      });
                    },
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: textField,
                      helperStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ))),
          ])),
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFF22252D),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.9,
                          minChildSize: 0.9,
                          maxChildSize: 0.9,
                          builder: (context, scrollController) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          50),
                              child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: FinishedMediaForm(
                                      rating: Reaction.neutral,
                                      startDate: DateTime.now()
                                          .toString()
                                          .split(" ")[0],
                                      endDate: DateTime.now()
                                          .toString()
                                          .split(" ")[0],
                                      isFavorite: false,
                                      mediaId: widget.book.id!,
                                      refreshStatus: () {
                                        widget.refreshStatus!();
                                        Navigator.pop(context);
                                      })))));
                },
                child: Text(
                  AppLocalizations.of(context).finished_book,
                  style: Theme.of(context).textTheme.displayMedium,
                ))
          ])),
      const SizedBox(height: 20),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).any_thoughts,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(children: [
            Flexible(
                child: TextField(
                    controller: _controller,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 10,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: textField,
                      helperStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )))
          ])),
      const SizedBox(height: 30),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ElevatedButton(
              onPressed: () async {
                NoteBookNoteSuperEntity note = NoteBookNoteSuperEntity(
                    bookId: widget.book.id!,
                    title: widget.book.name,
                    date: DateTime.now(),
                    content: _controller.text,
                    startPage: startPage,
                    endPage: endPage);

                await serviceLocator<NoteBookNoteSuperDao>()
                    .insertNoteBookNoteSuperEntity(note);

                bool badge = await insertLogAndCheckStreak();
                if (badge) {
                  //show badge
                  callBadgeWidget(); //streak
                }

                if (widget.refreshStatus != null) {
                  widget.refreshStatus!();
                }
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
      const SizedBox(height: 30)
    ]);
  }
}
