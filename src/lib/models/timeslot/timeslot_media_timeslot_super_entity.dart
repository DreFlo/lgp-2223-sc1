import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/timeslot/media_timeslot.dart';
import 'package:src/utils/enums.dart';

class TimeslotMediaTimeslotSuperEntity {
  final int? id;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Priority priority;
  final int xpMultiplier;
  final int userId;
  final int mediaId; // TODO(TIMESLOT): correct - multiple media per timeslot

  TimeslotMediaTimeslotSuperEntity({
    this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.priority,
    required this.xpMultiplier,
    required this.userId,
    required this.mediaId,
  });

  TimeslotMediaTimeslotSuperEntity.fromTimeslotMediaTimeslotEntity(
      MediaTimeslot mediaTimeslot, Timeslot timeslot)
      : id = timeslot.id,
        title = timeslot.title,
        description = timeslot.description,
        startDateTime = timeslot.startDateTime,
        endDateTime = timeslot.endDateTime,
        priority = timeslot.priority,
        xpMultiplier = timeslot.xpMultiplier,
        userId = timeslot.userId,
        mediaId = mediaTimeslot.mediaId;

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

  MediaTimeslot toMediaTimeslot() {
    return MediaTimeslot(
      id: id!,
      mediaId: mediaId,
    );
  }

  TimeslotMediaTimeslotSuperEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    Priority? priority,
    int? xpMultiplier,
    int? userId,
    int? mediaId,
  }) {
    return TimeslotMediaTimeslotSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      priority: priority ?? this.priority,
      xpMultiplier: xpMultiplier ?? this.xpMultiplier,
      userId: userId ?? this.userId,
      mediaId: mediaId ?? this.mediaId,
    );
  }
}
