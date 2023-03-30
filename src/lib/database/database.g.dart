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

  InstitutionDao? _institutionDaoInstance;

  SubjectDao? _subjectDaoInstance;

  TaskGroupDao? _taskGroupDaoInstance;

  TaskDao? _taskDaoInstance;

  EvaluationDao? _evaluationDaoInstance;

  MediaDao? _mediaDaoInstance;

  BookDao? _bookDaoInstance;

  SeriesDao? _seriesDaoInstance;

  VideoDao? _videoDaoInstance;

  SeasonDao? _seasonDaoInstance;

  ReviewDao? _reviewDaoInstance;

  MovieDao? _movieDaoInstance;

  EpisodeDao? _episodeDaoInstance;

  NoteDao? _noteDaoInstance;

  SubjectNoteDao? _subjectNoteDaoInstance;

  TaskNoteDao? _taskNoteDaoInstance;

  EpisodeNoteDao? _episodeNoteDaoInstance;

  BookNoteDao? _bookNoteDaoInstance;

  UserBadgeDao? _userBadgeDaoInstance;

  BadgeDao? _badgeDaoInstance;

  MoodDao? _moodDaoInstance;

  TimeslotDao? _timeslotDaoInstance;

  MediaTimeslotDao? _mediaTimeslotDaoInstance;

  StudentTimeslotDao? _studentTimeslotDaoInstance;

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 4,
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
            'CREATE TABLE IF NOT EXISTS `institution` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `picture` TEXT NOT NULL, `type` INTEGER NOT NULL, `acronym` TEXT NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subject` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight_average` REAL NOT NULL, `institution_id` INTEGER NOT NULL, FOREIGN KEY (`institution_id`) REFERENCES `institution` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task_group` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `subject_id` INTEGER, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `task_group_id` INTEGER NOT NULL, FOREIGN KEY (`task_group_id`) REFERENCES `task_group` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `evaluation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight` REAL NOT NULL, `minimum` REAL NOT NULL, `grade` REAL NOT NULL, `subject_id` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `media` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `book` (`authors` TEXT NOT NULL, `total_pages` INTEGER NOT NULL, `progress_pages` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `series` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `video` (`duration` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `season` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `number` INTEGER NOT NULL, `series_id` INTEGER NOT NULL, FOREIGN KEY (`series_id`) REFERENCES `series` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `review` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `start_date` INTEGER NOT NULL, `end_date` INTEGER NOT NULL, `review` TEXT NOT NULL, `rating` INTEGER NOT NULL, `emoji` INTEGER NOT NULL, `media_id` INTEGER NOT NULL, FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movie` (`duration` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `episode` (`number` INTEGER NOT NULL, `season_id` INTEGER NOT NULL, `duration` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL, FOREIGN KEY (`season_id`) REFERENCES `season` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `note` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subject_note` (`subject_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task_note` (`task_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `episode_note` (`episode_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`episode_id`) REFERENCES `episode` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `book_note` (`startPage` INTEGER NOT NULL, `endPage` INTEGER NOT NULL, `book_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL, FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userName` TEXT NOT NULL, `password` TEXT NOT NULL, `xp` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `badge` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `imagePath` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mood` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `mood` INTEGER NOT NULL, `date` INTEGER NOT NULL, `user_id` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `timeslot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `media_timeslot` (`media` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `student_timeslot` (`task` INTEGER, `evaluation` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `periodicity` INTEGER NOT NULL, `startDateTime` INTEGER NOT NULL, `endDateTime` INTEGER NOT NULL, `priority` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `user_id` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user_badge` (`user_id` INTEGER NOT NULL, `badge_id` INTEGER NOT NULL, PRIMARY KEY (`user_id`, `badge_id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
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
  EvaluationDao get evaluationDao {
    return _evaluationDaoInstance ??= _$EvaluationDao(database, changeListener);
  }

  @override
  MediaDao get mediaDao {
    return _mediaDaoInstance ??= _$MediaDao(database, changeListener);
  }

  @override
  BookDao get bookDao {
    return _bookDaoInstance ??= _$BookDao(database, changeListener);
  }

  @override
  SeriesDao get seriesDao {
    return _seriesDaoInstance ??= _$SeriesDao(database, changeListener);
  }

  @override
  VideoDao get videoDao {
    return _videoDaoInstance ??= _$VideoDao(database, changeListener);
  }

  @override
  SeasonDao get seasonDao {
    return _seasonDaoInstance ??= _$SeasonDao(database, changeListener);
  }

  @override
  ReviewDao get reviewDao {
    return _reviewDaoInstance ??= _$ReviewDao(database, changeListener);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }

  @override
  EpisodeDao get episodeDao {
    return _episodeDaoInstance ??= _$EpisodeDao(database, changeListener);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }

  @override
  SubjectNoteDao get subjectNoteDao {
    return _subjectNoteDaoInstance ??=
        _$SubjectNoteDao(database, changeListener);
  }

  @override
  TaskNoteDao get taskNoteDao {
    return _taskNoteDaoInstance ??= _$TaskNoteDao(database, changeListener);
  }

  @override
  EpisodeNoteDao get episodeNoteDao {
    return _episodeNoteDaoInstance ??=
        _$EpisodeNoteDao(database, changeListener);
  }

  @override
  BookNoteDao get bookNoteDao {
    return _bookNoteDaoInstance ??= _$BookNoteDao(database, changeListener);
  }

  @override
  UserBadgeDao get userBadgeDao {
    return _userBadgeDaoInstance ??= _$UserBadgeDao(database, changeListener);
  }

  @override
  BadgeDao get badgeDao {
    return _badgeDaoInstance ??= _$BadgeDao(database, changeListener);
  }

  @override
  MoodDao get moodDao {
    return _moodDaoInstance ??= _$MoodDao(database, changeListener);
  }

  @override
  TimeslotDao get timeslotDao {
    return _timeslotDaoInstance ??= _$TimeslotDao(database, changeListener);
  }

  @override
  MediaTimeslotDao get mediaTimeslotDao {
    return _mediaTimeslotDaoInstance ??=
        _$MediaTimeslotDao(database, changeListener);
  }

  @override
  StudentTimeslotDao get studentTimeslotDao {
    return _studentTimeslotDaoInstance ??=
        _$StudentTimeslotDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
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
                  'acronym': item.acronym,
                  'user_id': item.userId
                },
            changeListener),
        _institutionUpdateAdapter = UpdateAdapter(
            database,
            'institution',
            ['id'],
            (Institution item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'picture': item.picture,
                  'type': item.type.index,
                  'acronym': item.acronym,
                  'user_id': item.userId
                },
            changeListener),
        _institutionDeletionAdapter = DeletionAdapter(
            database,
            'institution',
            ['id'],
            (Institution item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'picture': item.picture,
                  'type': item.type.index,
                  'acronym': item.acronym,
                  'user_id': item.userId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Institution> _institutionInsertionAdapter;

  final UpdateAdapter<Institution> _institutionUpdateAdapter;

  final DeletionAdapter<Institution> _institutionDeletionAdapter;

  @override
  Future<List<Institution>> findAllInstitutions() async {
    return _queryAdapter.queryList('SELECT * FROM institution',
        mapper: (Map<String, Object?> row) => Institution(
            id: row['id'] as int?,
            name: row['name'] as String,
            picture: row['picture'] as String,
            type: InstitutionType.values[row['type'] as int],
            acronym: row['acronym'] as String,
            userId: row['user_id'] as int));
  }

  @override
  Stream<Institution?> findInstitutionById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM institution WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Institution(
            id: row['id'] as int?,
            name: row['name'] as String,
            picture: row['picture'] as String,
            type: InstitutionType.values[row['type'] as int],
            acronym: row['acronym'] as String,
            userId: row['user_id'] as int),
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

  @override
  Future<void> updateInstitution(Institution institution) async {
    await _institutionUpdateAdapter.update(
        institution, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteInstitution(Institution institution) async {
    await _institutionDeletionAdapter.delete(institution);
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
                  'weight_average': item.weightAverage,
                  'institution_id': item.institutionId
                },
            changeListener),
        _subjectUpdateAdapter = UpdateAdapter(
            database,
            'subject',
            ['id'],
            (Subject item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'weight_average': item.weightAverage,
                  'institution_id': item.institutionId
                },
            changeListener),
        _subjectDeletionAdapter = DeletionAdapter(
            database,
            'subject',
            ['id'],
            (Subject item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'weight_average': item.weightAverage,
                  'institution_id': item.institutionId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Subject> _subjectInsertionAdapter;

  final UpdateAdapter<Subject> _subjectUpdateAdapter;

  final DeletionAdapter<Subject> _subjectDeletionAdapter;

  @override
  Future<List<Subject>> findAllSubjects() async {
    return _queryAdapter.queryList('SELECT * FROM subject',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            weightAverage: row['weight_average'] as double,
            institutionId: row['institution_id'] as int));
  }

  @override
  Stream<Subject?> findSubjectById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM subject WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            weightAverage: row['weight_average'] as double,
            institutionId: row['institution_id'] as int),
        arguments: [id],
        queryableName: 'subject',
        isView: false);
  }

  @override
  Stream<Subject?> findSubjectByInstitutionId(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM subject WHERE institution_id = ?1',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            weightAverage: row['weight_average'] as double,
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

  @override
  Future<void> updateSubject(Subject subject) async {
    await _subjectUpdateAdapter.update(subject, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSubject(Subject subject) async {
    await _subjectDeletionAdapter.delete(subject);
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
            changeListener),
        _taskGroupUpdateAdapter = UpdateAdapter(
            database,
            'task_group',
            ['id'],
            (TaskGroup item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'priority': item.priority.index,
                  'deadline': _dateTimeConverter.encode(item.deadline),
                  'subject_id': item.subjectId
                },
            changeListener),
        _taskGroupDeletionAdapter = DeletionAdapter(
            database,
            'task_group',
            ['id'],
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

  final UpdateAdapter<TaskGroup> _taskGroupUpdateAdapter;

  final DeletionAdapter<TaskGroup> _taskGroupDeletionAdapter;

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

  @override
  Future<void> updateTaskGroup(TaskGroup taskGroup) async {
    await _taskGroupUpdateAdapter.update(taskGroup, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTaskGroup(TaskGroup taskGroup) async {
    await _taskGroupDeletionAdapter.delete(taskGroup);
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
            changeListener),
        _taskUpdateAdapter = UpdateAdapter(
            database,
            'task',
            ['id'],
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'priority': item.priority.index,
                  'deadline': _dateTimeConverter.encode(item.deadline),
                  'task_group_id': item.taskGroupId
                },
            changeListener),
        _taskDeletionAdapter = DeletionAdapter(
            database,
            'task',
            ['id'],
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

  final UpdateAdapter<Task> _taskUpdateAdapter;

  final DeletionAdapter<Task> _taskDeletionAdapter;

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

  @override
  Future<void> updateTask(Task task) async {
    await _taskUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _taskDeletionAdapter.delete(task);
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
            changeListener),
        _evaluationUpdateAdapter = UpdateAdapter(
            database,
            'evaluation',
            ['id'],
            (Evaluation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'weight': item.weight,
                  'minimum': item.minimum,
                  'grade': item.grade,
                  'subject_id': item.subjectId
                },
            changeListener),
        _evaluationDeletionAdapter = DeletionAdapter(
            database,
            'evaluation',
            ['id'],
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

  final UpdateAdapter<Evaluation> _evaluationUpdateAdapter;

  final DeletionAdapter<Evaluation> _evaluationDeletionAdapter;

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

  @override
  Future<void> updateEvaluation(Evaluation evaluation) async {
    await _evaluationUpdateAdapter.update(evaluation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEvaluation(Evaluation evaluation) async {
    await _evaluationDeletionAdapter.delete(evaluation);
  }
}

class _$MediaDao extends MediaDao {
  _$MediaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _mediaInsertionAdapter = InsertionAdapter(
            database,
            'media',
            (Media item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _mediaUpdateAdapter = UpdateAdapter(
            database,
            'media',
            ['id'],
            (Media item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _mediaDeletionAdapter = DeletionAdapter(
            database,
            'media',
            ['id'],
            (Media item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Media> _mediaInsertionAdapter;

  final UpdateAdapter<Media> _mediaUpdateAdapter;

  final DeletionAdapter<Media> _mediaDeletionAdapter;

  @override
  Future<List<Media>> findAllMedia() async {
    return _queryAdapter.queryList('SELECT * FROM media',
        mapper: (Map<String, Object?> row) => Media(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0));
  }

  @override
  Stream<Media?> findMediaById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM media WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Media(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0),
        arguments: [id],
        queryableName: 'media',
        isView: false);
  }

  @override
  Future<void> insertMedia(Media media) async {
    await _mediaInsertionAdapter.insert(media, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMedias(List<Media> medias) async {
    await _mediaInsertionAdapter.insertList(medias, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMedia(Media media) async {
    await _mediaUpdateAdapter.update(media, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMedia(Media media) async {
    await _mediaDeletionAdapter.delete(media);
  }
}

class _$BookDao extends BookDao {
  _$BookDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _bookInsertionAdapter = InsertionAdapter(
            database,
            'book',
            (Book item) => <String, Object?>{
                  'authors': item.authors,
                  'total_pages': item.totalPages,
                  'progress_pages': item.progressPages,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _bookDeletionAdapter = DeletionAdapter(
            database,
            'book',
            ['id'],
            (Book item) => <String, Object?>{
                  'authors': item.authors,
                  'total_pages': item.totalPages,
                  'progress_pages': item.progressPages,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Book> _bookInsertionAdapter;

  final DeletionAdapter<Book> _bookDeletionAdapter;

  @override
  Future<List<Book>> findAllBooks() async {
    return _queryAdapter.queryList('SELECT * FROM book',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            authors: row['authors'] as String,
            totalPages: row['total_pages'] as int,
            progressPages: row['progress_pages'] as int?));
  }

  @override
  Stream<Book?> findBookById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM book WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            authors: row['authors'] as String,
            totalPages: row['total_pages'] as int,
            progressPages: row['progress_pages'] as int?),
        arguments: [id],
        queryableName: 'book',
        isView: false);
  }

  @override
  Future<void> insertBook(Book book) async {
    await _bookInsertionAdapter.insert(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertBooks(List<Book> books) async {
    await _bookInsertionAdapter.insertList(books, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBooks(Book book) async {
    await _bookDeletionAdapter.delete(book);
  }
}

class _$SeriesDao extends SeriesDao {
  _$SeriesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _seriesInsertionAdapter = InsertionAdapter(
            database,
            'series',
            (Series item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _seriesUpdateAdapter = UpdateAdapter(
            database,
            'series',
            ['id'],
            (Series item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _seriesDeletionAdapter = DeletionAdapter(
            database,
            'series',
            ['id'],
            (Series item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Series> _seriesInsertionAdapter;

  final UpdateAdapter<Series> _seriesUpdateAdapter;

  final DeletionAdapter<Series> _seriesDeletionAdapter;

  @override
  Future<List<Series>> findAllSeries() async {
    return _queryAdapter.queryList('SELECT * FROM series',
        mapper: (Map<String, Object?> row) => Series(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0));
  }

  @override
  Stream<Series?> findSeriesById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM series WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Series(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0),
        arguments: [id],
        queryableName: 'series',
        isView: false);
  }

  @override
  Future<void> insertSerie(Series series) async {
    await _seriesInsertionAdapter.insert(series, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSeries(List<Series> series) async {
    await _seriesInsertionAdapter.insertList(series, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSerie(Series series) async {
    await _seriesUpdateAdapter.update(series, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSeries(List<Series> series) async {
    await _seriesUpdateAdapter.updateList(series, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSerie(Series series) async {
    await _seriesDeletionAdapter.delete(series);
  }
}

class _$VideoDao extends VideoDao {
  _$VideoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _videoInsertionAdapter = InsertionAdapter(
            database,
            'video',
            (Video item) => <String, Object?>{
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _videoUpdateAdapter = UpdateAdapter(
            database,
            'video',
            ['id'],
            (Video item) => <String, Object?>{
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _videoDeletionAdapter = DeletionAdapter(
            database,
            'video',
            ['id'],
            (Video item) => <String, Object?>{
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Video> _videoInsertionAdapter;

  final UpdateAdapter<Video> _videoUpdateAdapter;

  final DeletionAdapter<Video> _videoDeletionAdapter;

  @override
  Future<List<Video>> findAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM Video',
        mapper: (Map<String, Object?> row) => Video(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            duration: row['duration'] as int));
  }

  @override
  Stream<Video?> findVideoById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Video WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Video(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            duration: row['duration'] as int),
        arguments: [id],
        queryableName: 'Video',
        isView: false);
  }

  @override
  Future<void> insertVideo(Video video) async {
    await _videoInsertionAdapter.insert(video, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertVideos(List<Video> video) async {
    await _videoInsertionAdapter.insertList(video, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateVideo(Video video) async {
    await _videoUpdateAdapter.update(video, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteVideo(Video video) async {
    await _videoDeletionAdapter.delete(video);
  }
}

class _$SeasonDao extends SeasonDao {
  _$SeasonDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _seasonInsertionAdapter = InsertionAdapter(
            database,
            'season',
            (Season item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'series_id': item.seriesId
                },
            changeListener),
        _seasonUpdateAdapter = UpdateAdapter(
            database,
            'season',
            ['id'],
            (Season item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'series_id': item.seriesId
                },
            changeListener),
        _seasonDeletionAdapter = DeletionAdapter(
            database,
            'season',
            ['id'],
            (Season item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'series_id': item.seriesId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Season> _seasonInsertionAdapter;

  final UpdateAdapter<Season> _seasonUpdateAdapter;

  final DeletionAdapter<Season> _seasonDeletionAdapter;

  @override
  Future<List<Season>> findAllSeason() async {
    return _queryAdapter.queryList('SELECT * FROM season',
        mapper: (Map<String, Object?> row) => Season(
            id: row['id'] as int?,
            number: row['number'] as int,
            seriesId: row['series_id'] as int));
  }

  @override
  Stream<Season?> findSeasonById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM season WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Season(
            id: row['id'] as int?,
            number: row['number'] as int,
            seriesId: row['series_id'] as int),
        arguments: [id],
        queryableName: 'season',
        isView: false);
  }

  @override
  Future<void> insertSeason(Season season) async {
    await _seasonInsertionAdapter.insert(season, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSeasons(List<Season> season) async {
    await _seasonInsertionAdapter.insertList(season, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSeason(Season season) async {
    await _seasonUpdateAdapter.update(season, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSeasons(List<Season> season) async {
    await _seasonUpdateAdapter.updateList(season, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSeason(Season season) async {
    await _seasonDeletionAdapter.delete(season);
  }
}

class _$ReviewDao extends ReviewDao {
  _$ReviewDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _reviewInsertionAdapter = InsertionAdapter(
            database,
            'review',
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'start_date': _dateTimeConverter.encode(item.startDate),
                  'end_date': _dateTimeConverter.encode(item.endDate),
                  'review': item.review,
                  'rating': item.rating,
                  'emoji': item.emoji.index,
                  'media_id': item.mediaId
                },
            changeListener),
        _reviewUpdateAdapter = UpdateAdapter(
            database,
            'review',
            ['id'],
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'start_date': _dateTimeConverter.encode(item.startDate),
                  'end_date': _dateTimeConverter.encode(item.endDate),
                  'review': item.review,
                  'rating': item.rating,
                  'emoji': item.emoji.index,
                  'media_id': item.mediaId
                },
            changeListener),
        _reviewDeletionAdapter = DeletionAdapter(
            database,
            'review',
            ['id'],
            (Review item) => <String, Object?>{
                  'id': item.id,
                  'start_date': _dateTimeConverter.encode(item.startDate),
                  'end_date': _dateTimeConverter.encode(item.endDate),
                  'review': item.review,
                  'rating': item.rating,
                  'emoji': item.emoji.index,
                  'media_id': item.mediaId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Review> _reviewInsertionAdapter;

  final UpdateAdapter<Review> _reviewUpdateAdapter;

  final DeletionAdapter<Review> _reviewDeletionAdapter;

  @override
  Future<List<Review>> findAllReviews() async {
    return _queryAdapter.queryList('SELECT * FROM review',
        mapper: (Map<String, Object?> row) => Review(
            id: row['id'] as int?,
            startDate: _dateTimeConverter.decode(row['start_date'] as int),
            endDate: _dateTimeConverter.decode(row['end_date'] as int),
            review: row['review'] as String,
            rating: row['rating'] as int,
            emoji: Emoji.values[row['emoji'] as int],
            mediaId: row['media_id'] as int));
  }

  @override
  Stream<Review?> findReviewById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM review WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Review(
            id: row['id'] as int?,
            startDate: _dateTimeConverter.decode(row['start_date'] as int),
            endDate: _dateTimeConverter.decode(row['end_date'] as int),
            review: row['review'] as String,
            rating: row['rating'] as int,
            emoji: Emoji.values[row['emoji'] as int],
            mediaId: row['media_id'] as int),
        arguments: [id],
        queryableName: 'review',
        isView: false);
  }

  @override
  Future<void> insertReview(Review review) async {
    await _reviewInsertionAdapter.insert(review, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertReviews(List<Review> reviews) async {
    await _reviewInsertionAdapter.insertList(reviews, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateReview(Review review) async {
    await _reviewUpdateAdapter.update(review, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReview(Review review) async {
    await _reviewDeletionAdapter.delete(review);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _movieInsertionAdapter = InsertionAdapter(
            database,
            'movie',
            (Movie item) => <String, Object?>{
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _movieUpdateAdapter = UpdateAdapter(
            database,
            'movie',
            ['id'],
            (Movie item) => <String, Object?>{
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _movieDeletionAdapter = DeletionAdapter(
            database,
            'movie',
            ['id'],
            (Movie item) => <String, Object?>{
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Movie> _movieInsertionAdapter;

  final UpdateAdapter<Movie> _movieUpdateAdapter;

  final DeletionAdapter<Movie> _movieDeletionAdapter;

  @override
  Future<List<Movie>> findAllMovie() async {
    return _queryAdapter.queryList('SELECT * FROM movie',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            duration: row['duration'] as int));
  }

  @override
  Stream<Movie?> findMovieById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM movie WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            duration: row['duration'] as int),
        arguments: [id],
        queryableName: 'movie',
        isView: false);
  }

  @override
  Future<void> insertMovie(Movie movie) async {
    await _movieInsertionAdapter.insert(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMovies(List<Movie> movie) async {
    await _movieInsertionAdapter.insertList(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    await _movieUpdateAdapter.update(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMovie(Movie movie) async {
    await _movieDeletionAdapter.delete(movie);
  }
}

class _$EpisodeDao extends EpisodeDao {
  _$EpisodeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _episodeInsertionAdapter = InsertionAdapter(
            database,
            'episode',
            (Episode item) => <String, Object?>{
                  'number': item.number,
                  'season_id': item.seasonId,
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _episodeUpdateAdapter = UpdateAdapter(
            database,
            'episode',
            ['id'],
            (Episode item) => <String, Object?>{
                  'number': item.number,
                  'season_id': item.seasonId,
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener),
        _episodeDeletionAdapter = DeletionAdapter(
            database,
            'episode',
            ['id'],
            (Episode item) => <String, Object?>{
                  'number': item.number,
                  'season_id': item.seasonId,
                  'duration': item.duration,
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'link_image': item.linkImage,
                  'status': item.status.index,
                  'favorite': item.favorite ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Episode> _episodeInsertionAdapter;

  final UpdateAdapter<Episode> _episodeUpdateAdapter;

  final DeletionAdapter<Episode> _episodeDeletionAdapter;

  @override
  Future<List<Episode>> findAllEpisode() async {
    return _queryAdapter.queryList('SELECT * FROM episode',
        mapper: (Map<String, Object?> row) => Episode(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            duration: row['duration'] as int,
            number: row['number'] as int,
            seasonId: row['season_id'] as int));
  }

  @override
  Stream<Episode?> findEpisodeById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM episode WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Episode(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            linkImage: row['link_image'] as String,
            status: Status.values[row['status'] as int],
            favorite: (row['favorite'] as int) != 0,
            duration: row['duration'] as int,
            number: row['number'] as int,
            seasonId: row['season_id'] as int),
        arguments: [id],
        queryableName: 'episode',
        isView: false);
  }

  @override
  Future<void> insertEpisode(Episode episode) async {
    await _episodeInsertionAdapter.insert(episode, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertEpisodes(List<Episode> episodes) async {
    await _episodeInsertionAdapter.insertList(
        episodes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEpisodes(Episode episode) async {
    await _episodeUpdateAdapter.update(episode, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEpisode(Episode episode) async {
    await _episodeDeletionAdapter.delete(episode);
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
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _noteUpdateAdapter = UpdateAdapter(
            database,
            'note',
            ['id'],
            (Note item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _noteDeletionAdapter = DeletionAdapter(
            database,
            'note',
            ['id'],
            (Note item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final UpdateAdapter<Note> _noteUpdateAdapter;

  final DeletionAdapter<Note> _noteDeletionAdapter;

  @override
  Future<List<Note>> findAllNotes() async {
    return _queryAdapter.queryList('SELECT * FROM note',
        mapper: (Map<String, Object?> row) => Note(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int)));
  }

  @override
  Stream<Note?> findNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Note(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int)),
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

  @override
  Future<void> updateNote(Note note) async {
    await _noteUpdateAdapter.update(note, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteNote(Note note) async {
    await _noteDeletionAdapter.delete(note);
  }
}

class _$SubjectNoteDao extends SubjectNoteDao {
  _$SubjectNoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _subjectNoteInsertionAdapter = InsertionAdapter(
            database,
            'subject_note',
            (SubjectNote item) => <String, Object?>{
                  'subject_id': item.subjectId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _subjectNoteUpdateAdapter = UpdateAdapter(
            database,
            'subject_note',
            ['id'],
            (SubjectNote item) => <String, Object?>{
                  'subject_id': item.subjectId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _subjectNoteDeletionAdapter = DeletionAdapter(
            database,
            'subject_note',
            ['id'],
            (SubjectNote item) => <String, Object?>{
                  'subject_id': item.subjectId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubjectNote> _subjectNoteInsertionAdapter;

  final UpdateAdapter<SubjectNote> _subjectNoteUpdateAdapter;

  final DeletionAdapter<SubjectNote> _subjectNoteDeletionAdapter;

  @override
  Future<List<SubjectNote>> findAllSubjectNotes() async {
    return _queryAdapter.queryList('SELECT * FROM subject_note',
        mapper: (Map<String, Object?> row) => SubjectNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            subjectId: row['subject_id'] as int));
  }

  @override
  Stream<SubjectNote?> findSubjectNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM subject_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SubjectNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            subjectId: row['subject_id'] as int),
        arguments: [id],
        queryableName: 'subject_note',
        isView: false);
  }

  @override
  Future<void> insertSubjectNote(SubjectNote subjectNote) async {
    await _subjectNoteInsertionAdapter.insert(
        subjectNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSubjectNotes(List<SubjectNote> subjectNotes) async {
    await _subjectNoteInsertionAdapter.insertList(
        subjectNotes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSubjectNote(SubjectNote subjectNote) async {
    await _subjectNoteUpdateAdapter.update(
        subjectNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSubjectNotes(List<SubjectNote> subjectNotes) async {
    await _subjectNoteUpdateAdapter.updateList(
        subjectNotes, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSubjectNote(SubjectNote subjectNote) async {
    await _subjectNoteDeletionAdapter.delete(subjectNote);
  }
}

class _$TaskNoteDao extends TaskNoteDao {
  _$TaskNoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _taskNoteInsertionAdapter = InsertionAdapter(
            database,
            'task_note',
            (TaskNote item) => <String, Object?>{
                  'task_id': item.taskId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _taskNoteUpdateAdapter = UpdateAdapter(
            database,
            'task_note',
            ['id'],
            (TaskNote item) => <String, Object?>{
                  'task_id': item.taskId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _taskNoteDeletionAdapter = DeletionAdapter(
            database,
            'task_note',
            ['id'],
            (TaskNote item) => <String, Object?>{
                  'task_id': item.taskId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TaskNote> _taskNoteInsertionAdapter;

  final UpdateAdapter<TaskNote> _taskNoteUpdateAdapter;

  final DeletionAdapter<TaskNote> _taskNoteDeletionAdapter;

  @override
  Future<List<TaskNote>> findAllTaskNotes() async {
    return _queryAdapter.queryList('SELECT * FROM task_note',
        mapper: (Map<String, Object?> row) => TaskNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            taskId: row['task_id'] as int));
  }

  @override
  Stream<TaskNote?> findTaskNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM task_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TaskNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            taskId: row['task_id'] as int),
        arguments: [id],
        queryableName: 'task_note',
        isView: false);
  }

  @override
  Future<void> insertTaskNote(TaskNote taskNote) async {
    await _taskNoteInsertionAdapter.insert(taskNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTaskNotes(List<TaskNote> taskNote) async {
    await _taskNoteInsertionAdapter.insertList(
        taskNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTaskNote(TaskNote taskNote) async {
    await _taskNoteUpdateAdapter.update(taskNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTaskNote(TaskNote taskNote) async {
    await _taskNoteDeletionAdapter.delete(taskNote);
  }
}

class _$EpisodeNoteDao extends EpisodeNoteDao {
  _$EpisodeNoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _episodeNoteInsertionAdapter = InsertionAdapter(
            database,
            'episode_note',
            (EpisodeNote item) => <String, Object?>{
                  'episode_id': item.episodeId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _episodeNoteUpdateAdapter = UpdateAdapter(
            database,
            'episode_note',
            ['id'],
            (EpisodeNote item) => <String, Object?>{
                  'episode_id': item.episodeId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _episodeNoteDeletionAdapter = DeletionAdapter(
            database,
            'episode_note',
            ['id'],
            (EpisodeNote item) => <String, Object?>{
                  'episode_id': item.episodeId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EpisodeNote> _episodeNoteInsertionAdapter;

  final UpdateAdapter<EpisodeNote> _episodeNoteUpdateAdapter;

  final DeletionAdapter<EpisodeNote> _episodeNoteDeletionAdapter;

  @override
  Future<List<EpisodeNote>> findAllEpisodeNotes() async {
    return _queryAdapter.queryList('SELECT * FROM episode_note',
        mapper: (Map<String, Object?> row) => EpisodeNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            episodeId: row['episode_id'] as int));
  }

  @override
  Stream<EpisodeNote?> findEpisodeNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM episode_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => EpisodeNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            episodeId: row['episode_id'] as int),
        arguments: [id],
        queryableName: 'episode_note',
        isView: false);
  }

  @override
  Future<void> insertEpisodeNote(EpisodeNote episodeNote) async {
    await _episodeNoteInsertionAdapter.insert(
        episodeNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertEpisodeNotes(List<EpisodeNote> episodeNotes) async {
    await _episodeNoteInsertionAdapter.insertList(
        episodeNotes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEpisodeNote(EpisodeNote episodeNote) async {
    await _episodeNoteUpdateAdapter.update(
        episodeNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEpisodeNote(EpisodeNote episodeNote) async {
    await _episodeNoteDeletionAdapter.delete(episodeNote);
  }
}

class _$BookNoteDao extends BookNoteDao {
  _$BookNoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _bookNoteInsertionAdapter = InsertionAdapter(
            database,
            'book_note',
            (BookNote item) => <String, Object?>{
                  'startPage': item.startPage,
                  'endPage': item.endPage,
                  'book_id': item.bookId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _bookNoteUpdateAdapter = UpdateAdapter(
            database,
            'book_note',
            ['id'],
            (BookNote item) => <String, Object?>{
                  'startPage': item.startPage,
                  'endPage': item.endPage,
                  'book_id': item.bookId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener),
        _bookNoteDeletionAdapter = DeletionAdapter(
            database,
            'book_note',
            ['id'],
            (BookNote item) => <String, Object?>{
                  'startPage': item.startPage,
                  'endPage': item.endPage,
                  'book_id': item.bookId,
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'date': _dateTimeConverter.encode(item.date)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BookNote> _bookNoteInsertionAdapter;

  final UpdateAdapter<BookNote> _bookNoteUpdateAdapter;

  final DeletionAdapter<BookNote> _bookNoteDeletionAdapter;

  @override
  Future<List<BookNote>> findAllBookNotes() async {
    return _queryAdapter.queryList('SELECT * FROM book_note',
        mapper: (Map<String, Object?> row) => BookNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            startPage: row['startPage'] as int,
            endPage: row['endPage'] as int,
            bookId: row['book_id'] as int));
  }

  @override
  Stream<BookNote?> findBookNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM book_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BookNote(
            id: row['id'] as int?,
            title: row['title'] as String,
            content: row['content'] as String,
            date: _dateTimeConverter.decode(row['date'] as int),
            startPage: row['startPage'] as int,
            endPage: row['endPage'] as int,
            bookId: row['book_id'] as int),
        arguments: [id],
        queryableName: 'book_note',
        isView: false);
  }

  @override
  Future<void> insertBookNote(BookNote bookNote) async {
    await _bookNoteInsertionAdapter.insert(bookNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertBookNotes(List<BookNote> bookNotes) async {
    await _bookNoteInsertionAdapter.insertList(
        bookNotes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBookNote(BookNote bookNote) async {
    await _bookNoteUpdateAdapter.update(bookNote, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBookNote(BookNote bookNote) async {
    await _bookNoteDeletionAdapter.delete(bookNote);
  }
}

class _$UserBadgeDao extends UserBadgeDao {
  _$UserBadgeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userBadgeInsertionAdapter = InsertionAdapter(
            database,
            'user_badge',
            (UserBadge item) => <String, Object?>{
                  'user_id': item.userId,
                  'badge_id': item.badgeId
                }),
        _userBadgeUpdateAdapter = UpdateAdapter(
            database,
            'user_badge',
            ['user_id', 'badge_id'],
            (UserBadge item) => <String, Object?>{
                  'user_id': item.userId,
                  'badge_id': item.badgeId
                }),
        _userBadgeDeletionAdapter = DeletionAdapter(
            database,
            'user_badge',
            ['user_id', 'badge_id'],
            (UserBadge item) => <String, Object?>{
                  'user_id': item.userId,
                  'badge_id': item.badgeId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserBadge> _userBadgeInsertionAdapter;

  final UpdateAdapter<UserBadge> _userBadgeUpdateAdapter;

  final DeletionAdapter<UserBadge> _userBadgeDeletionAdapter;

  @override
  Future<List<UserBadge>> findAllUserBadges() async {
    return _queryAdapter.queryList('SELECT * FROM user_badge',
        mapper: (Map<String, Object?> row) => UserBadge(
            userId: row['user_id'] as int, badgeId: row['badge_id'] as int));
  }

  @override
  Future<UserBadge?> findUserBadgeByIds(
    int userId,
    int badgeId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM user_badge WHERE user_id = ?1 AND badge_id = ?2',
        mapper: (Map<String, Object?> row) => UserBadge(
            userId: row['user_id'] as int, badgeId: row['badge_id'] as int),
        arguments: [userId, badgeId]);
  }

  @override
  Future<List<UserBadge>> findUserBadgesByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM user_badge WHERE user_id = ?1',
        mapper: (Map<String, Object?> row) => UserBadge(
            userId: row['user_id'] as int, badgeId: row['badge_id'] as int),
        arguments: [userId]);
  }

  @override
  Future<List<UserBadge>> findUserBadgesByBadgeId(int badgeId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM user_badge WHERE badge_id = ?1',
        mapper: (Map<String, Object?> row) => UserBadge(
            userId: row['user_id'] as int, badgeId: row['badge_id'] as int),
        arguments: [badgeId]);
  }

  @override
  Future<void> insertUserBadge(UserBadge userBadge) async {
    await _userBadgeInsertionAdapter.insert(
        userBadge, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertUserBadges(List<UserBadge> userBadges) async {
    await _userBadgeInsertionAdapter.insertList(
        userBadges, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUserBadge(UserBadge userBadge) async {
    await _userBadgeUpdateAdapter.update(userBadge, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUserBadge(UserBadge userBadge) async {
    await _userBadgeDeletionAdapter.delete(userBadge);
  }
}

class _$BadgeDao extends BadgeDao {
  _$BadgeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _badgeInsertionAdapter = InsertionAdapter(
            database,
            'badge',
            (Badge item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'imagePath': item.imagePath
                }),
        _badgeUpdateAdapter = UpdateAdapter(
            database,
            'badge',
            ['id'],
            (Badge item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'imagePath': item.imagePath
                }),
        _badgeDeletionAdapter = DeletionAdapter(
            database,
            'badge',
            ['id'],
            (Badge item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'imagePath': item.imagePath
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Badge> _badgeInsertionAdapter;

  final UpdateAdapter<Badge> _badgeUpdateAdapter;

  final DeletionAdapter<Badge> _badgeDeletionAdapter;

  @override
  Future<List<Badge>> findAllBadges() async {
    return _queryAdapter.queryList('SELECT * FROM badge',
        mapper: (Map<String, Object?> row) => Badge(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            imagePath: row['imagePath'] as String));
  }

  @override
  Future<Badge?> findBadgeById(int id) async {
    return _queryAdapter.query('SELECT * FROM badge WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Badge(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            imagePath: row['imagePath'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertBadge(Badge badge) async {
    await _badgeInsertionAdapter.insert(badge, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBadge(Badge badge) async {
    await _badgeUpdateAdapter.update(badge, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBadge(Badge badge) async {
    await _badgeDeletionAdapter.delete(badge);
  }
}

class _$MoodDao extends MoodDao {
  _$MoodDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _moodInsertionAdapter = InsertionAdapter(
            database,
            'mood',
            (Mood item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'mood': item.mood.index,
                  'date': _dateTimeConverter.encode(item.date),
                  'user_id': item.userId
                }),
        _moodUpdateAdapter = UpdateAdapter(
            database,
            'mood',
            ['id'],
            (Mood item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'mood': item.mood.index,
                  'date': _dateTimeConverter.encode(item.date),
                  'user_id': item.userId
                }),
        _moodDeletionAdapter = DeletionAdapter(
            database,
            'mood',
            ['id'],
            (Mood item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'mood': item.mood.index,
                  'date': _dateTimeConverter.encode(item.date),
                  'user_id': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Mood> _moodInsertionAdapter;

  final UpdateAdapter<Mood> _moodUpdateAdapter;

  final DeletionAdapter<Mood> _moodDeletionAdapter;

  @override
  Future<List<Mood>> findAllMoods() async {
    return _queryAdapter.queryList('SELECT * FROM mood',
        mapper: (Map<String, Object?> row) => Mood(
            id: row['id'] as int?,
            name: row['name'] as String,
            mood: Emoji.values[row['mood'] as int],
            date: _dateTimeConverter.decode(row['date'] as int),
            userId: row['user_id'] as int));
  }

  @override
  Future<Mood?> findMoodById(int id) async {
    return _queryAdapter.query('SELECT * FROM mood WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Mood(
            id: row['id'] as int?,
            name: row['name'] as String,
            mood: Emoji.values[row['mood'] as int],
            date: _dateTimeConverter.decode(row['date'] as int),
            userId: row['user_id'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertMood(Mood mood) async {
    await _moodInsertionAdapter.insert(mood, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMood(Mood mood) async {
    await _moodUpdateAdapter.update(mood, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMood(Mood mood) async {
    await _moodDeletionAdapter.delete(mood);
  }
}

class _$TimeslotDao extends TimeslotDao {
  _$TimeslotDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _timeslotInsertionAdapter = InsertionAdapter(
            database,
            'timeslot',
            (Timeslot item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                }),
        _timeslotUpdateAdapter = UpdateAdapter(
            database,
            'timeslot',
            ['id'],
            (Timeslot item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                }),
        _timeslotDeletionAdapter = DeletionAdapter(
            database,
            'timeslot',
            ['id'],
            (Timeslot item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Timeslot> _timeslotInsertionAdapter;

  final UpdateAdapter<Timeslot> _timeslotUpdateAdapter;

  final DeletionAdapter<Timeslot> _timeslotDeletionAdapter;

  @override
  Future<List<Timeslot>> findAllTimeslot() async {
    return _queryAdapter.queryList('SELECT * FROM timeslot',
        mapper: (Map<String, Object?> row) => Timeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int));
  }

  @override
  Future<Timeslot?> findTimeslotById(int id) async {
    return _queryAdapter.query('SELECT * FROM timeslot WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Timeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertTimeslot(Timeslot timeslot) async {
    await _timeslotInsertionAdapter.insert(timeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTimeslots(Timeslot timeslots) async {
    await _timeslotInsertionAdapter.insert(timeslots, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTimeslot(Timeslot timeslot) async {
    await _timeslotUpdateAdapter.update(timeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTimeslot(Timeslot timeslot) async {
    await _timeslotDeletionAdapter.delete(timeslot);
  }
}

class _$MediaTimeslotDao extends MediaTimeslotDao {
  _$MediaTimeslotDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _mediaTimeslotInsertionAdapter = InsertionAdapter(
            database,
            'media_timeslot',
            (MediaTimeslot item) => <String, Object?>{
                  'media': item.mediaId,
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                }),
        _mediaTimeslotUpdateAdapter = UpdateAdapter(
            database,
            'media_timeslot',
            ['id'],
            (MediaTimeslot item) => <String, Object?>{
                  'media': item.mediaId,
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                }),
        _mediaTimeslotDeletionAdapter = DeletionAdapter(
            database,
            'media_timeslot',
            ['id'],
            (MediaTimeslot item) => <String, Object?>{
                  'media': item.mediaId,
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MediaTimeslot> _mediaTimeslotInsertionAdapter;

  final UpdateAdapter<MediaTimeslot> _mediaTimeslotUpdateAdapter;

  final DeletionAdapter<MediaTimeslot> _mediaTimeslotDeletionAdapter;

  @override
  Future<List<MediaTimeslot>> findAllMediaTimeslots() async {
    return _queryAdapter.queryList('SELECT * FROM media_timeslot',
        mapper: (Map<String, Object?> row) => MediaTimeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int,
            mediaId: row['media'] as int));
  }

  @override
  Future<MediaTimeslot?> findMediaTimeslotById(int id) async {
    return _queryAdapter.query('SELECT * FROM media_timeslot WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MediaTimeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int,
            mediaId: row['media'] as int),
        arguments: [id]);
  }

  @override
  Future<List<MediaTimeslot>> findMediaTimeslotsByMediaId(int mediaId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM media_timeslot WHERE mediaId = ?1',
        mapper: (Map<String, Object?> row) => MediaTimeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int,
            mediaId: row['media'] as int),
        arguments: [mediaId]);
  }

  @override
  Future<MediaTimeslot?> findMediaTimeslotByMediaIdAndTimeslotId(
    int mediaId,
    int timeslotId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM media_timeslot WHERE mediaId = ?1 AND timeslotId = ?2',
        mapper: (Map<String, Object?> row) => MediaTimeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int,
            mediaId: row['media'] as int),
        arguments: [mediaId, timeslotId]);
  }

  @override
  Future<List<MediaTimeslot>> findMediaTimeslotsByTimeslotId(
      int timeslotId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM media_timeslot WHERE timeslotId = ?1',
        mapper: (Map<String, Object?> row) => MediaTimeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int,
            mediaId: row['media'] as int),
        arguments: [timeslotId]);
  }

  @override
  Future<void> insertMediaTimeslot(MediaTimeslot mediaTimeslot) async {
    await _mediaTimeslotInsertionAdapter.insert(
        mediaTimeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMediaTimeslots(List<MediaTimeslot> mediaTimeslots) async {
    await _mediaTimeslotInsertionAdapter.insertList(
        mediaTimeslots, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMediaTimeslot(MediaTimeslot mediaTimeslot) async {
    await _mediaTimeslotUpdateAdapter.update(
        mediaTimeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMediaTimeslots(List<MediaTimeslot> mediaTimeslots) async {
    await _mediaTimeslotUpdateAdapter.updateList(
        mediaTimeslots, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMediaTimeslot(MediaTimeslot mediaTimeslot) async {
    await _mediaTimeslotDeletionAdapter.delete(mediaTimeslot);
  }

  @override
  Future<void> deleteMediaTimeslots(List<MediaTimeslot> mediaTimeslots) async {
    await _mediaTimeslotDeletionAdapter.deleteList(mediaTimeslots);
  }
}

class _$StudentTimeslotDao extends StudentTimeslotDao {
  _$StudentTimeslotDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _studentTimeslotInsertionAdapter = InsertionAdapter(
            database,
            'student_timeslot',
            (StudentTimeslot item) => <String, Object?>{
                  'task': item.taskId,
                  'evaluation': item.evaluationId,
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                }),
        _studentTimeslotUpdateAdapter = UpdateAdapter(
            database,
            'student_timeslot',
            ['id'],
            (StudentTimeslot item) => <String, Object?>{
                  'task': item.taskId,
                  'evaluation': item.evaluationId,
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                }),
        _studentTimeslotDeletionAdapter = DeletionAdapter(
            database,
            'student_timeslot',
            ['id'],
            (StudentTimeslot item) => <String, Object?>{
                  'task': item.taskId,
                  'evaluation': item.evaluationId,
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'periodicity': item.periodicity.index,
                  'startDateTime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'endDateTime': _dateTimeConverter.encode(item.endDateTime),
                  'priority': item.priority.index,
                  'xp': item.xp,
                  'user_id': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StudentTimeslot> _studentTimeslotInsertionAdapter;

  final UpdateAdapter<StudentTimeslot> _studentTimeslotUpdateAdapter;

  final DeletionAdapter<StudentTimeslot> _studentTimeslotDeletionAdapter;

  @override
  Future<List<StudentTimeslot>> findAllStudentTimeslot() async {
    return _queryAdapter.queryList('SELECT * FROM student_timeslot',
        mapper: (Map<String, Object?> row) => StudentTimeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int,
            taskId: row['task'] as int?,
            evaluationId: row['evaluation'] as int?));
  }

  @override
  Future<StudentTimeslot?> findStudentTimeslotById(int id) async {
    return _queryAdapter.query('SELECT * FROM student_timeslot WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StudentTimeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            periodicity: Periodicity.values[row['periodicity'] as int],
            startDateTime:
                _dateTimeConverter.decode(row['startDateTime'] as int),
            endDateTime: _dateTimeConverter.decode(row['endDateTime'] as int),
            priority: Priority.values[row['priority'] as int],
            xp: row['xp'] as int,
            userId: row['user_id'] as int,
            taskId: row['task'] as int?,
            evaluationId: row['evaluation'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> insertStudentTimeslot(StudentTimeslot studentTimeslot) async {
    await _studentTimeslotInsertionAdapter.insert(
        studentTimeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudentTimeslot(StudentTimeslot studentTimeslot) async {
    await _studentTimeslotUpdateAdapter.update(
        studentTimeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStudentTimeslot(StudentTimeslot studentTimeslot) async {
    await _studentTimeslotDeletionAdapter.delete(studentTimeslot);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'user',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'xp': item.xp
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'user',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'xp': item.xp
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'user',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'password': item.password,
                  'xp': item.xp
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM user',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userName: row['userName'] as String,
            password: row['password'] as String,
            xp: row['xp'] as int));
  }

  @override
  Future<User?> findUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM user WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userName: row['userName'] as String,
            password: row['password'] as String,
            xp: row['xp'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
