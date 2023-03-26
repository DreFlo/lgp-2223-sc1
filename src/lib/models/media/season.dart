import 'package:floor/floor.dart';
import 'package:src/models/media/series.dart';

@Entity(
  tableName: 'season',
  foreignKeys: [
    ForeignKey(
      childColumns: ['series_id'],
      parentColumns: ['id'],
      entity: Series,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict
    )
  ],
)
class Season {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int number;

  @ColumnInfo(name: 'series_id')
  final int seriesId;

  Season({
    this.id,
    required this.number,
    required this.seriesId,
  });
}
