// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:src/models/media/media.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/media/review.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/leisure/media_pages/media_page.dart';
import 'package:src/utils/enums.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/widgets/leisure/media_page_buttons/media_page_button.dart';

class MediaStatus {
  final Status status;
  final bool favorite;
  final int id;

  MediaStatus({
    required this.status,
    required this.favorite,
    required this.id,
  });
}

abstract class ListMediaSearch<T extends Media> extends StatefulWidget {
  final List<T> media;

  const ListMediaSearch({Key? key, required this.media})
      : super(key: key);

  @override
  ListMediaSearchState<T> createState();
}

abstract class ListMediaSearchState<T extends Media>
    extends State<ListMediaSearch<T>> {
  MediaStatus statusFavorite =
      MediaStatus(status: Status.nothing, favorite: false, id: 0);
  bool _isFavorite = false;
  Review? review;

  void toggleFavorite(bool value) {
    setState(() {
      _isFavorite = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    // Filter out null images
    List filteredMedia =
        widget.media.where((item) => showWidget(item) != null).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(40 * fem, 22 * fem, 0, 0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10.0 * fem,
          runSpacing: 22.0 * fem,
          children: List.generate(filteredMedia.length, (index) {
            return SizedBox(
                // Wrap GestureDetector widget with SizedBox
                width: 100.0 * fem,
                height: 150.0 * fem,
                child: GestureDetector(
                  onTap: () {
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
                              initialChildSize: 0.75,
                              minChildSize: 0.35,
                              maxChildSize: 0.9,
                              builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    SingleChildScrollView(
                                        controller: scrollController,
                                        child:
                                            showMediaPageBasedOnType(//pass it
                                                filteredMedia[index])),
                                    Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: FutureBuilder<dynamic>(
                                            future: getStatusFromDB(
                                                filteredMedia[index]),
                                            builder: ((context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              return showMediaPageButton(
                                                  filteredMedia[index],
                                                  context);
                                            })))
                                  ]),
                            )).whenComplete(() {
                      if (_isFavorite != statusFavorite.favorite) {
                        saveFavoriteStatus(_isFavorite, statusFavorite.id);
                      }
                    });
                  },
                  child: SizedBox(
                    width: 100.0 * fem,
                    height: 150.0 * fem,
                    child: showWidget(filteredMedia[index]),
                  ),
                ));
          }),
        ),
      ),
    );
  }

  Future<MediaStatus> getStatusFromDB(T item);

  showMediaPageButton(dynamic item, context) {
    if (widget.title == 'All Books') {
      return MediaPageButton(
          item: item, type: 'Book', mediaId: statusFavorite.id);
    } else if (widget.title == 'All Movies') {
      return MediaPageButton(
          item: item, type: 'Movie', mediaId: statusFavorite.id);
    } else {
      return MediaPageButton(
          item: item, type: 'TV Show', mediaId: statusFavorite.id);
    }
  }

  MediaPage<T> showMediaPageBasedOnType(T item);

  MediaImageWidget<T> showWidget(T item);
}
