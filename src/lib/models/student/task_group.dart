import 'package:floor/floor.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'task_group',
)
class TaskGroup {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String description;

  final Priority priority;

  final DateTime deadline;

  TaskGroup({
    this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.deadline,
  });
}
