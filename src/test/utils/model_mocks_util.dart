import 'package:mockito/annotations.dart';

import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';

@GenerateNiceMocks([
  MockSpec<Task>(),
  MockSpec<TaskGroup>(),
  MockSpec<TimeslotMediaTimeslotSuperEntity>(),
])
void main () {}