import 'package:floor/floor.dart';
import 'package:src/models/media/video.dart';

@dao
abstract class VideoDao {
  @Query('SELECT * FROM Video')
  Future<List<Video>> findAllTasks();

  @Query('SELECT * FROM Video WHERE id = :id')
  Stream<Video?> findVideoById(int id);

  @insert
  Future<void> insertVideo(Video video);

  @insert
  Future<void> insertVideos(List<Video> video);

  @update
  Future<void> updateVideo(Video video);

  @update
  Future<void> updateVideos(List<Video> video);

  @delete
  Future<void> deleteVideo(Video video);
}
