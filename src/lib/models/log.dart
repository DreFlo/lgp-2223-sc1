import 'package:floor/floor.dart';
import 'package:src/models/user.dart';

@Entity(
  tableName: 'log',
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    )
  ],
)
class Log {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final DateTime date;

  @ColumnInfo(name: 'user_id')
  final int userId;

  Log(
      {this.id,
      required this.date,
      required this.userId});
}
