// ignore_for_file: file_names,  sized_box_for_whitespace

import 'package:flutter/material.dart';

class MediaWidget extends StatelessWidget {
  final String image;
  final String type;

  const MediaWidget({Key? key, required this.image, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), child: showImage(type)),
      ),
    );
  }

  showImage(String type) {
    if (type == 'video') {
      return Image.network(
        'https://image.tmdb.org/t/p/w500$image',
        fit: BoxFit.cover,
      );
    } else if (type == 'book') {
      return Image.network(
        image,
        fit: BoxFit.cover,
      );
    }
  }
}
