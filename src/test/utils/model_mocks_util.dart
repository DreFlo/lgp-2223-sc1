import 'package:mockito/annotations.dart';

import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';
import 'package:src/models/student/task.dart';
import 'package:src/models/student/task_group.dart';
import 'package:src/models/notes/task_note.dart';

@GenerateNiceMocks([
  MockSpec<Institution>(),
  MockSpec<Subject>(),
  MockSpec<Task>(),
  MockSpec<TaskGroup>(),
  MockSpec<TaskNote>()
])
void main() {}
