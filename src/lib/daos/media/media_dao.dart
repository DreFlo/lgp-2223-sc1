import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';

@dao
abstract class MediaDao {
  @Query('SELECT * FROM media')
  Future<List<Media>> findAllMedia();

  @Query('SELECT * FROM media WHERE id = :id')
  Stream<Media?> findMediaById(int id);

  @insert
  Future<void> insertMedia(Media media);

  @insert
  Future<void> insertMedias(List<Media> medias);

  @update
  Future<void> updateMedia(Media media);

  @update
  Future<void> updateMedias(List<Media> medias);

  @delete
  Future<void> deleteMedia(Media media);
}
