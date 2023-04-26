// ignore_for_file: avoid_dynamic_calls
import 'package:flutter/material.dart';
import 'package:src/env/env.dart';
import 'package:src/models/media/media.dart';
import 'package:src/pages/leisure/finished_media_form.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/leisure/add_media_to_catalog_forms/add_media_to_catalog_form.dart';
import 'package:src/pages/leisure/mark_episodes_sheet.dart';
import 'package:src/pages/leisure/episodes_notes_sheet.dart';
import 'package:src/pages/leisure/book_notes_sheet.dart';
import 'package:src/pages/leisure/add_book_note_form.dart';
import 'package:src/utils/enums.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/utils/service_locator.dart';

abstract class MediaPageButton<T extends Media> extends StatefulWidget {
  final T item;
  final int mediaId;

  const MediaPageButton({
    Key? key,
    required this.item,
    required this.mediaId,
  }) : super(key: key);

  @override
  State<MediaPageButton> createState();
}

class MediaPageButtonState<T extends Media> extends State<MediaPageButton<T>> {
  Status status = Status.nothing;
  bool isStatusLoaded = false;
  int dbMediaId = 0;

  @override
  initState() {
    setMediaId(widget.mediaId);
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {
    final mediaStatus =
        await serviceLocator<MediaDao>().findMediaStatusById(dbMediaId);
    setState(() {
      status = mediaStatus ?? Status.nothing;
      isStatusLoaded = true;
    });
  }

  void setMediaId(int mediaId) {
    setState(() {
      dbMediaId = mediaId;
    });
  }

  Future<void> refreshStatus() async {
    isStatusLoaded = false;
    loadStatus();
    setState(() {});
  }

  Future showReviewForm() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF22252D),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.35,
            maxChildSize: 0.75,
            builder: (context, scrollController) =>
                Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                  Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 50),
                      child: SingleChildScrollView(
                          controller: scrollController,
                          child: FinishedMediaForm(
                              rating: Reaction.neutral,
                              startDate:
                                  DateTime.now().toString().split(" ")[0],
                              endDate: DateTime.now().toString().split(" ")[0],
                              isFavorite: false,
                              mediaId: dbMediaId,
                              refreshStatus: () {
                                refreshStatus();
                                Navigator.pop(context);
                              })))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    if (!isStatusLoaded) {
      // Show a loading indicator while the status is being loaded.
      return const CircularProgressIndicator();
    }
    return Container();
  }
}
