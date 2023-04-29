import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/utils/enums.dart';

final mockMediaTimeslots = [
  TimeslotMediaTimeslotSuperEntity(
      id: 1,
      title: 'Bruh I\'m done with this',
      description: 'word words words words words',
      startDateTime: DateTime(2023, 4, 25, 12, 0),
      endDateTime: DateTime(2023, 4, 26, 16, 0),
      xpMultiplier: 2,
      finished: false,
      type: MediaTypes.movie,
      userId: 1),
  TimeslotMediaTimeslotSuperEntity(
      id: 5,
      title: 'Star Wars marathon',
      description: 'word words words words words',
      startDateTime: DateTime(2023, 5, 1, 0, 0, 0),
      endDateTime: DateTime(2023, 5, 1, 23, 59, 59),
      xpMultiplier: 0,
      type: MediaTypes.movie,
      finished: false,
      userId: 1)
];
