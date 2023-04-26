import 'package:mockito/annotations.dart';

import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/notes/task_note.dart';
import 'package:src/models/notes/note_task_note_super_entity.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';

@GenerateNiceMocks([
  MockSpec<Institution>(),
  MockSpec<Subject>(),
  MockSpec<Task>(),
  MockSpec<TaskGroup>(),
  MockSpec<TaskNote>(),
  MockSpec<NoteTaskNoteSuperEntity>(),
  MockSpec<TimeslotStudentTimeslotSuperEntity>(),
  MockSpec<TimeslotMediaTimeslotSuperEntity>(),
])
void main() {}
