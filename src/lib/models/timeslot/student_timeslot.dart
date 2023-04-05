import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/utils/enums.dart';

@Entity(tableName: 'student_timeslot', foreignKeys: [
  ForeignKey(
      childColumns: ['task_id'],
      parentColumns: ['id'],
      entity: Task,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict),
  ForeignKey(
      childColumns: ['evaluation_id'],
      parentColumns: ['id'],
      entity: StudentEvaluation,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict)
])
class StudentTimeslot extends Timeslot {
  @ColumnInfo(name: 'task_id')
  final int? taskId;

  @ColumnInfo(name: 'evaluation_id')
  final int? evaluationId;
  StudentTimeslot(
      {int? id,
      required String title,
      required String description,
      required DateTime startDateTime,
      required DateTime endDateTime,
      required Priority priority,
      required int xpMultiplier,
      required int userId,
      this.taskId,
      this.evaluationId})
      : super(
            id: id,
            title: title,
            description: description,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            priority: priority,
            xpMultiplier: xpMultiplier,
            userId: userId);
}
