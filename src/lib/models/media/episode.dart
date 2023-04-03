import 'package:floor/floor.dart';
import 'package:src/models/media/video.dart';

@Entity(
  tableName: 'episode',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Video,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
  ],
)
class Episode {
  @PrimaryKey()
  final int id;

  final int number;

  Episode({
    required this.id,
    required this.number,
  });
}
