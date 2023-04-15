import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';

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

  @Query(
      'SELECT * FROM media WHERE name LIKE :query OR description LIKE :query')
  Future<List<Media>> getMatchingMedia(String query);

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
}
