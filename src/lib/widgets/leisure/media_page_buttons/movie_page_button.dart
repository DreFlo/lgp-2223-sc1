import 'package:flutter/material.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/pages/leisure/add_media_to_catalog_forms/add_media_to_catalog_form.dart';
import 'package:src/pages/leisure/book_notes_sheet.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/leisure/media_page_buttons/media_page_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoviePageButton extends MediaPageButton<MediaVideoMovieSuperEntity> {
  const MoviePageButton(
      {Key? key,
      required MediaVideoMovieSuperEntity item,
      required int mediaId})
      : super(key: key, item: item, mediaId: mediaId);

  @override
  MoviePageButtonState createState() => MoviePageButtonState();
}

class MoviePageButtonState
    extends MediaPageButtonState<MediaVideoMovieSuperEntity> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (status == Status.nothing) {
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
                                    child: AddToCatalogForm(
                                      status: Status.nothing,
                                      startDate: DateTime.now()
                                          .toString()
                                          .split(" ")[0],
                                      endDate: DateTime.now()
                                          .toString()
                                          .split(" ")[0],
                                      item: widget.item,
                                      type: 'Movie',
                                      setMediaId: setMediaId,
                                      showReviewForm: showReviewForm,
                                      refreshStatus: () {
                                        refreshStatus();
                                        Navigator.pop(context);
                                      },
                                    ))),
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
    } else if (status == Status.planTo || status == Status.dropped) {
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
              onPressed: () {
                showReviewForm();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.90, 55),
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
                        initialChildSize: 0.35,
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
                                          // TODO: Why BookNotesSheet?
                                          child: BookNotesSheet(
                                              book: false, mediaId: dbMediaId)))
                                ])));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.90, 55),
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

    return Container();
  }
}
