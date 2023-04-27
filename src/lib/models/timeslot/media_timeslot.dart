import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';

@Entity(
  tableName: 'media_timeslot',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Timeslot,
    )
  ],
)
class MediaTimeslot {
  @PrimaryKey()
  final int id;

  final String type;

  MediaTimeslot({
    required this.id,
    required this.type
  });
}
