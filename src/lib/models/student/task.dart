import 'package:floor/floor.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'task',
  foreignKeys: [
    ForeignKey(
        childColumns: ['task_group_id'],
        parentColumns: ['id'],
        entity: TaskGroup,
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

  @ColumnInfo(name: 'task_group_id')
  final int taskGroupId;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.taskGroupId,
  });
}
