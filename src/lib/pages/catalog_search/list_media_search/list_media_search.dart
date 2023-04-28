import 'package:flutter/material.dart';
import 'package:src/daos/media/media_video_movie_super_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';
import 'package:src/models/media/review.dart';
import 'package:src/pages/leisure/media_pages/media_page.dart';
import 'package:src/utils/enums.dart';
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

  const ListMediaSearch({Key? key, required this.media}) : super(key: key);

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

  List<String> getLeisureTags(T item) {
    List<String> leisureTags = [];
    leisureTags.add(item.release.year.toString());
    leisureTags.addAll(item.genres.split(','));

    //if (T is MediaVideoMovieSuperEntity || T is MediaSeriesSuperEntity) {
    //leisureTags.add(item.tagline);
    //}
    return leisureTags;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Padding(
      padding: EdgeInsets.fromLTRB(40 * fem, 22 * fem, 0, 0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10.0 * fem,
          runSpacing: 22.0 * fem,
          children: List.generate(widget.media.length, (index) {
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
                                        child: showMediaPageBasedOnType(
                                            //pass it
                                            widget.media[index],
                                            getLeisureTags(
                                                widget.media[index]))),
                                    Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: FutureBuilder<dynamic>(
                                            future: getMediaInfoFromDB(
                                                widget.media[index]),
                                            builder: ((context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              return showMediaPageButton(
                                                  widget.media[index]);
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
                    child: showWidget(widget.media[index]),
                  ),
                ));
          }),
        ),
      ),
    );
  }

  Future<MediaStatus> getMediaInfoFromDB(T item);

  MediaPageButton<T> showMediaPageButton(T item);

  MediaPage<T> showMediaPageBasedOnType(T item, List<String> leisureTags);

  MediaImageWidget<T> showWidget(T item);
}
