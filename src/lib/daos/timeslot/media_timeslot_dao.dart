import 'package:floor/floor.dart';
import 'package:src/models/timeslot/media_timeslot.dart';

@dao
abstract class MediaTimeslotDao {
  @Query('SELECT * FROM media_timeslot')
  Future<List<MediaTimeslot>> findAllMediaTimeslots();

  @Query('SELECT * FROM media_timeslot WHERE id = :id')
  Stream<MediaTimeslot?> findMediaTimeslotById(int id);

  @insert
  Future<int> insertMediaTimeslot(MediaTimeslot mediaTimeslot);

  @insert
  Future<void> insertMediaTimeslots(List<MediaTimeslot> mediaTimeslots);

  @update
  Future<void> updateMediaTimeslot(MediaTimeslot mediaTimeslot);

  @update
  Future<void> updateMediaTimeslots(List<MediaTimeslot> mediaTimeslots);

  @delete
  Future<void> deleteMediaTimeslot(MediaTimeslot mediaTimeslot);
}
