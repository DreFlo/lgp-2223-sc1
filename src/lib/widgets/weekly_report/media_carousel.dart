import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/leisure/media_image_widgets/book_image.dart';
import 'package:src/widgets/leisure/media_image_widgets/movie_image.dart';
import 'package:src/widgets/leisure/media_image_widgets/tv_series_image.dart';

class MediaCarousel extends StatelessWidget {
  final List<Media> topMedia;

  const MediaCarousel({Key? key, required this.topMedia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        padEnds: false,
        viewportFraction: 0.9,
        enableInfiniteScroll: false,
        scrollDirection: Axis.vertical,
      ),
      items: topMedia.map((media) {
        Widget mediaImage;

        if (media.type == MediaDBTypes.book) {
          mediaImage = BookImageWidget(image: media.linkImage);
        } else if (media.type == MediaDBTypes.movie) {
          mediaImage = MovieImageWidget(image: media.linkImage);
        } else if (media.type == MediaDBTypes.series) {
          mediaImage = TVSeriesImageWidget(image: media.linkImage);
        } else {
          return Container();
        }

        return SizedBox(
          width: 150,
          height: 250,
          child: mediaImage,
        );
      }).toList(),
    );
  }
}
