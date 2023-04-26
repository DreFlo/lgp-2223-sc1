import 'package:floor/floor.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/utils/enums.dart';

@Entity(tableName: 'task_group', foreignKeys: [
  ForeignKey(
    childColumns: ['subject_id'],
    parentColumns: ['id'],
    entity: Subject,
    onDelete: ForeignKeyAction.cascade,
    onUpdate: ForeignKeyAction.restrict,
  )
])
class TaskGroup {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String description;

  final Priority priority;

  final DateTime deadline;

  @ColumnInfo(name: 'subject_id')
  final int? subjectId;

  TaskGroup({
    this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.deadline,
    this.subjectId,
  });
}
