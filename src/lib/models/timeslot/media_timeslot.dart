import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'media_timeslot',
)
class MediaTimeslot extends Timeslot {
  @ForeignKey(entity: Media, childColumns: ['media_id'], parentColumns: ['id'])
  @ColumnInfo(name: 'media')
  final int mediaId;

  MediaTimeslot(
      {int? id,
      required String title,
      required String description,
      required Periodicity periodicity,
      required DateTime startDateTime,
      required DateTime endDateTime,
      required Priority priority,
      required int xp,
      required int userId,
      required this.mediaId})
      : super(
            id: id,
            title: title,
            description: description,
            periodicity: periodicity,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            priority: priority,
            xp: xp,
            userId: userId);
}
