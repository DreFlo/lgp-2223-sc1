import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class MediaVideoMovieSuperDao {
  static final MediaVideoMovieSuperDao _singleton =
      MediaVideoMovieSuperDao._internal();

  factory MediaVideoMovieSuperDao() {
    return _singleton;
  }

  MediaVideoMovieSuperDao._internal();

  Future<int> insertMediaVideoMovieSuperEntity(
    MediaVideoMovieSuperEntity mediaVideoMovieSuperEntity,
  ) async {
    if (mediaVideoMovieSuperEntity.id != null) {
      throw DatabaseOperationWithId(
          "Id can't be passed to insert for MediaVideoMovieSuperEntity");
    }

    final media = mediaVideoMovieSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaVideoSuperEntityWithId =
        mediaVideoMovieSuperEntity.copyWith(id: mediaId);

    final video = mediaVideoSuperEntityWithId.toVideo();

    await serviceLocator<VideoDao>().insertVideo(video);

    final movie = mediaVideoSuperEntityWithId.toMovie();

    await serviceLocator<MovieDao>().insertMovie(movie);

    return mediaId;
  }

  Future<void> updateMediaVideoMovieSuperEntity(
    MediaVideoMovieSuperEntity mediaVideoMovieSuperEntity,
  ) async {
    if (mediaVideoMovieSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete in MediaVideoMovieSuperEntity");
    }

    final media = mediaVideoMovieSuperEntity.toMedia();

    await serviceLocator<MediaDao>().updateMedia(media);

    final video = mediaVideoMovieSuperEntity.toVideo();

    await serviceLocator<VideoDao>().updateVideo(video);

    final movie = mediaVideoMovieSuperEntity.toMovie();

    await serviceLocator<MovieDao>().updateMovie(movie);
  }

  Future<void> deleteMediaVideoMovieSuperEntity(
    MediaVideoMovieSuperEntity mediaVideoMovieSuperEntity,
  ) async {
    if (mediaVideoMovieSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete in MediaVideoMovieSuperEntity");
    }

    final media = mediaVideoMovieSuperEntity.toMedia();

    await serviceLocator<MediaDao>().deleteMedia(media);
  }
}

final mediaVideoMovieSuperDao = MediaVideoMovieSuperDao();
