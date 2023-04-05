import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';

@Entity(
  tableName: 'book',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Media,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
  ],
)
class Book {
  @PrimaryKey()
  final int id;

  final String authors;

  @ColumnInfo(name: 'total_pages')
  final int totalPages;

  @ColumnInfo(name: 'progress_pages')
  final int? progressPages;

  Book({
    required this.id,
    required this.authors,
    required this.totalPages,
    this.progressPages = 0,
  });
}
