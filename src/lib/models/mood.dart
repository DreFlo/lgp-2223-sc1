import 'package:floor/floor.dart';
import 'package:src/utils/enums.dart';
import 'package:src/models/user.dart';

@Entity(
  tableName: 'mood',
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
class Mood {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final Emoji mood;

  final DateTime date;

  @ColumnInfo(name: 'user_id')
  final int userId;

  Mood(
      {this.id,
      required this.name,
      required this.mood,
      required this.date,
      required this.userId});
}
