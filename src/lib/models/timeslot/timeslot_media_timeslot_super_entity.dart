import 'package:src/models/timeslot/timeslot.dart';
import 'package:src/models/timeslot/media_timeslot.dart';

class TimeslotMediaTimeslotSuperEntity {
  final int? id;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int xpMultiplier;
  final int userId;
  final List<int> mediaId;

  TimeslotMediaTimeslotSuperEntity({
    this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
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
    int? xpMultiplier,
    int? userId,
    List<int>? mediaId,
  }) {
    return TimeslotMediaTimeslotSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      xpMultiplier: xpMultiplier ?? this.xpMultiplier,
      userId: userId ?? this.userId,
      mediaId: mediaId ?? this.mediaId,
    );
  }
}
