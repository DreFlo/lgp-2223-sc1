import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/timeslot/media_timeslot.dart';

class TimeslotMediaTimeslotSuperEntity {
  final int? id;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int xpMultiplier;
  final bool finished;
  final int userId;

  TimeslotMediaTimeslotSuperEntity({
    this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.xpMultiplier,
    required this.finished,
    required this.userId,
  });

  TimeslotMediaTimeslotSuperEntity.fromTimeslotMediaTimeslotEntity(
      MediaTimeslot mediaTimeslot, Timeslot timeslot)
      : id = timeslot.id,
        title = timeslot.title,
        description = timeslot.description,
        startDateTime = timeslot.startDateTime,
        endDateTime = timeslot.endDateTime,
        xpMultiplier = timeslot.xpMultiplier,
        finished = timeslot.finished,
        userId = timeslot.userId;

  Timeslot toTimeslot() {
    return Timeslot(
      id: id,
      title: title,
      description: description,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      xpMultiplier: xpMultiplier,
      finished: finished,
      userId: userId,
    );
  }

  MediaTimeslot toMediaTimeslot() {
    return MediaTimeslot(id: id!);
  }

  TimeslotMediaTimeslotSuperEntity copyWith(
      {int? id,
      String? title,
      String? description,
      DateTime? startDateTime,
      DateTime? endDateTime,
      int? xpMultiplier,
      bool? finished,
      int? userId}) {
    return TimeslotMediaTimeslotSuperEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        xpMultiplier: xpMultiplier ?? this.xpMultiplier,
        finished: finished ?? this.finished,
        userId: userId ?? this.userId);
  }
}
