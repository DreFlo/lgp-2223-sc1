import 'package:floor/floor.dart';
import 'package:src/models/timeslot/media_media_timeslot.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/timeslot/media_timeslot.dart';

@dao
abstract class MediaMediaTimeslotDao {
  @Query('SELECT * FROM media_media_timeslot')
  Future<List<MediaMediaTimeslot>> findAllMediaMediaTimeslots();

  @Query('SELECT * FROM media_media_timeslot WHERE media_id = :id')
  Future<List<MediaMediaTimeslot>> findMediaMediaTimeslotByMediaId(int id);

  @Query('SELECT * FROM media_media_timeslot WHERE media_timeslot_id = :id')
  Future<List<MediaMediaTimeslot>> findMediaMediaTimeslotByMediaTimeslotId(
      int id);

  @insert
  Future<void> insertMediaMediaTimeslot(MediaMediaTimeslot mediaMediaTimeslot);

  @insert
  Future<void> insertMediaMediaTimeslots(
      List<MediaMediaTimeslot> mediaMediaTimeslots);

  @update
  Future<void> updateMediaMediaTimeslot(MediaMediaTimeslot mediaMediaTimeslot);

  @delete
  Future<void> deleteMediaMediaTimeslot(MediaMediaTimeslot mediaMediaTimeslot);

  @Query('''SELECT M.* 
          FROM media_media_timeslot MT JOIN media M ON MT.media_id = M.id 
          WHERE MT.media_timeslot_id = :id''')
  Future<List<Media>> findMediaByMediaTimeslotId(int id);

  @Query('''SELECT T.* 
          FROM media_media_timeslot MT JOIN media_timeslot T ON MT.media_timeslot_id = T.id 
          WHERE MT.media_id = :id''')
  Future<List<MediaTimeslot>> findMediaTimeslotByMediaId(int id);
}
