import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'student_timeslot',
)
class StudentTimeslot extends Timeslot {
  @ForeignKey(entity: Task, childColumns: ['task_id'], parentColumns: ['id'])
  @ColumnInfo(name: 'task')
  final int? taskId;
  @ForeignKey(
      entity: Evaluation,
      childColumns: ['evaluation_id'],
      parentColumns: ['id'])
  @ColumnInfo(name: 'evaluation')
  final int? evaluationId;
  StudentTimeslot(
      {int? id,
      required String title,
      required String description,
      required Periodicity periodicity,
      required DateTime startDateTime,
      required DateTime endDateTime,
      required Priority priority,
      required int xp,
      required int userId,
      this.taskId,
      this.evaluationId})
      : super(
            id: id,
            title: title,
            description: description,
            periodicity: periodicity,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            priority: priority,
            xp: xp,
            userId: userId);
}
