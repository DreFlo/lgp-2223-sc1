import 'package:floor/floor.dart';
import 'package:src/models/institution.dart';

@Entity(
  tableName: 'subject',
  foreignKeys: [
    ForeignKey(
        childColumns: ['intitution_id'],
        parentColumns: ['id'],
        entity: Institution,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict
    )
  ],
)
class Subject {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final double weightAverage;

  @ColumnInfo(name: 'institution_id')
  final int institutionId;

  Subject({
    this.id,
    required this.name,
    required this.weightAverage,
    required this.institutionId,
  });
}
