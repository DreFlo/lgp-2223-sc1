import 'package:flutter/material.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/pages/leisure/add_media_to_catalog_forms/add_media_to_catalog_form.dart';
import 'package:src/pages/leisure/episodes_notes_sheet.dart';
import 'package:src/pages/leisure/mark_episodes_sheet.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/leisure/media_page_buttons/media_page_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TVSeriesButton extends MediaPageButton<MediaSeriesSuperEntity> {
  const TVSeriesButton(
      {Key? key,
      required MediaSeriesSuperEntity item,
      required int mediaId})
      : super(key: key, item: item, mediaId: mediaId);

  @override
  TVSeriesButtonState createState() => TVSeriesButtonState();
}

class TVSeriesButtonState extends MediaPageButtonState<MediaSeriesSuperEntity> {
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
                  initialChildSize: 0.5,
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
                                      type: "TV Show",
                                      showReviewForm: showReviewForm,
                                      setMediaId: setMediaId,
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
                    builder: (context) => DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.5,
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
                                          child: MarkEpisodesSheet(
                                            mediaId: dbMediaId,
                                          ))),
                                ])));
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
                        initialChildSize: 0.5,
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
                                          child: EpisodesNotesSheet(
                                            mediaId: dbMediaId,
                                          )))
                                ])));
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
                    builder: (context) => DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.5,
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
                                          child: EpisodesNotesSheet(
                                            mediaId: dbMediaId,
                                          )))
                                ])));
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
