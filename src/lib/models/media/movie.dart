import 'package:floor/floor.dart';
import 'package:src/models/media/video.dart';

@Entity(
  tableName: 'movie',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Video,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
  ],
)
class Movie {
  @PrimaryKey()
  final int id;

  final String tagline;

  Movie({
    required this.id,
    required this.tagline,
  });
}
