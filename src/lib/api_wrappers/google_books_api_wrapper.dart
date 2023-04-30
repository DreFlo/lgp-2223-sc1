import 'package:books_finder/books_finder.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/utils/enums.dart';

class GoogleBooksAPIWrapper {
  Future<List<MediaBookSuperEntity>> getBooks(String query,
      {int maxResults = 40}) async {
    final bookResults = (await queryBooks(query,
            maxResults: 40,
            printType: PrintType.books,
            orderBy: OrderBy.relevance))
        .where((book) => book.info.imageLinks['thumbnail'] != null)
        .toList();

    List<MediaBookSuperEntity> books =
        List.generate(bookResults.length, (index) {
      Book book = bookResults[index];

      MediaBookSuperEntity bookEntity = MediaBookSuperEntity(
        name: book.info.title,
        description: book.info.description,
        linkImage: book.info.imageLinks['thumbnail'].toString(),
        status: Status.nothing,
        favorite: false,
        genres: book.info.categories.join(', '),
        release: book.info.publishedDate!,
        xp: 0,
        participants: book.info.authors.join(', '),
        totalPages: book.info.pageCount,
      );

      return bookEntity;
    });

    return books;
  }
}
