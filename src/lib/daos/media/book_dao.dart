import 'package:floor/floor.dart';
import 'package:src/models/media/book.dart';

@dao
abstract class BookDao {
  @Query('SELECT * FROM book')
  Future<List<Book>> findAllBooks();

  @Query('SELECT * FROM book WHERE id = :id')
  Stream<Book?> findBookById(int id);

  @insert
  Future<void> insertBook(Book book);

  @insert
  Future<void> insertBooks(List<Book> books);
}
