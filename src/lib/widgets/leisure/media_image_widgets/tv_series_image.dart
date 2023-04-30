import 'package:flutter/material.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';

class TVSeriesImageWidget extends MediaImageWidget<MediaSeriesSuperEntity> {
  const TVSeriesImageWidget({Key? key, required String image})
      : super(key: key, image: image);

  @override
  Image showImage() {
    return Image.network(
      'https://image.tmdb.org/t/p/w500$image',
      fit: BoxFit.cover,
    );
  }
}
