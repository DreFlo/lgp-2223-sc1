import 'package:floor/floor.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'media',
)
class Media {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String description;

  @ColumnInfo(name: 'link_image')
  final String linkImage;

  final Status status;

  final bool favorite;

  final String genres;

  final DateTime release;

  final int xp;

  Media({
    this.id,
    required this.name,
    required this.description,
    required this.linkImage,
    required this.status,
    required this.favorite,
    required this.genres,
    required this.release,
    required this.xp,
  });
}
