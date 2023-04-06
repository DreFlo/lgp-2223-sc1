// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:src/pages/catalog_search/ListMedia.dart';
import 'package:src/env/env.dart';

class Movies extends StatelessWidget {
  final String search;

  const Movies({Key? key, required this.search}) : super(key: key);

  Future<List> loadmedia() async {
    final tmdb = TMDB(ApiKeys(Env.tmdbApiKey, 'apiReadAccessTokenv4'));
    Map movieresult;
    if (search == '') {
      movieresult =
          await tmdb.v3.trending.getTrending(mediaType: MediaType.movie);
    } else {
      movieresult = await tmdb.v3.search.queryMovies(search);
    }
    return movieresult['results'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: loadmedia(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListMedia(title: 'All Movies', media: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
