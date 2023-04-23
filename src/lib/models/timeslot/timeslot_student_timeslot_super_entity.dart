import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/timeslot/student_timeslot.dart';

class TimeslotStudentTimeslotSuperEntity {
  final int? id;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int xpMultiplier;
  final int userId;

  TimeslotStudentTimeslotSuperEntity({
    this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.xpMultiplier,
    required this.userId,
  });

  TimeslotStudentTimeslotSuperEntity.fromTimeslotStudentTimeslotEntity(
      StudentTimeslot studentTimeslot, Timeslot timeslot)
      : id = timeslot.id,
        title = timeslot.title,
        description = timeslot.description,
        startDateTime = timeslot.startDateTime,
        endDateTime = timeslot.endDateTime,
        xpMultiplier = timeslot.xpMultiplier,
        userId = timeslot.userId;

  Timeslot toTimeslot() {
    return Timeslot(
      id: id,
      title: title,
      description: description,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      xpMultiplier: xpMultiplier,
      userId: userId,
    );
  }

  StudentTimeslot toStudentTimeslot() {
    return StudentTimeslot(
      id: id!,
    );
  }

  TimeslotStudentTimeslotSuperEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    int? xpMultiplier,
    int? userId,
  }) {
    return TimeslotStudentTimeslotSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      xpMultiplier: xpMultiplier ?? this.xpMultiplier,
      userId: userId ?? this.userId,
    );
  }
}
