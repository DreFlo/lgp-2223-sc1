import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';

final mockMediaTimeslots = [
  TimeslotMediaTimeslotSuperEntity(
      id: 1,
      title: 'Bruh I\'m done with this',
      description: 'word words words words words',
      startDateTime: DateTime.now().add(const Duration(hours: 4)),
      endDateTime: DateTime.now().add(const Duration(hours: 6)),
      xpMultiplier: 2,
      finished: false,
      userId: 1)
];
