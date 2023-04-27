import 'package:flutter/material.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';

class ListMediaCatalog extends StatelessWidget {
  final List<Media> media;
  final String title;
  final VoidCallback? refreshMediaList;

  const ListMediaCatalog(
      {Key? key,
      required this.title,
      required this.media,
      this.refreshMediaList})
      : super(key: key);

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
          children: List.generate(media.length, (index) {
            return SizedBox(
                // Wrap GestureDetector widget with SizedBox
                width: 100.0 * fem,
                height: 150.0 * fem,
                child: GestureDetector(
                  onTap: () {
                    if (title == 'All TV Shows') {
                      showMediaPageForTV(
                          media[index] as MediaSeriesSuperEntity, context, refreshMediaList);
                    } else if (title == 'All Movies') {
                      showMediaPageForMovies(
                          media[index] as MediaVideoMovieSuperEntity, context, refreshMediaList);
                    } else if (title == 'All Books') {
                      showMediaPageForBooks(
                          media[index] as MediaBookSuperEntity, context, refreshMediaList);
                    }
                  },
                  child: SizedBox(
                    width: 100.0 * fem,
                    height: 150.0 * fem,
                    child: showWidget(media[index]),
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
