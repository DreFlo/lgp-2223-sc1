import 'package:flutter/material.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/pages/leisure/media_pages/media_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TVSeriesPage extends MediaPage<MediaSeriesSuperEntity> {
  const TVSeriesPage(
      {Key? key,
      required MediaSeriesSuperEntity media,
      required Function(bool) toggleFavorite,
      required List<String> leisureTags,
      required int maxDuration})
      : super(
            key: key,
            item: media,
            toggleFavorite: toggleFavorite,
            leisureTags: leisureTags,
            maxDuration: maxDuration);

  @override
  TVSeriesPageState createState() => TVSeriesPageState();
}

class TVSeriesPageState extends MediaPageState<MediaSeriesSuperEntity> {
  @override
  String getType() {
    // TODO: l10n
    return 'TV Series';
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

  @override
  String getLength(context) {
    // TODO: Get episode length
    // AppLocalizations.of(context).minutes_each
    return widget.item.numberSeasons.toString() +
        AppLocalizations.of(context).seasons +
        widget.item.numberEpisodes.toString() +
        AppLocalizations.of(context).episodes +
        widget.maxDuration.toString() +
        AppLocalizations.of(context).minutes_each;
  }
}
