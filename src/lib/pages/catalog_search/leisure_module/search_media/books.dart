import 'package:flutter/material.dart';
import 'package:books_finder/books_finder.dart';
import 'package:src/pages/catalog_search/list_media_search/list_media_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Books extends StatelessWidget {
  final String search;

  const Books({Key? key, required this.search}) : super(key: key);

  Future<List> loadmedia() async {
    if (search == '') {
      return await queryBooks(
        'batman',
        maxResults:
            39, //max possible is 40 -> since we do 3 per row, I'm gonna ask the api for 39 items instead of 40
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
      );
    } else {
      return await queryBooks(search,
          maxResults: 39,
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
          return ListMediaSearch(
              title: AppLocalizations.of(context).all_books,
              media: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
