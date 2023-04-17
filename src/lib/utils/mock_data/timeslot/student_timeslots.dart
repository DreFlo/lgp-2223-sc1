import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';

final mockStudentTimeslots = [
  TimeslotStudentTimeslotSuperEntity(
      id: 2,
      title: 'Needs doing quick',
      description: 'word words words words words',
      startDateTime: DateTime.now().add(const Duration(hours: 6)),
      endDateTime: DateTime.now().add(const Duration(hours: 7)),
      xpMultiplier: 2,
      finished: false,
      userId: 1)
];
