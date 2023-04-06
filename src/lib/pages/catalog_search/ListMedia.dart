// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'Media.dart';

class ListMedia extends StatelessWidget {
  final List media;
  final String title;

  const ListMedia({Key? key, required this.title, required this.media})
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
              width: 100.0 * fem,
              height: 150.0 * fem,
              child: showWidget(filteredMedia[index]),
            );
          }),
        ),
      ),
    );
  }

  showWidget(dynamic item) {
    if (title == 'All Books') {
      if (item.info.imageLinks['thumbnail'] != null) {
        return Media(image: item.info.imageLinks['thumbnail'].toString(), type:'book');
      }
    } else {
      if (item['poster_path'] != null) {
        return Media(image: item['poster_path'], type:'video');
      }
    }
  }
}
