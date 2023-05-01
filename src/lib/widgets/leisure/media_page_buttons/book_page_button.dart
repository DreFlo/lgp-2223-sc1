import 'package:flutter/material.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/pages/leisure/add_book_note_form.dart';
import 'package:src/pages/leisure/add_media_to_catalog_forms/add_book_to_catalog_form.dart';
import 'package:src/pages/leisure/book_notes_sheet.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/leisure/media_page_buttons/media_page_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookPageButton extends MediaPageButton<MediaBookSuperEntity> {
  const BookPageButton(
      {Key? key, required MediaBookSuperEntity item, required int mediaId})
      : super(key: key, item: item, mediaId: mediaId);

  @override
  BookPageButtonState createState() => BookPageButtonState();
}

class BookPageButtonState extends MediaPageButtonState<MediaBookSuperEntity> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (status == Status.nothing) {
      // If the media is not in the catalog, show a button to add it.
      return ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: const Color(0xFF22252D),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              builder: (context) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.55,
                    minChildSize: 0.55,
                    maxChildSize: 0.55,
                    builder: (context, scrollController) => Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 3),
                        child: SingleChildScrollView(
                            controller: scrollController,
                            child: AddBookToCatalogForm(
                              status: Status.nothing,
                              startDate:
                                  DateTime.now().toString().split(" ")[0],
                              endDate: DateTime.now().toString().split(" ")[0],
                              item: widget.item,
                              setMediaId: setMediaId,
                              showReviewForm: showReviewForm,
                              refreshStatus: () {
                                Navigator.pop(context);
                              },
                            ))),
                  ));
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
    } else if (status == Status.goingThrough ||
        status == Status.planTo ||
        status == Status.dropped) {
      // If media is somehow in the catalog, then user should be able to see their notes and edit info.
      return SizedBox(
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
                  builder: (context) => AddBookNoteForm(
                      book: widget.item,
                      refreshStatus: () {
                        Navigator.pop(context);
                      }),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.45, 55),
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
                    backgroundColor: const Color(0xFF22252D),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30.0)),
                    ),
                    builder: (context) => DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.55,
                        minChildSize: 0.55,
                        maxChildSize: 0.55,
                        builder: (context, scrollController) =>
                            SingleChildScrollView(
                                controller: scrollController,
                                child: BookNotesSheet(
                                    book: true, mediaId: dbMediaId))));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.45, 55),
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
      return SizedBox(
        width: MediaQuery.of(context).size.width,
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
                        initialChildSize: 0.55,
                        minChildSize: 0.55,
                        maxChildSize: 0.55,
                        builder: (context, scrollController) =>
                            SingleChildScrollView(
                                controller: scrollController,
                                child: BookNotesSheet(
                                    book: true, mediaId: dbMediaId))));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.90, 55),
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
    return Container();
  }
}
