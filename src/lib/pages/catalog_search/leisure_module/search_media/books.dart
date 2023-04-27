import 'package:flutter/material.dart';
import 'package:src/api_wrappers/google_books_api_wrapper.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/pages/catalog_search/list_media_search/list_book_search.dart';

class Books extends StatelessWidget {
  final String search;

  const Books({Key? key, required this.search}) : super(key: key);

  Future<List<MediaBookSuperEntity>> loadMedia() async {
    GoogleBooksAPIWrapper googleBooksAPIWrapper = GoogleBooksAPIWrapper();
    return search == ''
        ? googleBooksAPIWrapper.getBooks('batman', maxResults: 39)
        : googleBooksAPIWrapper.getBooks(search, maxResults: 39);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MediaBookSuperEntity>>(
      future: loadMedia(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListBookSearch(media: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
