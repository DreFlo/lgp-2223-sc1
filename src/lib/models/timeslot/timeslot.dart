import 'package:floor/floor.dart';
import 'package:src/utils/enums.dart';
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

  final Periodicity periodicity;

  final DateTime startDateTime;

  final DateTime endDateTime;

  final Priority priority;

  final int xp;

  @ColumnInfo(name: 'user_id')
  final int userId;

  Timeslot(
      {this.id,
      required this.title,
      required this.description,
      required this.periodicity,
      required this.startDateTime,
      required this.endDateTime,
      required this.priority,
      required this.xp,
      required this.userId});
}
