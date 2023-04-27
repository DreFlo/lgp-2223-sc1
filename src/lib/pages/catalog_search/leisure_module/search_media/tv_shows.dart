import 'package:flutter/material.dart';
import 'package:src/api_wrappers/tmdb_api_tv_wrapper.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/pages/catalog_search/list_media_search/list_tv_series_search.dart';

class TVShows extends StatelessWidget {
  final String search;

  const TVShows({Key? key, required this.search}) : super(key: key);

  Future<List<MediaSeriesSuperEntity>> loadMedia() async {
    final TMDBTVSeriesAPIWrapper tmdb = TMDBTVSeriesAPIWrapper();
    return search == ''
        ? tmdb.getTrendingTVSeries()
        : tmdb.getTVSeriesBySearch(search);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MediaSeriesSuperEntity>>(
      future: loadMedia(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListTVSeriesSearch(media: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
