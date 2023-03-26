import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:src/utils/type_converters.dart';

import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';

import 'package:src/daos/institution_dao.dart';
import 'package:src/models/institution.dart';

import 'package:src/daos/subject_dao.dart';
import 'package:src/models/subject.dart';

import 'package:src/daos/task_group_dao.dart';
import 'package:src/models/task_group.dart';

import 'package:src/daos/task_dao.dart';
import 'package:src/models/task.dart';

import 'package:src/daos/note_dao.dart';
import 'package:src/models/note.dart';

import 'package:src/daos/evaluation_dao.dart';
import 'package:src/models/evaluation.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(
    version: 2, entities: [Person, Institution, Subject, TaskGroup, Task, Note, Evaluation])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;

  InstitutionDao get institutionDao;
  SubjectDao get subjectDao;
  TaskGroupDao get taskGroupDao;
  TaskDao get taskDao;
  NoteDao get noteDao;
  EvaluationDao get evaluationDao;
}
