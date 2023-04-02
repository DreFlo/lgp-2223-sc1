import 'package:floor/floor.dart';
import 'package:src/models/timeslot/media_timeslot.dart';

@dao
abstract class MediaTimeslotDao {
  @Query('SELECT * FROM media_timeslot')
  Future<List<MediaTimeslot>> findAllMediaTimeslots();

  @Query('SELECT * FROM media_timeslot WHERE id = :id')
  Future<MediaTimeslot?> findMediaTimeslotById(int id);

  @Query('SELECT * FROM media_timeslot WHERE media_id = :mediaId')
  Future<List<MediaTimeslot>> findMediaTimeslotsByMediaId(int mediaId);

  @Query(
      'SELECT * FROM media_timeslot WHERE media_id = :mediaId AND timeslot_id = :timeslotId')
  Future<MediaTimeslot?> findMediaTimeslotByMediaIdAndTimeslotId(
      int mediaId, int timeslotId);

  @Query('SELECT * FROM media_timeslot WHERE timeslot_id = :timeslotId')
  Future<List<MediaTimeslot>> findMediaTimeslotsByTimeslotId(int timeslotId);

  @insert
  Future<void> insertMediaTimeslot(MediaTimeslot mediaTimeslot);

  @insert
  Future<void> insertMediaTimeslots(List<MediaTimeslot> mediaTimeslots);

  @update
  Future<void> updateMediaTimeslot(MediaTimeslot mediaTimeslot);

  @update
  Future<void> updateMediaTimeslots(List<MediaTimeslot> mediaTimeslots);

  @delete
  Future<void> deleteMediaTimeslot(MediaTimeslot mediaTimeslot);
}
