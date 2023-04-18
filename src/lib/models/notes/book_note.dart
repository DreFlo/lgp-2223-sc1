import 'package:floor/floor.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/media/book.dart';

// Floor POV: BookNote is now just a table with a foreign key to Note (and Book, but that was here before)
@Entity(
  tableName: 'book_note',
  foreignKeys: [
    ForeignKey(
      childColumns: ['book_id'],
      parentColumns: ['id'],
      entity: Book,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Note,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
  ],
)
class BookNote {
  @PrimaryKey()
  final int id;

  @ColumnInfo(name: 'start_page')
  final int startPage;

  @ColumnInfo(name: 'end_page')
  final int endPage;

  @ColumnInfo(name: 'book_id')
  final int bookId;

  BookNote({
    required this.id,
    required this.startPage,
    required this.endPage,
    required this.bookId,
  });
}
