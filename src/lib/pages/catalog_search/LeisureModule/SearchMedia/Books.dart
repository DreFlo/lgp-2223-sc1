import 'package:flutter/material.dart';
import 'package:books_finder/books_finder.dart';
import 'package:src/pages/catalog_search/ListMedia.dart';

class Books extends StatelessWidget {
  final String search;

  const Books({Key? key, required this.search}) : super(key: key);

  Future<List> loadmedia() async {
    if (search == '') {
      return await queryBooks(
        'batman',
        maxResults: 40,
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
      );
    } else {
      return await queryBooks(search,
          maxResults: 40,
          printType: PrintType.books,
          orderBy: OrderBy.relevance);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: loadmedia(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListMedia(title: 'All Books', media: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
