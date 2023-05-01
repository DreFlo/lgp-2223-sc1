import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/widgets/leisure/book_note_bar.dart';
import 'package:src/widgets/leisure/review_note_bar.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/models/media/review.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';

class BookNotesSheet extends StatefulWidget {
  final int mediaId;
  final bool book;

  const BookNotesSheet({Key? key, required this.book, required this.mediaId})
      : super(key: key);

  @override
  State<BookNotesSheet> createState() => _BookNotesSheetState();
}

class _BookNotesSheetState extends State<BookNotesSheet>
    with TickerProviderStateMixin {
  List<NoteBookNoteSuperEntity?>? bookNotes;
  Review? review;
  @override
  void initState() {
    super.initState();
    if (widget.book) {
      fetchNotes();
    }
    fetchReview();
  }

  void fetchNotes() async {
    bookNotes = await loadBookNotes(widget.mediaId);
    setState(() {
      bookNotes = bookNotes;
    });
  }

  void fetchReview() async {
    review = await loadReviews(widget.mediaId);
    setState(() {
      review = review;
    });
  }

  List<Widget> getNotes() {
    List<Widget> notes = [];

    if (review != null) {
      notes.add(ReviewNoteBar(
        reaction: review!.emoji,
        text: review!.review,
      ));

      notes.add(const SizedBox(height: 15));
    }

    if (bookNotes != null) {
      for (var range in bookNotes!) {
        notes.add(Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: Row(children: [BookNoteBar(
          startPage: range!.startPage,
          endPage: range.endPage,
          text: range.content,
        )])));

        notes.add(const SizedBox(height: 15));
      }
    }

    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
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
      const SizedBox(height: 12.5),
      Row(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              AppLocalizations.of(context).notes,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      ...getNotes(),
      const SizedBox(height: 50)
    ]);
  }
}
