import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';

// Floor POV: Video is now just a table with a foreign key to Media
@Entity(
  tableName: 'video',
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
class Video {
  @PrimaryKey()
  final int id;

  final int duration;

  @ColumnInfo(name: 'tmdb_id')
  final int tmdbId;

  Video({
    required this.id,
    required this.duration,
    required this.tmdbId,
  });
}
