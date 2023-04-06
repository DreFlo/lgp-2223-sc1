import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/timeslot/student_timeslot.dart';
import 'package:src/utils/enums.dart';

class TimeslotStudentTimeslotSuperEntity {
  final int? id;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Priority priority;
  final int xpMultiplier;
  final int userId;
  final List<int> taskId;

  TimeslotStudentTimeslotSuperEntity({
    this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.priority,
    required this.xpMultiplier,
    required this.userId,
    required this.taskId,
  });

  TimeslotStudentTimeslotSuperEntity.fromTimeslotStudentTimeslotEntity(
      StudentTimeslot studentTimeslot, Timeslot timeslot)
      : id = timeslot.id,
        title = timeslot.title,
        description = timeslot.description,
        startDateTime = timeslot.startDateTime,
        endDateTime = timeslot.endDateTime,
        priority = timeslot.priority,
        xpMultiplier = timeslot.xpMultiplier,
        userId = timeslot.userId,
        taskId = studentTimeslot.taskId;

  Timeslot toTimeslot() {
    return Timeslot(
      id: id,
      title: title,
      description: description,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      priority: priority,
      xpMultiplier: xpMultiplier,
      userId: userId,
    );
  }

  StudentTimeslot toStudentTimeslot() {
    return StudentTimeslot(
      id: id!,
      taskId: taskId,
    );
  }

  TimeslotStudentTimeslotSuperEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    Priority? priority,
    int? xpMultiplier,
    int? userId,
    List<int>? taskId,
  }) {
    return TimeslotStudentTimeslotSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      priority: priority ?? this.priority,
      xpMultiplier: xpMultiplier ?? this.xpMultiplier,
      userId: userId ?? this.userId,
      taskId: taskId ?? this.taskId,
    );
  }
}
