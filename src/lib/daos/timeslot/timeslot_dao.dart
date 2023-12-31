import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';

@dao
abstract class TimeslotDao {
  @Query('SELECT * FROM timeslot')
  Future<List<Timeslot>> findAllTimeslots();

  @Query('SELECT * FROM timeslot WHERE id = :id')
  Stream<Timeslot?> findTimeslotById(int id);

  @Query('SELECT * FROM timeslot WHERE start_datetime >= :start')
  Future<List<Timeslot>> findAllTimeslotsAfterStart(
    DateTime start,
  );

  @Query('SELECT * FROM timeslot WHERE finished = :finished')
  Future<List<Timeslot>> findAllFinishedTimeslots(
    bool finished,
  );

  @Query(
      'SELECT COUNT(*) FROM timeslot WHERE finished = 1 AND start_datetime >= :start')
  Future<int?> countFinishedTimeslotsAfterStart(DateTime start);

  @insert
  Future<int> insertTimeslot(Timeslot timeslot);

  @insert
  Future<void> insertTimeslots(List<Timeslot> timeslots);

  @update
  Future<void> updateTimeslot(Timeslot timeslot);

  @update
  Future<void> updateTimeslots(List<Timeslot> timeslots);

  @delete
  Future<void> deleteTimeslot(Timeslot timeslot);
}
