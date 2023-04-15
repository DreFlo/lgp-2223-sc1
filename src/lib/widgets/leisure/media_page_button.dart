// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/leisure/add_to_catalog_form.dart';
import 'package:src/pages/leisure/mark_episodes_sheet.dart';
import 'package:src/pages/leisure/episodes_notes_sheet.dart';
import 'package:src/pages/leisure/book_notes_sheet.dart';
import 'package:src/pages/leisure/add_book_note_form.dart';
import 'package:src/pages/leisure/finished_media_form.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/daos/notes/note_book_note_super_dao.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/enums.dart';

class MediaPageButton extends StatefulWidget {
  final dynamic item;
  final String type;

  const MediaPageButton({Key? key, required this.item, required this.type})
      : super(key: key);

  @override
  State<MediaPageButton> createState() => _MediaPageButtonState();
}

class _MediaPageButtonState extends State<MediaPageButton> {
  List<NoteBookNoteSuperEntity> notes = [];
  bool _notesLoaded = false;

  void loadBookNotes(int id) async {
    List<NoteBookNoteSuperEntity> notes =
        await serviceLocator<NoteBookNoteSuperDao>()
            .findNoteBookNoteByBookId(id);
    setState(() {
      this.notes = notes;
      _notesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*if (widget.type == "TV Show") {
      if (widget.item.status == Status.nothing) {
        return ElevatedButton(
          onPressed: () {
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
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.5,
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
                                      child: AddToCatalogForm(
                                          status: Status.nothing,
                                          startDate: DateTime.now()
                                              .toString()
                                              .split(" ")[0],
                                          endDate: 'Not Defined'))),
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
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context).save,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                      )))
                            ])));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
            backgroundColor: leisureColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(AppLocalizations.of(context).add,
              style: Theme.of(context).textTheme.headlineSmall),
        );
      } else if (widget.item.status == Status.goingThrough || widget.item.status == Status.planTo) {
        // If media is somehow in the catalog, then user should be able to see their notes and edit info.
        return Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
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
                          initialChildSize: 0.35,
                          minChildSize: 0.35,
                          maxChildSize: 0.5,
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
                                            child: MarkEpisodesSheet(
                                                episodes: episodes))),
                                  ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).progress,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.35,
                          minChildSize: 0.35,
                          maxChildSize: 0.5,
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
                                            child: EpisodesNotesSheet(
                                                notes: notes,
                                                episodes: episodes)))
                                  ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).notes,
                    style: Theme.of(context).textTheme.headlineSmall),
              )
            ],
          ),
        );
      } else if (widget.item.status == Status.done) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.35,
                          minChildSize: 0.35,
                          maxChildSize: 0.5,
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
                                            child: EpisodesNotesSheet(
                                                notes: notes,
                                                review: const {
                                                  Reaction.dislike:
                                                      "Didn't like it at all."
                                                },
                                                episodes: episodes)))
                                  ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.90, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).notes,
                    style: Theme.of(context).textTheme.headlineSmall),
              )
            ],
          ),
        );
      }
    } */
    if (widget.type == "Book") {
      if (widget.item.status == Status.nothing) {
        // If the media is not in the catalog, show a button to add it.
        return ElevatedButton(
          onPressed: ()  {
            loadBookNotes(widget.item.id);
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Color(0xFF22252D),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                builder: (context) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.5,
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
                                      child: AddToCatalogForm(
                                          status: Status.nothing,
                                          startDate: DateTime.now()
                                              .toString()
                                              .split(" ")[0],
                                          endDate: 'Not Defined'))),
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
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context).save,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                      )))
                            ])));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
            backgroundColor: leisureColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(AppLocalizations.of(context).add,
              style: Theme.of(context).textTheme.headlineSmall),
        );
      } else if (widget.item.status == Status.goingThrough ||
          widget.item.status == Status.planTo) {
        // If media is somehow in the catalog, then user should be able to see their notes and edit info.
        return Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: ()  {
                  loadBookNotes(widget.item.id);
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Stack(children: const [
                            AddBookNoteForm(),
                          ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).progress,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              ElevatedButton(
                onPressed: () {
                  loadBookNotes(widget.item.id);
                  if (_notesLoaded) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Color(0xFF22252D),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.0)),
                        ),
                        builder: (context) => DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.35,
                            minChildSize: 0.35,
                            maxChildSize: 0.5,
                            builder: (context, scrollController) => Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom +
                                                  50),
                                          child: SingleChildScrollView(
                                              controller: scrollController,
                                              child:
                                                  BookNotesSheet(notes: notes)))
                                    ])));
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.45, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).notes,
                    style: Theme.of(context).textTheme.headlineSmall),
              )
            ],
          ),
        );
      } else if (widget.item.status == Status.done) {
        // If media is somehow in the catalog, then user should be able to see their notes and edit info.
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  loadBookNotes(widget.item.id);
                  if (_notesLoaded) {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Color(0xFF22252D),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.0)),
                        ),
                        builder: (context) => DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.35,
                            minChildSize: 0.35,
                            maxChildSize: 0.5,
                            builder: (context, scrollController) => Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom +
                                                  50),
                                          child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: BookNotesSheet(
                                                  notes: notes,
                                                  review: const {
                                                    Reaction.dislike:
                                                        "Hated it."
                                                  })))
                                    ])));
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.90, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).notes,
                    style: Theme.of(context).textTheme.headlineSmall),
              )
            ],
          ),
        );
      }
    } /* else if (widget.type == "Movie") {
      if (widget.item.status == Status.nothing) {
        return ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Color(0xFF22252D),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                builder: (context) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.5,
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
                                      child: AddToCatalogForm(
                                          status: Status.nothing,
                                          startDate: DateTime.now()
                                              .toString()
                                              .split(" ")[0],
                                          endDate: 'Not Defined'))),
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
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context).save,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                      )))
                            ])));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
            backgroundColor: leisureColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text(AppLocalizations.of(context).add,
              style: Theme.of(context).textTheme.headlineSmall),
        );
      } else if (widget.item.status == Status.planTo) {
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Color(0xFF22252D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.0)),
                          ),
                          builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Stack(children: const [
                                FinishedMediaForm(
                                    isFavorite: false,
                                    startDate: "04/09/2023",
                                    endDate: "04/09/2023",
                                    rating: Reaction.hate),
                              ])));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.90, 55),
                      backgroundColor: leisureColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context).review,
                        style: Theme.of(context).textTheme.headlineSmall),
                  )
                ]));
      } else if (widget.item.status == Status.done) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.35,
                          minChildSize: 0.35,
                          maxChildSize: 0.5,
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
                                            child: BookNotesSheet(
                                                notes: const {},
                                                review: const {
                                                  Reaction.dislike: "Hated it."
                                                })))
                                  ])));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.90, 55),
                  backgroundColor: leisureColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).your_review,
                    style: Theme.of(context).textTheme.headlineSmall),
              )
            ],
          ),
        );
      }
    }*/

    return Container();
  }
}
