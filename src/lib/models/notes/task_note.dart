import 'package:floor/floor.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/student/task.dart';

@Entity(
  tableName: 'task_note',
  foreignKeys: [
    ForeignKey(
      childColumns: ['task_id'],
      parentColumns: ['id'],
      entity: Task,
    ),
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Note,
    ),
  ],
)
class TaskNote  {
  @PrimaryKey()
  final int id;

  @ColumnInfo(name: 'task_id')
  final int taskId;

  TaskNote({
    required this.id,
    required this.taskId,
  });
}
