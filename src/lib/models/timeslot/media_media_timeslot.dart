import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/timeslot/media_timeslot.dart';

@Entity(
  tableName: 'media_media_timeslot',
  primaryKeys: ['media_id', 'media_timeslot_id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['media_id'],
      parentColumns: ['id'],
      entity: Media,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
    ForeignKey(
      childColumns: ['media_timeslot_id'],
      parentColumns: ['id'],
      entity: MediaTimeslot,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    )
  ],
)
class MediaMediaTimeslot {
  @ColumnInfo(name: 'media_id')
  final int mediaId;

  @ColumnInfo(name: 'media_timeslot_id')
  final int mediaTimeslotId;

  MediaMediaTimeslot({
    required this.mediaId,
    required this.mediaTimeslotId,
  });
}
