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
                  'weight_average': item.weightAverage,
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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Media> _mediaInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Book> _bookInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Series> _seriesInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Video> _videoInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Season> _seasonInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Review> _reviewInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Movie> _movieInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Episode> _episodeInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubjectNote> _subjectNoteInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TaskNote> _taskNoteInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EpisodeNote> _episodeNoteInsertionAdapter;

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
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BookNote> _bookNoteInsertionAdapter;

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
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
