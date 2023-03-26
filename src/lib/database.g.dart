// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PersonDao? _personDaoInstance;

  InstitutionDao? _institutionDaoInstance;

  SubjectDao? _subjectDaoInstance;

  TaskGroupDao? _taskGroupDaoInstance;

  TaskDao? _taskDaoInstance;

  NoteDao? _noteDaoInstance;

  EvaluationDao? _evaluationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Person` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `institution` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `picture` TEXT NOT NULL, `type` INTEGER NOT NULL, `acronym` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subject` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weightAverage` REAL NOT NULL, `institution_id` INTEGER NOT NULL, FOREIGN KEY (`intitution_id`) REFERENCES `institution` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task_group` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `subject_id` INTEGER, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `task_group_id` INTEGER NOT NULL, FOREIGN KEY (`task_group_id`) REFERENCES `task_group` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `note` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, `subject_id` INTEGER, `task_id` INTEGER, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `evaluation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight` REAL NOT NULL, `minimum` REAL NOT NULL, `grade` REAL NOT NULL, `subject_id` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PersonDao get personDao {
    return _personDaoInstance ??= _$PersonDao(database, changeListener);
  }

  @override
  InstitutionDao get institutionDao {
    return _institutionDaoInstance ??=
        _$InstitutionDao(database, changeListener);
  }

  @override
  SubjectDao get subjectDao {
    return _subjectDaoInstance ??= _$SubjectDao(database, changeListener);
  }

  @override
  TaskGroupDao get taskGroupDao {
    return _taskGroupDaoInstance ??= _$TaskGroupDao(database, changeListener);
  }

  @override
  TaskDao get taskDao {
    return _taskDaoInstance ??= _$TaskDao(database, changeListener);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }

  @override
  EvaluationDao get evaluationDao {
    return _evaluationDaoInstance ??= _$EvaluationDao(database, changeListener);
  }
}

