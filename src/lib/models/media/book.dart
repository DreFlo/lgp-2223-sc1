import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'book',
)
class Book extends Media {
  final String authors;

  @ColumnInfo(name: 'total_pages')
  final int totalPages;

  @ColumnInfo(name: 'progress_pages')
  final int? progressPages;

  Book({
    int? id,
    required String name,
    required String description,
    required String linkImage,
    required Status status,
    required bool favorite,
    required String genres,
    required DateTime release,
    required int xp,
    required this.authors,
    required this.totalPages,
    this.progressPages = 0,
  }) : super(
            id: id,
            name: name,
            description: description,
            linkImage: linkImage,
            status: status,
            favorite: favorite,
            genres: genres,
            release: release,
            xp: xp);
}
