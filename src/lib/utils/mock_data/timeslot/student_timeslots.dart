import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';

final mockStudentTimeslots = [
  TimeslotStudentTimeslotSuperEntity(
      id: 2,
      title: 'Needs doing quick',
      description: 'word words words words words',
      startDateTime: DateTime.now()
          .add(const Duration(days: 1))
          .add(const Duration(hours: 6)),
      endDateTime: DateTime.now()
          .add(const Duration(days: 1))
          .add(const Duration(hours: 7)),
      xpMultiplier: 2,
      userId: 1),
  TimeslotStudentTimeslotSuperEntity(
      id: 3,
      title: 'Needs doing quicker',
      description: 'word words words words words',
      startDateTime: DateTime.now()
          .add(const Duration(days: 1))
          .add(const Duration(hours: 6)),
      endDateTime: DateTime.now()
          .add(const Duration(days: 1))
          .add(const Duration(hours: 7)),
      xpMultiplier: 2,
      userId: 1),
  TimeslotStudentTimeslotSuperEntity(
      id: 4,
      title: 'Needs doing quicker',
      description: 'word words words words words',
      startDateTime: DateTime.now(),
      endDateTime: DateTime.now().add(const Duration(days: 1)),
      xpMultiplier: 2,
      userId: 1)
];
