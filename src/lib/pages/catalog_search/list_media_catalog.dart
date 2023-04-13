// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/leisure/add_to_catalog_form.dart';
import 'package:src/pages/leisure/mark_episodes_sheet.dart';
import 'package:src/pages/leisure/episodes_notes_sheet.dart';
import 'package:src/pages/leisure/book_notes_sheet.dart';
import 'package:src/pages/leisure/add_book_note_form.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';

class ListMediaCatalog extends StatelessWidget {
  final List media;
  final String title;

  const ListMediaCatalog({Key? key, required this.title, required this.media})
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
                                              filteredMedia[index], title)),
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
                    child: showWidget(filteredMedia[index], title),
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
