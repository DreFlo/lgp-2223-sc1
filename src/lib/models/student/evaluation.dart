import 'package:floor/floor.dart';
import 'package:src/models/student/subject.dart';

@Entity(
  tableName: 'evaluation',
  foreignKeys: [
    ForeignKey(
        childColumns: ['subject_id'],
        parentColumns: ['id'],
        entity: Subject,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict)
  ],
)
class StudentEvaluation {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final double weight;

  final double minimum;

  final double grade;

  @ColumnInfo(name: 'subject_id')
  final int subjectId;

  StudentEvaluation({
    this.id,
    required this.name,
    required this.grade,
    required this.weight,
    required this.minimum,
    required this.subjectId,
  });
}
