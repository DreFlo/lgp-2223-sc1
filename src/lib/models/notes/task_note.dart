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
    )
  ],
)
class TaskNote extends Note {
  @ColumnInfo(name: 'task_id')
  final int taskId;

  TaskNote({
    int? id,
    required String title,
    required String content,
    required DateTime date,
    required this.taskId,
  }) : super(id: id, title: title, content: content, date: date);
}
