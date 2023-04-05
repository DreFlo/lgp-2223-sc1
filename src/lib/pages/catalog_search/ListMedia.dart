import 'package:flutter/material.dart';
import 'Media.dart';
import 'Book.dart';

class ListMedia extends StatelessWidget {
  final List media;
  final String title;

  const ListMedia({Key? key, required this.title, required this.media})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Expanded(
      child: Padding(
          padding: EdgeInsets.fromLTRB(40 * fem, 22 * fem, 0, 0),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10.0 * fem,
              runSpacing: 22.0 * fem,
              children: List.generate(media.length, (index) {
                return SizedBox(
                  width: 100.0 * fem,
                  height: 150.0 * fem,
                  child: showWidget(index),
                );
              }),
            ),
          )),
    );
  }
  showWidget(int index) {
    if (title == 'All Books') {
      if (media[index].info.imageLinks['thumbnail'] != null) {
        return Book(
            image: media[index].info.imageLinks['thumbnail'].toString());
      }
    } else {
      if(media[index]['poster_path'] != null){
        return Media(image: media[index]['poster_path']);
      }
    }
  }
}
