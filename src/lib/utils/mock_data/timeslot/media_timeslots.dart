import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';

final mockMediaTimeslots = [
  TimeslotMediaTimeslotSuperEntity(
      id: 1,
      title: 'Bruh I\'m done with this',
      description: 'word words words words words',
      startDateTime: DateTime.now().add(const Duration(hours: 4)),
      endDateTime: DateTime.now().add(const Duration(hours: 6)),
      xpMultiplier: 2,
      userId: 1),
  TimeslotMediaTimeslotSuperEntity(
      id: 5,
      title: 'Star Wars marathon',
      description: 'word words words words words',
      startDateTime: DateTime(2023,4,27,0,0,0),
      endDateTime: DateTime(2023,4,27,23,59,59),
      xpMultiplier: 2,
      userId: 1)
];
