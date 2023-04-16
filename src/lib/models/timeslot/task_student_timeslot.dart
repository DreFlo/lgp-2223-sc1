import 'package:floor/floor.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/timeslot/student_timeslot.dart';

@Entity(
  tableName: 'task_student_timeslot',
  primaryKeys: ['task_id', 'student_timeslot_id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['task_id'],
      parentColumns: ['id'],
      entity: Task,
    ),
    ForeignKey(
      childColumns: ['student_timeslot_id'],
      parentColumns: ['id'],
      entity: StudentTimeslot,
    ),
  ],
)
class TaskStudentTimeslot {
  @ColumnInfo(name: 'task_id')
  final int taskId;

  @ColumnInfo(name: 'student_timeslot_id')
  final int studentTimeslotId;

  TaskStudentTimeslot({required this.taskId, required this.studentTimeslotId});
}
