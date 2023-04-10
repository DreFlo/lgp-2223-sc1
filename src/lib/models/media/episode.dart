import 'package:floor/floor.dart';
import 'package:src/models/media/video.dart';
import 'package:src/models/media/season.dart';

@Entity(
  tableName: 'episode',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Video,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
    ForeignKey(
      childColumns: ['season_id'],
      parentColumns: ['id'],
      entity: Season,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
  ],
)
class Episode {
  @PrimaryKey()
  final int id;

  final int number;

  @ColumnInfo(name: 'season_id')
  final int seasonId;

  Episode({
    required this.id,
    required this.number,
    required this.seasonId,
  });
}
