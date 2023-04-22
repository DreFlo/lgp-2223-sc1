import 'package:mockito/annotations.dart';

import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';

@GenerateNiceMocks([
  MockSpec<TimeslotStudentTimeslotSuperEntity>(),
  MockSpec<TimeslotMediaTimeslotSuperEntity>(),
])
void main () {}