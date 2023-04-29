import 'package:flutter/material.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/pages/leisure/media_pages/media_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoviePage extends MediaPage<MediaVideoMovieSuperEntity> {
  const MoviePage(
      {Key? key,
      required MediaVideoMovieSuperEntity media,
      required Function(bool) toggleFavorite})
      : super(
          key: key,
          item: media,
          toggleFavorite: toggleFavorite,
        );

  @override
  MoviePageState createState() => MoviePageState();
}

class MoviePageState extends MediaPageState<MediaVideoMovieSuperEntity> {
  @override
  void initState() {
    super.initState();
    super.isFavorite = widget.item.favorite;
  }

  @override
  String getLength(context) {
    return widget.item.duration.toString() +
        AppLocalizations.of(context).minutes;
  }

  @override
  List<String> getLeisureTags() {
    List<String> leisureTags = [];
    if (widget.item.tagline != '') {
      leisureTags.add(widget.item.tagline);
    }
    leisureTags.addAll(widget.item.genres.split(','));
    leisureTags.add(widget.item.release.year.toString());
    return leisureTags;
  }

  @override
  String getType() {
    return 'Movie';
  }

  @override
  Image showImage() {
    if (widget.item.linkImage != '') {
      return Image.network(
        'https://image.tmdb.org/t/p/w500${widget.item.linkImage}',
        fit: BoxFit.fitWidth,
      );
    } else {
      return Image.asset("assets/images/no_image.jpg");
    }
  }
}
