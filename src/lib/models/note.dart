import 'package:floor/floor.dart';
import 'package:src/models/subject.dart';
import 'package:src/models/task.dart';

@Entity(
  tableName: 'note',
  foreignKeys: [
    ForeignKey(
      childColumns: ['subject_id'],
      parentColumns: ['id'],
      entity: Subject,
      // onDelete: ForeignKeyAction.cascade,
      // onUpdate: ForeignKeyAction.restrict
    ),
    ForeignKey(
      childColumns: ['task_id'],
      parentColumns: ['id'],
      entity: Task,
    ),
  ],
)
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;

  final String content;

  final DateTime date;

  @ColumnInfo(name: 'subject_id')
  final int? subjectId;

  @ColumnInfo(name: 'task_id')
  final int? taskId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.subjectId,
    this.taskId,
  });
}
