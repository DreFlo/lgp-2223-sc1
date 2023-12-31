import 'package:floor/floor.dart';
import 'package:src/models/log.dart';

@dao
abstract class LogDao {
  @Query('SELECT * FROM log')
  Future<List<Log>> findAllLogs();

  @Query('SELECT * FROM log WHERE id = :id')
  Future<Log?> findLogById(int id);

  @Query('SELECT * FROM log WHERE date >= :beginDate AND date <= :endDate')
  Future<Log?> findLogByDate(DateTime beginDate, DateTime endDate);

  @Query(
      'SELECT COUNT(*) FROM log WHERE date >= :beginDate AND date <= :endDate')
  Future<int?> countLogsByDate(DateTime beginDate, DateTime endDate);

  @Query('SELECT COUNT(*) FROM log')
  Future<int?> countLogs();

  @insert
  Future<int> insertLog(Log log);

  @insert
  Future<void> insertLogs(List<Log> logs);

  @update
  Future<void> updateLog(Log log);

  @update
  Future<void> updateLogs(List<Log> logs);

  @delete
  Future<void> deleteLog(Log log);

  @delete
  Future<void> deleteLogs(List<Log> logs);
}
