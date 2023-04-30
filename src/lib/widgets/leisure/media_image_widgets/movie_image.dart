import 'package:flutter/material.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';

class MovieImageWidget extends MediaImageWidget<MediaVideoMovieSuperEntity> {
  const MovieImageWidget({Key? key, required String image})
      : super(key: key, image: image);

  @override
  Image showImage() {
    return Image.network(
      'https://image.tmdb.org/t/p/w500$image',
      fit: BoxFit.cover,
    );
  }
}
