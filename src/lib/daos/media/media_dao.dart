import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/enums.dart';

@dao
abstract class MediaDao {
  @Query('SELECT * FROM media')
  Future<List<Media>> findAllMedia();

  @Query('SELECT * FROM media WHERE id = :id')
  Stream<Media?> findMediaById(int id);

  @Query('SELECT COUNT() FROM media WHERE link_image = :photo')
  Future<int?> countMediaByPhoto(String photo);

  @Query('SELECT * FROM media WHERE link_image = :photo')
  Future<Media?> findMediaByPhoto(String photo);

  @Query('SELECT status FROM media WHERE id = :id')
  Future<Status?> findMediaStatusById(int id);

  @Query(
      'SELECT * FROM media WHERE name LIKE :query OR description LIKE :query')
  Future<List<Media>> getMatchingMedia(String query);

  @Query('SELECT COUNT() FROM media WHERE favorite = :favorite')
  Future<int?> countFavoriteMedia(bool favorite);

  @Query('SELECT COUNT(*) FROM media')
  Future<int?> countAllMedia();

  @insert
  Future<int> insertMedia(Media media);

  @insert
  Future<void> insertMedias(List<Media> medias);

  @update
  Future<void> updateMedia(Media media);

  @update
  Future<void> updateMedias(List<Media> medias);

  @delete
  Future<void> deleteMedia(Media media);

  @Query('''SELECT * FROM media 
            WHERE status <> 3 AND status <> 4''')
  Future<List<Media>> findMediaActivities();
}
