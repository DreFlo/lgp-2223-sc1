import 'package:floor/floor.dart';
import 'package:src/models/student/institution.dart';

@Entity(
  tableName: 'subject',
  foreignKeys: [
    ForeignKey(
        childColumns: ['institution_id'],
        parentColumns: ['id'],
        entity: Institution,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict)
  ],
)
class Subject {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String acronym;

  @ColumnInfo(name: 'weight_average')
  final double weightAverage;

  @ColumnInfo(name: 'institution_id')
  final int? institutionId;

  Subject({
    this.id,
    required this.name,
    required this.acronym,
    required this.weightAverage,
    this.institutionId,
  });
}
