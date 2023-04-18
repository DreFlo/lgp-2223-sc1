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
import 'package:src/utils/enums.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/utils/service_locator.dart';

class MediaPageButton extends StatefulWidget {
  final dynamic item;
  final String type;
  final int mediaId;

  const MediaPageButton(
      {Key? key,
      required this.item,
      required this.type,
      required this.mediaId,})
      : super(key: key);

  @override
  State<MediaPageButton> createState() => _MediaPageButtonState();
}

class _MediaPageButtonState extends State<MediaPageButton> {
  Status status = Status.nothing;
  bool isStatusLoaded = false;

  @override
  initState() {
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {
    final mediaStatus =
        await serviceLocator<MediaDao>().findMediaStatusById(widget.mediaId);
    setState(() {
      status = mediaStatus!;
      isStatusLoaded = true;
    });
  }

  Future<void> refreshStatus() async {
    isStatusLoaded = false;
    loadStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(!isStatusLoaded) {
      // Show a loading indicator while the status is being loaded.
      return CircularProgressIndicator();
    }
    if (widget.type == "TV Show") {
      if (status == Status.nothing) {
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
      } else if (status == Status.goingThrough || status == Status.planTo) {
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
                                              mediaId: widget.mediaId,
                                            ))),
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
                                              mediaId: widget.mediaId,
                                            )))
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
      } else if (status == Status.done) {
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
                                              mediaId: widget.mediaId,
                                            )))
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
    } else if (widget.type == "Book") {
      if (status == Status.nothing) {
        // If the media is not in the catalog, show a button to add it.
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
      } else if (status == Status.goingThrough || status == Status.planTo) {
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
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Stack(children: [
                            AddBookNoteForm(
                                book: widget.item,
                                refreshStatus: () {
                                                  refreshStatus();
                                                  Navigator.pop(context);
                                                }),
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
                                            child: BookNotesSheet(
                                                book: true,
                                                mediaId: widget.mediaId)))
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
      } else if (status == Status.done) {
        // If media is somehow in the catalog, then user should be able to see their notes and edit info.
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
                                                book: true,
                                                mediaId: widget.mediaId)))
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
    } else if (widget.type == "Movie") {
      if (status == Status.nothing) {
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
      } else if (status == Status.planTo) {
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
                          builder: (context) => DraggableScrollableSheet(
                              expand: false,
                              minChildSize: 0.35,
                              maxChildSize: 0.75,
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
                                                child: FinishedMediaForm(
                                                  rating: Reaction.neutral,
                                                  startDate: DateTime.now()
                                                      .toString()
                                                      .split(" ")[0],
                                                  endDate: DateTime.now()
                                                      .toString()
                                                      .split(" ")[0],
                                                  isFavorite: false,
                                                  mediaId: widget.mediaId,
                                                   refreshStatus: () {
                                                    refreshStatus();
                                                    Navigator.pop(context);
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
                    child: Text(AppLocalizations.of(context).review,
                        style: Theme.of(context).textTheme.headlineSmall),
                  )
                ]));
      } else if (status == Status.done) {
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
                                                book: false,
                                                mediaId: widget.mediaId)))
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
    }

    return Container();
  }
}
