import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';

@Entity(
  tableName: 'series',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Media,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
  ],
)
class Series {
  @PrimaryKey()
  final int id;

  Series({required this.id});
}
