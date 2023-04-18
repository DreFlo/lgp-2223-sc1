// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';

class ListMediaCatalog extends StatelessWidget {
  final List media;
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

    // Filter out null images
    List filteredMedia =
        media.where((item) => showWidget(item, title) != null).toList();

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
                    if (title == 'All TV Shows') {
                      showMediaPageForTV(filteredMedia[index], context);
                    } else if (title == 'All Movies') {
                      showMediaPageForMovies(filteredMedia[index], context);
                    } else if (title == 'All Books') {
                      showMediaPageForBooks(filteredMedia[index], context);
                    }
                  },
                  child: SizedBox(
                    width: 100.0 * fem,
                    height: 150.0 * fem,
                    child: showWidget(filteredMedia[index], title),
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
