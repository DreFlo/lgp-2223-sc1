import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/media/media.dart';

@Entity(
  tableName: 'media_timeslot',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Timeslot,
    ),
    ForeignKey(
        childColumns: ['media_id'],
        parentColumns: ['id'],
        entity: Media,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict)
  ],
)
class MediaTimeslot {
  @PrimaryKey()
  final int id;

  // TODO(TIMESLOT): several medias
  @ColumnInfo(name: 'media_id')
  final int mediaId;

  MediaTimeslot({
    required this.id,
    required this.mediaId,
  });
}
