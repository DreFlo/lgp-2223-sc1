import 'package:flutter/material.dart';
import 'package:src/models/media/media.dart';

abstract class MediaImageWidget<T extends Media> extends StatelessWidget {
  final String image;

  const MediaImageWidget({Key? key, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0), child: showImage()),
      ),
    );
  }

  Image showImage();
}
