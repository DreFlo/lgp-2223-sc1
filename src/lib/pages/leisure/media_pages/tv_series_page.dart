import 'package:flutter/material.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/pages/leisure/media_pages/media_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TVSeriesPage extends MediaPage<MediaSeriesSuperEntity> {
  const TVSeriesPage(
      {Key? key,
      required MediaSeriesSuperEntity media,
      required Function(bool) toggleFavorite,
      required List<String> leisureTags})
      : super(
            key: key,
            item: media,
            toggleFavorite: toggleFavorite,
            leisureTags: leisureTags);

  @override
  TVSeriesPageState createState() => TVSeriesPageState();
}

class TVSeriesPageState extends MediaPageState<MediaSeriesSuperEntity> {
  @override
  String getType() {
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
    String duration = widget.item.duration.toString();
    String seasons = widget.item.numberSeasons.toString();
    if (seasons == '1') {
      seasons = seasons + AppLocalizations.of(context).season;
    } else {
      seasons = seasons + AppLocalizations.of(context).seasons;
    }
    String seasonsEpisodes = seasons + widget.item.numberEpisodes.toString();
    if (duration == '0') {
      return seasonsEpisodes + AppLocalizations.of(context).episodes_no_duration; 
    } else {
      return seasonsEpisodes + AppLocalizations.of(context).episodes +
          duration +
          AppLocalizations.of(context).minutes_each;
    }
  }
}
