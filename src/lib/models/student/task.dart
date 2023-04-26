import 'package:floor/floor.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'task',
  foreignKeys: [
    ForeignKey(
        childColumns: ['task_group_id'],
        parentColumns: ['id'],
        entity: TaskGroup),
    ForeignKey(
        childColumns: ['subject_id'],
        parentColumns: ['id'],
        entity: Subject,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict)
  ],
)
class Task {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String description;

  final Priority priority;

  final DateTime deadline;

  final int xp;

  @ColumnInfo(name: 'task_group_id')
  final int? taskGroupId;

  @ColumnInfo(name: 'subject_id')
  final int? subjectId;

  Task(
      {this.id,
      required this.name,
      required this.description,
      required this.priority,
      required this.deadline,
      this.taskGroupId,
      this.subjectId,
      required this.xp});
}
