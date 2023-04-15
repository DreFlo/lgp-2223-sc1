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

  StudentEvaluationDao? _evaluationDaoInstance;

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
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `institution` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `picture` TEXT, `type` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subject` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `acronym` TEXT NOT NULL, `weight_average` REAL NOT NULL, `institution_id` INTEGER, FOREIGN KEY (`institution_id`) REFERENCES `institution` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task_group` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `task_group_id` INTEGER NOT NULL, `subject_id` INTEGER, FOREIGN KEY (`task_group_id`) REFERENCES `task_group` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `evaluation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `weight` REAL NOT NULL, `minimum` REAL NOT NULL, `grade` REAL NOT NULL, `subject_id` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `media` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `link_image` TEXT NOT NULL, `status` INTEGER NOT NULL, `favorite` INTEGER NOT NULL, `genres` TEXT NOT NULL, `release` INTEGER NOT NULL, `xp` INTEGER NOT NULL, `participants` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `book` (`id` INTEGER NOT NULL, `total_pages` INTEGER NOT NULL, `progress_pages` INTEGER, FOREIGN KEY (`id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `series` (`id` INTEGER NOT NULL, `tagline` TEXT NOT NULL, `number_episodes` INTEGER NOT NULL, `number_seasons` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `video` (`id` INTEGER NOT NULL, `duration` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `media` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `season` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `number` INTEGER NOT NULL, `series_id` INTEGER NOT NULL, FOREIGN KEY (`series_id`) REFERENCES `series` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `review` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `start_date` INTEGER NOT NULL, `end_date` INTEGER NOT NULL, `review` TEXT NOT NULL, `emoji` INTEGER NOT NULL, `media_id` INTEGER NOT NULL, FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movie` (`id` INTEGER NOT NULL, `tagline` TEXT NOT NULL, FOREIGN KEY (`id`) REFERENCES `video` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `episode` (`id` INTEGER NOT NULL, `number` INTEGER NOT NULL, `season_id` INTEGER NOT NULL, FOREIGN KEY (`id`) REFERENCES `video` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, FOREIGN KEY (`season_id`) REFERENCES `season` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `note` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subject_note` (`id` INTEGER NOT NULL, `subject_id` INTEGER NOT NULL, FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `task_note` (`id` INTEGER NOT NULL, `task_id` INTEGER NOT NULL, FOREIGN KEY (`task_id`) REFERENCES `task` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `episode_note` (`id` INTEGER NOT NULL, `episode_id` INTEGER NOT NULL, FOREIGN KEY (`episode_id`) REFERENCES `episode` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `book_note` (`id` INTEGER NOT NULL, `start_page` INTEGER NOT NULL, `end_page` INTEGER NOT NULL, `book_id` INTEGER NOT NULL, FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`id`) REFERENCES `note` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_name` TEXT NOT NULL, `password` TEXT NOT NULL, `xp` INTEGER NOT NULL, `image_path` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `badge` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `image_path` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mood` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `mood` INTEGER NOT NULL, `date` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `timeslot` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `start_datetime` INTEGER NOT NULL, `end_datetime` INTEGER NOT NULL, `xp_multiplier` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `media_timeslot` (`id` INTEGER NOT NULL, `media_id` TEXT NOT NULL, FOREIGN KEY (`id`) REFERENCES `timeslot` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `student_timeslot` (`id` INTEGER NOT NULL, `task_id` TEXT NOT NULL, FOREIGN KEY (`id`) REFERENCES `timeslot` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user_badge` (`user_id` INTEGER NOT NULL, `badge_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, FOREIGN KEY (`badge_id`) REFERENCES `badge` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE, PRIMARY KEY (`user_id`, `badge_id`))');

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
  StudentEvaluationDao get evaluationDao {
    return _evaluationDaoInstance ??=
        _$StudentEvaluationDao(database, changeListener);
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
            type: InstitutionType.values[row['type'] as int],
            userId: row['user_id'] as int,
            picture: row['picture'] as String?));
  }

  @override
  Stream<Institution?> findInstitutionById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM institution WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Institution(
            id: row['id'] as int?,
            name: row['name'] as String,
            type: InstitutionType.values[row['type'] as int],
            userId: row['user_id'] as int,
            picture: row['picture'] as String?),
        arguments: [id],
        queryableName: 'institution',
        isView: false);
  }

  @override
  Future<int> insertInstitution(Institution institution) {
    return _institutionInsertionAdapter.insertAndReturnId(
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
  Future<void> updateInstitutions(List<Institution> institutions) async {
    await _institutionUpdateAdapter.updateList(
        institutions, OnConflictStrategy.abort);
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
                  'acronym': item.acronym,
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
                  'acronym': item.acronym,
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
                  'acronym': item.acronym,
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
            acronym: row['acronym'] as String,
            weightAverage: row['weight_average'] as double,
            institutionId: row['institution_id'] as int?));
  }

  @override
  Stream<Subject?> findSubjectById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM subject WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            acronym: row['acronym'] as String,
            weightAverage: row['weight_average'] as double,
            institutionId: row['institution_id'] as int?),
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
            acronym: row['acronym'] as String,
            weightAverage: row['weight_average'] as double,
            institutionId: row['institution_id'] as int?),
        arguments: [id],
        queryableName: 'subject',
        isView: false);
  }

  @override
  Future<int> insertSubject(Subject subject) {
    return _subjectInsertionAdapter.insertAndReturnId(
        subject, OnConflictStrategy.abort);
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
  Future<void> updateSubjects(List<Subject> subjects) async {
    await _subjectUpdateAdapter.updateList(subjects, OnConflictStrategy.abort);
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
                  'deadline': _dateTimeConverter.encode(item.deadline)
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
                  'deadline': _dateTimeConverter.encode(item.deadline)
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
                  'deadline': _dateTimeConverter.encode(item.deadline)
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
            deadline: _dateTimeConverter.decode(row['deadline'] as int)));
  }

  @override
  Stream<TaskGroup?> findTaskGroupById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM task_group WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TaskGroup(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            priority: Priority.values[row['priority'] as int],
            deadline: _dateTimeConverter.decode(row['deadline'] as int)),
        arguments: [id],
        queryableName: 'task_group',
        isView: false);
  }

  @override
  Future<int> insertTaskGroup(TaskGroup taskGroup) {
    return _taskGroupInsertionAdapter.insertAndReturnId(
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
  Future<void> updateTaskGroups(List<TaskGroup> taskGroups) async {
    await _taskGroupUpdateAdapter.updateList(
        taskGroups, OnConflictStrategy.abort);
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
                  'xp': item.xp,
                  'task_group_id': item.taskGroupId,
                  'subject_id': item.subjectId
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
                  'xp': item.xp,
                  'task_group_id': item.taskGroupId,
                  'subject_id': item.subjectId
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
                  'xp': item.xp,
                  'task_group_id': item.taskGroupId,
                  'subject_id': item.subjectId
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
            taskGroupId: row['task_group_id'] as int,
            subjectId: row['subject_id'] as int?,
            xp: row['xp'] as int));
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
            taskGroupId: row['task_group_id'] as int,
            subjectId: row['subject_id'] as int?,
            xp: row['xp'] as int),
        arguments: [id],
        queryableName: 'task',
        isView: false);
  }

  @override
  Future<int> insertTask(Task task) {
    return _taskInsertionAdapter.insertAndReturnId(
        task, OnConflictStrategy.abort);
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
  Future<void> updateTasks(List<Task> tasks) async {
    await _taskUpdateAdapter.updateList(tasks, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _taskDeletionAdapter.delete(task);
  }
}

class _$StudentEvaluationDao extends StudentEvaluationDao {
  _$StudentEvaluationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _studentEvaluationInsertionAdapter = InsertionAdapter(
            database,
            'evaluation',
            (StudentEvaluation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'weight': item.weight,
                  'minimum': item.minimum,
                  'grade': item.grade,
                  'subject_id': item.subjectId
                },
            changeListener),
        _studentEvaluationUpdateAdapter = UpdateAdapter(
            database,
            'evaluation',
            ['id'],
            (StudentEvaluation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'weight': item.weight,
                  'minimum': item.minimum,
                  'grade': item.grade,
                  'subject_id': item.subjectId
                },
            changeListener),
        _studentEvaluationDeletionAdapter = DeletionAdapter(
            database,
            'evaluation',
            ['id'],
            (StudentEvaluation item) => <String, Object?>{
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

  final InsertionAdapter<StudentEvaluation> _studentEvaluationInsertionAdapter;

  final UpdateAdapter<StudentEvaluation> _studentEvaluationUpdateAdapter;

  final DeletionAdapter<StudentEvaluation> _studentEvaluationDeletionAdapter;

  @override
  Future<List<StudentEvaluation>> findAllStudentEvaluations() async {
    return _queryAdapter.queryList('SELECT * FROM evaluation',
        mapper: (Map<String, Object?> row) => StudentEvaluation(
            id: row['id'] as int?,
            name: row['name'] as String,
            grade: row['grade'] as double,
            weight: row['weight'] as double,
            minimum: row['minimum'] as double,
            subjectId: row['subject_id'] as int));
  }

  @override
  Stream<StudentEvaluation?> findStudentEvaluationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM evaluation WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StudentEvaluation(
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
  Future<int> insertStudentEvaluation(StudentEvaluation evaluation) {
    return _studentEvaluationInsertionAdapter.insertAndReturnId(
        evaluation, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertStudentEvaluations(
      List<StudentEvaluation> evaluations) async {
    await _studentEvaluationInsertionAdapter.insertList(
        evaluations, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudentEvaluation(StudentEvaluation evaluation) async {
    await _studentEvaluationUpdateAdapter.update(
        evaluation, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudentEvaluations(
      List<StudentEvaluation> evaluations) async {
    await _studentEvaluationUpdateAdapter.updateList(
        evaluations, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStudentEvaluation(StudentEvaluation evaluation) async {
    await _studentEvaluationDeletionAdapter.delete(evaluation);
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
                  'favorite': item.favorite ? 1 : 0,
                  'genres': item.genres,
                  'release': _dateTimeConverter.encode(item.release),
                  'xp': item.xp,
                  'participants': item.participants
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
                  'favorite': item.favorite ? 1 : 0,
                  'genres': item.genres,
                  'release': _dateTimeConverter.encode(item.release),
                  'xp': item.xp,
                  'participants': item.participants
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
                  'favorite': item.favorite ? 1 : 0,
                  'genres': item.genres,
                  'release': _dateTimeConverter.encode(item.release),
                  'xp': item.xp,
                  'participants': item.participants
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
            favorite: (row['favorite'] as int) != 0,
            genres: row['genres'] as String,
            release: _dateTimeConverter.decode(row['release'] as int),
            xp: row['xp'] as int,
            participants: row['participants'] as String));
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
            favorite: (row['favorite'] as int) != 0,
            genres: row['genres'] as String,
            release: _dateTimeConverter.decode(row['release'] as int),
            xp: row['xp'] as int,
            participants: row['participants'] as String),
        arguments: [id],
        queryableName: 'media',
        isView: false);
  }

  @override
  Future<int> insertMedia(Media media) {
    return _mediaInsertionAdapter.insertAndReturnId(
        media, OnConflictStrategy.abort);
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
  Future<void> updateMedias(List<Media> medias) async {
    await _mediaUpdateAdapter.updateList(medias, OnConflictStrategy.abort);
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
                  'id': item.id,
                  'total_pages': item.totalPages,
                  'progress_pages': item.progressPages
                },
            changeListener),
        _bookUpdateAdapter = UpdateAdapter(
            database,
            'book',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'total_pages': item.totalPages,
                  'progress_pages': item.progressPages
                },
            changeListener),
        _bookDeletionAdapter = DeletionAdapter(
            database,
            'book',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'total_pages': item.totalPages,
                  'progress_pages': item.progressPages
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Book> _bookInsertionAdapter;

  final UpdateAdapter<Book> _bookUpdateAdapter;

  final DeletionAdapter<Book> _bookDeletionAdapter;

  @override
  Future<List<Book>> findAllBooks() async {
    return _queryAdapter.queryList('SELECT * FROM book',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int,
            totalPages: row['total_pages'] as int,
            progressPages: row['progress_pages'] as int?));
  }

  @override
  Stream<Book?> findBookById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM book WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int,
            totalPages: row['total_pages'] as int,
            progressPages: row['progress_pages'] as int?),
        arguments: [id],
        queryableName: 'book',
        isView: false);
  }

  @override
  Future<int> insertBook(Book book) {
    return _bookInsertionAdapter.insertAndReturnId(
        book, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertBooks(List<Book> books) async {
    await _bookInsertionAdapter.insertList(books, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBook(Book book) async {
    await _bookUpdateAdapter.update(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBooks(List<Book> books) async {
    await _bookUpdateAdapter.updateList(books, OnConflictStrategy.abort);
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
                  'tagline': item.tagline,
                  'number_episodes': item.numberEpisodes,
                  'number_seasons': item.numberSeasons
                },
            changeListener),
        _seriesUpdateAdapter = UpdateAdapter(
            database,
            'series',
            ['id'],
            (Series item) => <String, Object?>{
                  'id': item.id,
                  'tagline': item.tagline,
                  'number_episodes': item.numberEpisodes,
                  'number_seasons': item.numberSeasons
                },
            changeListener),
        _seriesDeletionAdapter = DeletionAdapter(
            database,
            'series',
            ['id'],
            (Series item) => <String, Object?>{
                  'id': item.id,
                  'tagline': item.tagline,
                  'number_episodes': item.numberEpisodes,
                  'number_seasons': item.numberSeasons
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
            id: row['id'] as int,
            tagline: row['tagline'] as String,
            numberEpisodes: row['number_episodes'] as int,
            numberSeasons: row['number_seasons'] as int));
  }

  @override
  Stream<Series?> findSeriesById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM series WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Series(
            id: row['id'] as int,
            tagline: row['tagline'] as String,
            numberEpisodes: row['number_episodes'] as int,
            numberSeasons: row['number_seasons'] as int),
        arguments: [id],
        queryableName: 'series',
        isView: false);
  }

  @override
  Future<int> insertSerie(Series series) {
    return _seriesInsertionAdapter.insertAndReturnId(
        series, OnConflictStrategy.abort);
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
            (Video item) =>
                <String, Object?>{'id': item.id, 'duration': item.duration},
            changeListener),
        _videoUpdateAdapter = UpdateAdapter(
            database,
            'video',
            ['id'],
            (Video item) =>
                <String, Object?>{'id': item.id, 'duration': item.duration},
            changeListener),
        _videoDeletionAdapter = DeletionAdapter(
            database,
            'video',
            ['id'],
            (Video item) =>
                <String, Object?>{'id': item.id, 'duration': item.duration},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Video> _videoInsertionAdapter;

  final UpdateAdapter<Video> _videoUpdateAdapter;

  final DeletionAdapter<Video> _videoDeletionAdapter;

  @override
  Future<List<Video>> findAllVideos() async {
    return _queryAdapter.queryList('SELECT * FROM Video',
        mapper: (Map<String, Object?> row) =>
            Video(id: row['id'] as int, duration: row['duration'] as int));
  }

  @override
  Stream<Video?> findVideoById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Video WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Video(id: row['id'] as int, duration: row['duration'] as int),
        arguments: [id],
        queryableName: 'Video',
        isView: false);
  }

  @override
  Future<List<int>> findVideoDurationById(int id) async {
    return _queryAdapter.queryList('SELECT duration FROM Video WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int> insertVideo(Video video) {
    return _videoInsertionAdapter.insertAndReturnId(
        video, OnConflictStrategy.abort);
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
  Future<void> updateVideos(List<Video> video) async {
    await _videoUpdateAdapter.updateList(video, OnConflictStrategy.abort);
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
  Future<int> insertSeason(Season season) {
    return _seasonInsertionAdapter.insertAndReturnId(
        season, OnConflictStrategy.abort);
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
            emoji: Reaction.values[row['emoji'] as int],
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
            emoji: Reaction.values[row['emoji'] as int],
            mediaId: row['media_id'] as int),
        arguments: [id],
        queryableName: 'review',
        isView: false);
  }

  @override
  Future<int?> countReviewsByMediaId(int mediaId) async {
    return _queryAdapter.query('SELECT COUNT() FROM review WHERE media_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [mediaId]);
  }

  @override
  Stream<Review?> findReviewByMediaId(int mediaId) {
    return _queryAdapter.queryStream('SELECT * FROM review WHERE media_id = ?1',
        mapper: (Map<String, Object?> row) => Review(
            id: row['id'] as int?,
            startDate: _dateTimeConverter.decode(row['start_date'] as int),
            endDate: _dateTimeConverter.decode(row['end_date'] as int),
            review: row['review'] as String,
            emoji: Reaction.values[row['emoji'] as int],
            mediaId: row['media_id'] as int),
        arguments: [mediaId],
        queryableName: 'review',
        isView: false);
  }

  @override
  Future<int> insertReview(Review review) {
    return _reviewInsertionAdapter.insertAndReturnId(
        review, OnConflictStrategy.abort);
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
  Future<void> updateReviews(List<Review> reviews) async {
    await _reviewUpdateAdapter.updateList(reviews, OnConflictStrategy.abort);
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
            (Movie item) =>
                <String, Object?>{'id': item.id, 'tagline': item.tagline},
            changeListener),
        _movieUpdateAdapter = UpdateAdapter(
            database,
            'movie',
            ['id'],
            (Movie item) =>
                <String, Object?>{'id': item.id, 'tagline': item.tagline},
            changeListener),
        _movieDeletionAdapter = DeletionAdapter(
            database,
            'movie',
            ['id'],
            (Movie item) =>
                <String, Object?>{'id': item.id, 'tagline': item.tagline},
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
        mapper: (Map<String, Object?> row) =>
            Movie(id: row['id'] as int, tagline: row['tagline'] as String));
  }

  @override
  Stream<Movie?> findMovieById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM movie WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Movie(id: row['id'] as int, tagline: row['tagline'] as String),
        arguments: [id],
        queryableName: 'movie',
        isView: false);
  }

  @override
  Future<int> insertMovie(Movie movie) {
    return _movieInsertionAdapter.insertAndReturnId(
        movie, OnConflictStrategy.abort);
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
  Future<void> updateMovies(List<Movie> movie) async {
    await _movieUpdateAdapter.updateList(movie, OnConflictStrategy.abort);
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
                  'id': item.id,
                  'number': item.number,
                  'season_id': item.seasonId
                },
            changeListener),
        _episodeUpdateAdapter = UpdateAdapter(
            database,
            'episode',
            ['id'],
            (Episode item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'season_id': item.seasonId
                },
            changeListener),
        _episodeDeletionAdapter = DeletionAdapter(
            database,
            'episode',
            ['id'],
            (Episode item) => <String, Object?>{
                  'id': item.id,
                  'number': item.number,
                  'season_id': item.seasonId
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
            id: row['id'] as int,
            number: row['number'] as int,
            seasonId: row['season_id'] as int));
  }

  @override
  Stream<Episode?> findEpisodeById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM episode WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Episode(
            id: row['id'] as int,
            number: row['number'] as int,
            seasonId: row['season_id'] as int),
        arguments: [id],
        queryableName: 'episode',
        isView: false);
  }

  @override
  Future<List<int>> findEpisodeBySeasonId(int id) async {
    return _queryAdapter.queryList(
        'SELECT id FROM episode WHERE season_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int> insertEpisode(Episode episode) {
    return _episodeInsertionAdapter.insertAndReturnId(
        episode, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertEpisodes(List<Episode> episodes) async {
    await _episodeInsertionAdapter.insertList(
        episodes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEpisode(Episode episode) async {
    await _episodeUpdateAdapter.update(episode, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEpisodes(List<Episode> episodes) async {
    await _episodeUpdateAdapter.updateList(episodes, OnConflictStrategy.abort);
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
  Future<int> insertNote(Note note) {
    return _noteInsertionAdapter.insertAndReturnId(
        note, OnConflictStrategy.abort);
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
  Future<void> updateNotes(List<Note> notes) async {
    await _noteUpdateAdapter.updateList(notes, OnConflictStrategy.abort);
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
            (SubjectNote item) =>
                <String, Object?>{'id': item.id, 'subject_id': item.subjectId},
            changeListener),
        _subjectNoteUpdateAdapter = UpdateAdapter(
            database,
            'subject_note',
            ['id'],
            (SubjectNote item) =>
                <String, Object?>{'id': item.id, 'subject_id': item.subjectId},
            changeListener),
        _subjectNoteDeletionAdapter = DeletionAdapter(
            database,
            'subject_note',
            ['id'],
            (SubjectNote item) =>
                <String, Object?>{'id': item.id, 'subject_id': item.subjectId},
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
            id: row['id'] as int, subjectId: row['subject_id'] as int));
  }

  @override
  Stream<SubjectNote?> findSubjectNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM subject_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SubjectNote(
            id: row['id'] as int, subjectId: row['subject_id'] as int),
        arguments: [id],
        queryableName: 'subject_note',
        isView: false);
  }

  @override
  Future<int> insertSubjectNote(SubjectNote subjectNote) {
    return _subjectNoteInsertionAdapter.insertAndReturnId(
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
            (TaskNote item) =>
                <String, Object?>{'id': item.id, 'task_id': item.taskId},
            changeListener),
        _taskNoteUpdateAdapter = UpdateAdapter(
            database,
            'task_note',
            ['id'],
            (TaskNote item) =>
                <String, Object?>{'id': item.id, 'task_id': item.taskId},
            changeListener),
        _taskNoteDeletionAdapter = DeletionAdapter(
            database,
            'task_note',
            ['id'],
            (TaskNote item) =>
                <String, Object?>{'id': item.id, 'task_id': item.taskId},
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
        mapper: (Map<String, Object?> row) =>
            TaskNote(id: row['id'] as int, taskId: row['task_id'] as int));
  }

  @override
  Stream<TaskNote?> findTaskNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM task_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            TaskNote(id: row['id'] as int, taskId: row['task_id'] as int),
        arguments: [id],
        queryableName: 'task_note',
        isView: false);
  }

  @override
  Future<int> insertTaskNote(TaskNote taskNote) {
    return _taskNoteInsertionAdapter.insertAndReturnId(
        taskNote, OnConflictStrategy.abort);
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
  Future<void> updateTaskNotes(List<TaskNote> taskNote) async {
    await _taskNoteUpdateAdapter.updateList(taskNote, OnConflictStrategy.abort);
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
            (EpisodeNote item) =>
                <String, Object?>{'id': item.id, 'episode_id': item.episodeId},
            changeListener),
        _episodeNoteUpdateAdapter = UpdateAdapter(
            database,
            'episode_note',
            ['id'],
            (EpisodeNote item) =>
                <String, Object?>{'id': item.id, 'episode_id': item.episodeId},
            changeListener),
        _episodeNoteDeletionAdapter = DeletionAdapter(
            database,
            'episode_note',
            ['id'],
            (EpisodeNote item) =>
                <String, Object?>{'id': item.id, 'episode_id': item.episodeId},
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
            id: row['id'] as int, episodeId: row['episode_id'] as int));
  }

  @override
  Stream<EpisodeNote?> findEpisodeNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM episode_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => EpisodeNote(
            id: row['id'] as int, episodeId: row['episode_id'] as int),
        arguments: [id],
        queryableName: 'episode_note',
        isView: false);
  }

  @override
  Future<int> insertEpisodeNote(EpisodeNote episodeNote) {
    return _episodeNoteInsertionAdapter.insertAndReturnId(
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
  Future<void> updateEpisodeNotes(List<EpisodeNote> episodeNotes) async {
    await _episodeNoteUpdateAdapter.updateList(
        episodeNotes, OnConflictStrategy.abort);
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
                  'id': item.id,
                  'start_page': item.startPage,
                  'end_page': item.endPage,
                  'book_id': item.bookId
                },
            changeListener),
        _bookNoteUpdateAdapter = UpdateAdapter(
            database,
            'book_note',
            ['id'],
            (BookNote item) => <String, Object?>{
                  'id': item.id,
                  'start_page': item.startPage,
                  'end_page': item.endPage,
                  'book_id': item.bookId
                },
            changeListener),
        _bookNoteDeletionAdapter = DeletionAdapter(
            database,
            'book_note',
            ['id'],
            (BookNote item) => <String, Object?>{
                  'id': item.id,
                  'start_page': item.startPage,
                  'end_page': item.endPage,
                  'book_id': item.bookId
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
            id: row['id'] as int,
            startPage: row['start_page'] as int,
            endPage: row['end_page'] as int,
            bookId: row['book_id'] as int));
  }

  @override
  Stream<BookNote?> findBookNoteById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM book_note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BookNote(
            id: row['id'] as int,
            startPage: row['start_page'] as int,
            endPage: row['end_page'] as int,
            bookId: row['book_id'] as int),
        arguments: [id],
        queryableName: 'book_note',
        isView: false);
  }

  @override
  Future<List<BookNote>> findBookNoteByBookId(int bookId) async {
    return _queryAdapter.queryList('SELECT * FROM book_note WHERE book_id = ?1',
        mapper: (Map<String, Object?> row) => BookNote(
            id: row['id'] as int,
            startPage: row['start_page'] as int,
            endPage: row['end_page'] as int,
            bookId: row['book_id'] as int),
        arguments: [bookId]);
  }

  @override
  Future<int> insertBookNote(BookNote bookNote) {
    return _bookNoteInsertionAdapter.insertAndReturnId(
        bookNote, OnConflictStrategy.abort);
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
  Future<void> updateBookNotes(List<BookNote> bookNotes) async {
    await _bookNoteUpdateAdapter.updateList(
        bookNotes, OnConflictStrategy.abort);
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
  Future<int> insertUserBadge(UserBadge userBadge) {
    return _userBadgeInsertionAdapter.insertAndReturnId(
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
  Future<void> updateUserBadges(List<UserBadge> userBadges) async {
    await _userBadgeUpdateAdapter.updateList(
        userBadges, OnConflictStrategy.abort);
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
                  'image_path': item.imagePath
                }),
        _badgeUpdateAdapter = UpdateAdapter(
            database,
            'badge',
            ['id'],
            (Badge item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image_path': item.imagePath
                }),
        _badgeDeletionAdapter = DeletionAdapter(
            database,
            'badge',
            ['id'],
            (Badge item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'image_path': item.imagePath
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
            imagePath: row['image_path'] as String));
  }

  @override
  Future<Badge?> findBadgeById(int id) async {
    return _queryAdapter.query('SELECT * FROM badge WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Badge(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            imagePath: row['image_path'] as String),
        arguments: [id]);
  }

  @override
  Future<int> insertBadge(Badge badge) {
    return _badgeInsertionAdapter.insertAndReturnId(
        badge, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertBadges(List<Badge> badges) async {
    await _badgeInsertionAdapter.insertList(badges, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBadge(Badge badge) async {
    await _badgeUpdateAdapter.update(badge, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBadges(List<Badge> badges) async {
    await _badgeUpdateAdapter.updateList(badges, OnConflictStrategy.abort);
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
            mood: Reaction.values[row['mood'] as int],
            date: _dateTimeConverter.decode(row['date'] as int),
            userId: row['user_id'] as int));
  }

  @override
  Future<Mood?> findMoodById(int id) async {
    return _queryAdapter.query('SELECT * FROM mood WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Mood(
            id: row['id'] as int?,
            name: row['name'] as String,
            mood: Reaction.values[row['mood'] as int],
            date: _dateTimeConverter.decode(row['date'] as int),
            userId: row['user_id'] as int),
        arguments: [id]);
  }

  @override
  Future<int> insertMood(Mood mood) {
    return _moodInsertionAdapter.insertAndReturnId(
        mood, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMoods(List<Mood> moods) async {
    await _moodInsertionAdapter.insertList(moods, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMood(Mood mood) async {
    await _moodUpdateAdapter.update(mood, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMoods(List<Mood> moods) async {
    await _moodUpdateAdapter.updateList(moods, OnConflictStrategy.abort);
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
                  'start_datetime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'end_datetime': _dateTimeConverter.encode(item.endDateTime),
                  'xp_multiplier': item.xpMultiplier,
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
                  'start_datetime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'end_datetime': _dateTimeConverter.encode(item.endDateTime),
                  'xp_multiplier': item.xpMultiplier,
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
                  'start_datetime':
                      _dateTimeConverter.encode(item.startDateTime),
                  'end_datetime': _dateTimeConverter.encode(item.endDateTime),
                  'xp_multiplier': item.xpMultiplier,
                  'user_id': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Timeslot> _timeslotInsertionAdapter;

  final UpdateAdapter<Timeslot> _timeslotUpdateAdapter;

  final DeletionAdapter<Timeslot> _timeslotDeletionAdapter;

  @override
  Future<List<Timeslot>> findAllTimeslots() async {
    return _queryAdapter.queryList('SELECT * FROM timeslot',
        mapper: (Map<String, Object?> row) => Timeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            startDateTime:
                _dateTimeConverter.decode(row['start_datetime'] as int),
            endDateTime: _dateTimeConverter.decode(row['end_datetime'] as int),
            xpMultiplier: row['xp_multiplier'] as int,
            userId: row['user_id'] as int));
  }

  @override
  Future<Timeslot?> findTimeslotById(int id) async {
    return _queryAdapter.query('SELECT * FROM timeslot WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Timeslot(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            startDateTime:
                _dateTimeConverter.decode(row['start_datetime'] as int),
            endDateTime: _dateTimeConverter.decode(row['end_datetime'] as int),
            xpMultiplier: row['xp_multiplier'] as int,
            userId: row['user_id'] as int),
        arguments: [id]);
  }

  @override
  Future<int> insertTimeslot(Timeslot timeslot) {
    return _timeslotInsertionAdapter.insertAndReturnId(
        timeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTimeslots(List<Timeslot> timeslots) async {
    await _timeslotInsertionAdapter.insertList(
        timeslots, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTimeslot(Timeslot timeslot) async {
    await _timeslotUpdateAdapter.update(timeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTimeslots(List<Timeslot> timeslots) async {
    await _timeslotUpdateAdapter.updateList(
        timeslots, OnConflictStrategy.abort);
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
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _mediaTimeslotInsertionAdapter = InsertionAdapter(
            database,
            'media_timeslot',
            (MediaTimeslot item) => <String, Object?>{
                  'id': item.id,
                  'media_id': _listConverter.encode(item.mediaId)
                },
            changeListener),
        _mediaTimeslotUpdateAdapter = UpdateAdapter(
            database,
            'media_timeslot',
            ['id'],
            (MediaTimeslot item) => <String, Object?>{
                  'id': item.id,
                  'media_id': _listConverter.encode(item.mediaId)
                },
            changeListener),
        _mediaTimeslotDeletionAdapter = DeletionAdapter(
            database,
            'media_timeslot',
            ['id'],
            (MediaTimeslot item) => <String, Object?>{
                  'id': item.id,
                  'media_id': _listConverter.encode(item.mediaId)
                },
            changeListener);

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
            id: row['id'] as int,
            mediaId: _listConverter.decode(row['media_id'] as String)));
  }

  @override
  Stream<MediaTimeslot?> findMediaTimeslotById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM media_timeslot WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MediaTimeslot(
            id: row['id'] as int,
            mediaId: _listConverter.decode(row['media_id'] as String)),
        arguments: [id],
        queryableName: 'media_timeslot',
        isView: false);
  }

  @override
  Future<int> insertMediaTimeslot(MediaTimeslot mediaTimeslot) {
    return _mediaTimeslotInsertionAdapter.insertAndReturnId(
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
}

class _$StudentTimeslotDao extends StudentTimeslotDao {
  _$StudentTimeslotDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _studentTimeslotInsertionAdapter = InsertionAdapter(
            database,
            'student_timeslot',
            (StudentTimeslot item) => <String, Object?>{
                  'id': item.id,
                  'task_id': _listConverter.encode(item.taskId)
                },
            changeListener),
        _studentTimeslotUpdateAdapter = UpdateAdapter(
            database,
            'student_timeslot',
            ['id'],
            (StudentTimeslot item) => <String, Object?>{
                  'id': item.id,
                  'task_id': _listConverter.encode(item.taskId)
                },
            changeListener),
        _studentTimeslotDeletionAdapter = DeletionAdapter(
            database,
            'student_timeslot',
            ['id'],
            (StudentTimeslot item) => <String, Object?>{
                  'id': item.id,
                  'task_id': _listConverter.encode(item.taskId)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StudentTimeslot> _studentTimeslotInsertionAdapter;

  final UpdateAdapter<StudentTimeslot> _studentTimeslotUpdateAdapter;

  final DeletionAdapter<StudentTimeslot> _studentTimeslotDeletionAdapter;

  @override
  Future<List<StudentTimeslot>> findAllStudentTimeslots() async {
    return _queryAdapter.queryList('SELECT * FROM student_timeslot',
        mapper: (Map<String, Object?> row) => StudentTimeslot(
            id: row['id'] as int,
            taskId: _listConverter.decode(row['task_id'] as String)));
  }

  @override
  Stream<StudentTimeslot?> findStudentTimeslotById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM student_timeslot WHERE id = ?1',
        mapper: (Map<String, Object?> row) => StudentTimeslot(
            id: row['id'] as int,
            taskId: _listConverter.decode(row['task_id'] as String)),
        arguments: [id],
        queryableName: 'student_timeslot',
        isView: false);
  }

  @override
  Future<int> insertStudentTimeslot(StudentTimeslot studentTimeslot) {
    return _studentTimeslotInsertionAdapter.insertAndReturnId(
        studentTimeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertStudentTimeslots(
      List<StudentTimeslot> studentTimeslots) async {
    await _studentTimeslotInsertionAdapter.insertList(
        studentTimeslots, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudentTimeslot(StudentTimeslot studentTimeslot) async {
    await _studentTimeslotUpdateAdapter.update(
        studentTimeslot, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudentTimeslots(
      List<StudentTimeslot> studentTimeslots) async {
    await _studentTimeslotUpdateAdapter.updateList(
        studentTimeslots, OnConflictStrategy.abort);
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
                  'user_name': item.userName,
                  'password': item.password,
                  'xp': item.xp,
                  'image_path': item.imagePath
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'user',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'user_name': item.userName,
                  'password': item.password,
                  'xp': item.xp,
                  'image_path': item.imagePath
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'user',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'user_name': item.userName,
                  'password': item.password,
                  'xp': item.xp,
                  'image_path': item.imagePath
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
            userName: row['user_name'] as String,
            password: row['password'] as String,
            xp: row['xp'] as int,
            imagePath: row['image_path'] as String));
  }

  @override
  Future<User?> findUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM user WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            userName: row['user_name'] as String,
            password: row['password'] as String,
            xp: row['xp'] as int,
            imagePath: row['image_path'] as String),
        arguments: [id]);
  }

  @override
  Future<int> insertUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertUsers(List<User> users) {
    return _userInsertionAdapter.insertListAndReturnIds(
        users, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUsers(List<User> users) async {
    await _userUpdateAdapter.updateList(users, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _listConverter = ListConverter();
