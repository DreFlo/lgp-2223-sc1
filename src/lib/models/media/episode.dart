import 'package:floor/floor.dart';
import 'package:src/models/media/video.dart';
import 'package:src/models/media/season.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'episode',
  foreignKeys: [
    ForeignKey(
        childColumns: ['season_id'],
        parentColumns: ['id'],
        entity: Season,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict)
  ],
)
class Episode extends Video {
  final int number;

  @ColumnInfo(name: 'season_id')
  final int seasonId;

  Episode({
    int? id,
    required String name,
    required String description,
    required String linkImage,
    required Status status,
    required bool favorite,
    required String genres,
    required DateTime release,
    required int xp,
    required int duration,
    required this.number,
    required this.seasonId,
  }) : super(
            id: id,
            name: name,
            description: description,
            linkImage: linkImage,
            status: status,
            favorite: favorite,
            genres: genres,
            release: release,
            xp: xp,
            duration: duration);
}
