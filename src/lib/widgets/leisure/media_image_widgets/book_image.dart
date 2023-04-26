import 'package:flutter/material.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';

class BookImageWidget extends MediaImageWidget<MediaBookSuperEntity> {
  const BookImageWidget({Key? key, required String image})
      : super(key: key, image: image);

  @override
  Image showImage() {
    return Image.network(
      image,
      fit: BoxFit.cover,
    );
  }
}
