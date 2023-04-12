// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/leisure/finished_media_form.dart';
import 'package:src/themes/colors.dart';

import '../../../utils/enums.dart';

class AddBookNoteForm extends StatefulWidget {
  const AddBookNoteForm({Key? key}) : super(key: key);

  @override
  State<AddBookNoteForm> createState() => _AddBookNoteFormState();
}

class _AddBookNoteFormState extends State<AddBookNoteForm> {
  int? startPage, endPage;

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
      Container(
          padding: const EdgeInsets.only(left: 18),
          child: Column(children: [
            Text(AppLocalizations.of(context).progress_callout,
                softWrap: true,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left),
            const SizedBox(height: 10),
          ])),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).what_page,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: ((0.5 * (MediaQuery.of(context).size.width * 0.9)) - 10),
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
            SizedBox(
                width: ((0.5 * (MediaQuery.of(context).size.width * 0.9)) - 10),
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
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: TextButton(
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
                          minChildSize: 0.35,
                          maxChildSize: 0.75,
                          builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                50),
                                        child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: FinishedMediaForm(
                                                rating: Reaction.neutral,
                                                startDate: DateTime.now()
                                                    .toString()
                                                    .split(" ")[0],
                                                endDate: 'Not Defined',
                                                isFavorite: false))),
                                    Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                //TODO: Save stuff + send to database.
                                              },
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.95,
                                                    55),
                                                backgroundColor: leisureColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                ),
                                              ),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .save,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                            )))
                                  ])));
                },
                child: Text(
                  AppLocalizations.of(context).finished_book,
                  style: Theme.of(context).textTheme.displayMedium,
                )))
      ]),
      const SizedBox(height: 15),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).any_thoughts,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: 200,
                child: TextField(
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
                    ))))
      ]),
      Padding(
          padding: const EdgeInsets.only(left: 18, top: 30),
          child: ElevatedButton(
              onPressed: () {
                //TODO: Add functionality for adding note (sending to database).
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
      const SizedBox(height: 150)
    ]);
  }
}
