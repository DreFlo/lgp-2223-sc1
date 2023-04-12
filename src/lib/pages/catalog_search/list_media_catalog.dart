// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'media.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/leisure/add_to_catalog_form.dart';
import 'package:src/pages/leisure/mark_episodes_sheet.dart';
import 'package:src/pages/leisure/episodes_notes_sheet.dart';
import 'package:src/pages/leisure/book_notes_sheet.dart';
import 'package:src/pages/leisure/add_book_note_form.dart';
import 'package:src/pages/leisure/media_page.dart';
import 'package:src/utils/enums.dart';

class ListMediaCatalog extends StatelessWidget {
  final List media;
  final String title;

  Map<String, String> notes = {
    'S04E03':
        "After Horde Prime takes Glimmer aboard his flagship, she loses her access to magic again in Season 5. This time her combat skills don't cut it against the much stronger antagonists of Horde Prime's clone army- Catra has to save her multiple times. Only until she returns to Etheria's surface does she get her powers back, though she does manage to cast spells on Krytis.",
    'S02E07': 'Bow is best boy.'
  };

  ListMediaCatalog({Key? key, required this.title, required this.media})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    // Filter out null images
    List filteredMedia =
        media.where((item) => showWidget(item) != null).toList();

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
                            minChildSize: 0.35,
                            maxChildSize: 0.75,
                            builder: (context, scrollController) => Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      SingleChildScrollView(
                                          controller: scrollController,
                                          child: showMediaPageBasedOnType(
                                              filteredMedia[index])),
                                      /*Positioned(
                                        left: 16,
                                        right: 16,
                                        bottom: 16,
                                        child: mediaPageButton())*/
                                    ])));
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

  showWidget(dynamic item) {
    if (item.linkImage != null) {
      if (title == 'All Books') {
        return Media(image: item.linkImage, type: 'book');
      } else {
        return Media(image: item.linkImage, type: 'video');
      }
    }
  }

  showMediaPageBasedOnType(dynamic item) {
    List<String> leisureTags = [];

    leisureTags.add(item.release.year.toString());
    leisureTags.addAll(item.genres.split(','));

    List<String> cast = [];
    cast.addAll(item.participants.split(', '));

    if (title == 'All Books') {
      return MediaPage(
        title: item.name,
        synopsis: item.description,
        type: 'Book',
        length: [item.totalPages],
        cast: cast,
        image: item.linkImage,
        notes: notes, //get from DB
        status: item.status, //get from DB
        isFavorite: item.favorite, //get from DB
        leisureTags: leisureTags,
      );
    } else if (title == 'All Movies') {
      leisureTags.add(item.tagline);

      return MediaPage(
          title: item.name,
          synopsis: item.description,
          type: 'Movie',
          length: [item.duration],
          cast: cast,
          image: item.linkImage,
          notes: notes, //get from DB
          status: item.status, //get from DB
          isFavorite: item.favorite, //get from DB
          leisureTags: leisureTags,
      );
    } else if (title == 'All TV Shows') {
      leisureTags.add(item.tagline);
      
      return MediaPage(
          title: item.name,
          synopsis: item.description,
          type: 'TV Show',
          length: const [1,8,30], //get from DB
          cast: cast,
          image: item.linkImage,
          notes: notes, //get from DB
          status: item.status, //get from DB
          isFavorite: item.favorite, //get from DB
          leisureTags: leisureTags,
          );
    }
  }
}
