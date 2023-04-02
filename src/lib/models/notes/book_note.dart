import 'package:floor/floor.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/media/book.dart';

@Entity(
  tableName: 'book_note',
  foreignKeys: [
    ForeignKey(
      childColumns: ['book_id'],
      parentColumns: ['id'],
      entity: Book,
    )
  ],
)
class BookNote extends Note {
  @ColumnInfo(name: 'start_page')
  final int startPage;

  @ColumnInfo(name: 'end_page')
  final int endPage;

  @ColumnInfo(name: 'book_id')
  final int bookId;

  BookNote({
    int? id,
    required String title,
    required String content,
    required DateTime date,
    required this.startPage,
    required this.endPage,
    required this.bookId,
  }) : super(id: id, title: title, content: content, date: date);
}