class _$PersonDao extends PersonDao {
  _$PersonDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _personInsertionAdapter = InsertionAdapter(
            database,
            'Person',
            (Person item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Person> _personInsertionAdapter;

  @override
  Future<List<Person>> findAllPersons() async {
    return _queryAdapter.queryList('SELECT * FROM Person',
        mapper: (Map<String, Object?> row) =>
            Person(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Stream<Person?> findPersonById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Person WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Person(id: row['id'] as int?, name: row['name'] as String),
        arguments: [id],
        queryableName: 'Person',
        isView: false);
  }

  @override
  Future<void> insertPerson(Person person) async {
    await _personInsertionAdapter.insert(person, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPeople(List<Person> people) async {
    await _personInsertionAdapter.insertList(people, OnConflictStrategy.abort);
  }
}

class _$InstitutionDao extends InstitutionDao {
  _$InstitutionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _institutionInsertionAdapter = InsertionAdapter(
            database,
            'institution',
            (Institution item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'picture': item.picture,
                  'type': item.type.index,
                  'acronym': item.acronym
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Institution> _institutionInsertionAdapter;

  @override
  Future<List<Institution>> findAllInstitutions() async {
    return _queryAdapter.queryList('SELECT * FROM institution',
        mapper: (Map<String, Object?> row) => Institution(
            id: row['id'] as int?,
            name: row['name'] as String,
            picture: row['picture'] as String,
            type: InstitutionType.values[row['type'] as int],
            acronym: row['acronym'] as String));
  }

  @override
  Stream<Institution?> findInstitutionById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM institution WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Institution(
            id: row['id'] as int?,
            name: row['name'] as String,
            picture: row['picture'] as String,
            type: InstitutionType.values[row['type'] as int],
            acronym: row['acronym'] as String),
        arguments: [id],
        queryableName: 'institution',
        isView: false);
  }

  @override
  Future<void> insertInstitution(Institution institution) async {
    await _institutionInsertionAdapter.insert(
        institution, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertInstitutions(List<Institution> institutions) async {
    await _institutionInsertionAdapter.insertList(
        institutions, OnConflictStrategy.abort);
  }
}

class _$SubjectDao extends SubjectDao {
  _$SubjectDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _subjectInsertionAdapter = InsertionAdapter(
            database,
            'subject',
            (Subject item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'weightAverage': item.weightAverage,
                  'institution_id': item.institutionId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Subject> _subjectInsertionAdapter;

  @override
  Future<List<Subject>> findAllSubjects() async {
    return _queryAdapter.queryList('SELECT * FROM subject',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            weightAverage: row['weightAverage'] as double,
            institutionId: row['institution_id'] as int));
  }

  @override
  Stream<Subject?> findSubjectById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM subject WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            weightAverage: row['weightAverage'] as double,
            institutionId: row['institution_id'] as int),
        arguments: [id],
        queryableName: 'subject',
        isView: false);
  }

  @override
  Future<void> insertSubject(Subject subject) async {
    await _subjectInsertionAdapter.insert(subject, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSubjects(List<Subject> subjects) async {
    await _subjectInsertionAdapter.insertList(
        subjects, OnConflictStrategy.abort);
  }
}

class _$TaskGroupDao extends TaskGroupDao {
  _$TaskGroupDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _taskGroupInsertionAdapter = InsertionAdapter(
            database,
            'task_group',
            (TaskGroup item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'priority': item.priority.index,
                  'deadline': _dateTimeConverter.encode(item.deadline),
                  'subject_id': item.subjectId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TaskGroup> _taskGroupInsertionAdapter;

  @override
  Future<List<TaskGroup>> findAllTaskGroups() async {
    return _queryAdapter.queryList('SELECT * FROM task_group',
        mapper: (Map<String, Object?> row) => TaskGroup(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            priority: Priority.values[row['priority'] as int],
            deadline: _dateTimeConverter.decode(row['deadline'] as int),
            subjectId: row['subject_id'] as int?));
  }

  @override
  Stream<TaskGroup?> findTaskGroupById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM task_group WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TaskGroup(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            priority: Priority.values[row['priority'] as int],
            deadline: _dateTimeConverter.decode(row['deadline'] as int),
            subjectId: row['subject_id'] as int?),
        arguments: [id],
        queryableName: 'task_group',
        isView: false);
  }

  @override
  Future<void> insertTaskGroup(TaskGroup taskGroup) async {
    await _taskGroupInsertionAdapter.insert(
        taskGroup, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTaskGroups(List<TaskGroup> taskGroups) async {
    await _taskGroupInsertionAdapter.insertList(
        taskGroups, OnConflictStrategy.abort);
  }
}

class _$TaskDao extends TaskDao {
  _$TaskDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'task',
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'priority': item.priority.index,
                  'deadline': _dateTimeConverter.encode(item.deadline),
                  'task_group_id': item.taskGroupId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Task> _taskInsertionAdapter;

  @override
  Future<List<Task>> findAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM task',
        mapper: (Map<String, Object?> row) => Task(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            priority: Priority.values[row['priority'] as int],
            deadline: _dateTimeConverter.decode(row['deadline'] as int),
            taskGroupId: row['task_group_id'] as int));
  }

  @override
  Stream<Task?> findTaskById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM task WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Task(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            priority: Priority.values[row['priority'] as int],
            deadline: _dateTimeConverter.decode(row['deadline'] as int),
            taskGroupId: row['task_group_id'] as int),
        arguments: [id],
        queryableName: 'task',
        isView: false);
  }

  @override
  Future<void> insertTask(Task task) async {
    await _taskInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTasks(List<Task> tasks) async {
    await _taskInsertionAdapter.insertList(tasks, OnConflictStrategy.abort);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _noteInsertionAdapter = InsertionAdapter(
            database,
            'note',
            (Note item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date),
                  'subject_id': item.subjectId,
                  'task_id': item.taskId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  @override
  Future<List<Note>> findAllNotes() async {
    return _queryAdapter.queryList('SELECT * FROM note',
        mapper: (Map<String, Object?> row) => Note(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            subjectId: row['subject_id'] as int?,
            taskId: row['task_id'] as int?));
  }

  @override
  Stream<Note?> findNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Note(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            subjectId: row['subject_id'] as int?,
            taskId: row['task_id'] as int?),
        arguments: [id],
        queryableName: 'note',
        isView: false);
  }

  @override
  Stream<Note?> findNoteBySubjectId(int id) {
    return _queryAdapter.queryStream('SELECT * FROM note WHERE subject_id = ?1',
        mapper: (Map<String, Object?> row) => Note(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            subjectId: row['subject_id'] as int?,
            taskId: row['task_id'] as int?),
        arguments: [id],
        queryableName: 'note',
        isView: false);
  }

  @override
  Stream<Note?> findNoteByTaskId(int id) {
    return _queryAdapter.queryStream('SELECT * FROM note WHERE task_id = ?1',
        mapper: (Map<String, Object?> row) => Note(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            subjectId: row['subject_id'] as int?,
            taskId: row['task_id'] as int?),
        arguments: [id],
        queryableName: 'note',
        isView: false);
  }

  @override
  Future<void> insertNote(Note note) async {
    await _noteInsertionAdapter.insert(note, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertNotes(List<Note> notes) async {
    await _noteInsertionAdapter.insertList(notes, OnConflictStrategy.abort);
  }
}

class _$EvaluationDao extends EvaluationDao {
  _$EvaluationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _evaluationInsertionAdapter = InsertionAdapter(
            database,
            'evaluation',
            (Evaluation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'weight': item.weight,
                  'minimum': item.minimum,
                  'grade': item.grade,
                  'subject_id': item.subjectId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Evaluation> _evaluationInsertionAdapter;

  @override
  Future<List<Evaluation>> findAllEvaluations() async {
    return _queryAdapter.queryList('SELECT * FROM evaluation',
        mapper: (Map<String, Object?> row) => Evaluation(
            id: row['id'] as int?,
            name: row['name'] as String,
            grade: row['grade'] as double,
            weight: row['weight'] as double,
            minimum: row['minimum'] as double,
            subjectId: row['subject_id'] as int));
  }

  @override
  Stream<Evaluation?> findEvaluationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM evaluation WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Evaluation(
            id: row['id'] as int?,
            name: row['name'] as String,
            grade: row['grade'] as double,
            weight: row['weight'] as double,
            minimum: row['minimum'] as double,
            subjectId: row['subject_id'] as int),
        arguments: [id],
        queryableName: 'evaluation',
        isView: false);
  }

  @override
  Future<void> insertEvaluation(Evaluation evaluation) async {
    await _evaluationInsertionAdapter.insert(
        evaluation, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertEvaluations(List<Evaluation> evaluations) async {
    await _evaluationInsertionAdapter.insertList(
        evaluations, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
