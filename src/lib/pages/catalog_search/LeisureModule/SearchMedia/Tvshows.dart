import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:src/pages/catalog_search/ListMedia.dart';

class Tvshows extends StatelessWidget {
  final String search;

  const Tvshows({Key? key, required this.search}) : super(key: key);

  Future<List> loadmedia() async {
    final tmdb = TMDB(
        ApiKeys('api key', 'apiReadAccessTokenv4'));
    Map tvresult;
      if (search == '') {
        tvresult = tvresult =
            await tmdb.v3.trending.getTrending(mediaType: MediaType.tv);
      } else {
        tvresult = await tmdb.v3.search.queryTvShows(search);
      }
    return tvresult['results'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: loadmedia(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListMedia(title: 'All Tv shows', media: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}