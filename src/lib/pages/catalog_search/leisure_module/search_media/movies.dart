import 'package:flutter/material.dart';
import 'package:src/api_wrappers/tmdb_api_movies_wrapper.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/pages/catalog_search/list_media_search/list_movies_search.dart';

class Movies extends StatelessWidget {
  final String search;

  const Movies({Key? key, required this.search}) : super(key: key);

  Future<List<MediaVideoMovieSuperEntity>> loadMedia() async {
    final TMDBMovieAPIWrapper tmdb = TMDBMovieAPIWrapper();
    return search == ''
        ? tmdb.getTrendingMovies()
        : tmdb.getMoviesBySearch(search);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MediaVideoMovieSuperEntity>>(
      future: loadMedia(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListMoviesSearch(media: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
