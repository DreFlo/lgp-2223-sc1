import 'package:floor/floor.dart';
import 'package:src/models/timeslot/timeslot.dart';

@dao
abstract class TimeslotDao {
  @Query('SELECT * FROM timeslot')
  Future<List<Timeslot>> findAllTimeslots();

  @Query('SELECT * FROM timeslot WHERE id = :id')
  Future<Timeslot?> findTimeslotById(int id);

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
