import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';

@Entity(tableName: 'student_timeslot', foreignKeys: [
  ForeignKey(
    childColumns: ['id'],
    parentColumns: ['id'],
    entity: Timeslot,
  ),
])
class StudentTimeslot {
  @PrimaryKey()
  final int id;

  StudentTimeslot({
    required this.id,
  });
}
