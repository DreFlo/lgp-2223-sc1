import 'package:flutter/material.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';

class SearchResults extends StatelessWidget {
  final Map media;
  final VoidCallback? refreshMedia;

  const SearchResults({Key? key, required this.media, this.refreshMedia})
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
          children: [
            for (var entry in media.entries)
              ...List.generate(
                entry.value.length,
                (index) {
                  String type = entry.key;
                  String title = type == 'movies'
                      ? 'All Movies'
                      : type == 'series'
                          ? 'All TV Shows'
                          : 'All Books';

                  return SizedBox(
                    // Wrap GestureDetector widget with SizedBox
                    width: 100.0 * fem,
                    height: 150.0 * fem,
                    child: GestureDetector(
                      onTap: () {
                        if (type == 'series') {
                          showMediaPageForTV(
                              entry.value[index], context);
                        } else if (type == 'movies') {
                          showMediaPageForMovies(
                              entry.value[index], context);
                        } else if (type == 'books') {
                          showMediaPageForBooks(
                              entry.value[index], context);
                        }
                      },
                      child: SizedBox(
                        width: 100.0 * fem,
                        height: 150.0 * fem,
                        child: showWidget(entry.value[index], title),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
