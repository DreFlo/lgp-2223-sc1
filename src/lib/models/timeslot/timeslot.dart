import 'package:floor/floor.dart';
import 'package:src/models/user.dart';

@Entity(
  tableName: 'timeslot',
  foreignKeys: [
    ForeignKey(
        childColumns: ['user_id'],
        parentColumns: ['id'],
        entity: User,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict)
  ],
)
class Timeslot {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;

  final String description;

  final bool finished;

  @ColumnInfo(name: 'start_datetime')
  final DateTime startDateTime;

  @ColumnInfo(name: 'end_datetime')
  final DateTime endDateTime;

  @ColumnInfo(name: 'xp_multiplier')
  final int xpMultiplier;

  @ColumnInfo(name: 'user_id')
  final int userId;

  Timeslot(
      {this.id,
      required this.title,
      required this.description,
      required this.startDateTime,
      required this.endDateTime,
      required this.xpMultiplier,
      required this.finished,
      required this.userId});
}
