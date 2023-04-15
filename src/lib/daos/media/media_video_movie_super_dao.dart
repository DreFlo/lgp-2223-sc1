import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/movie_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/media/video.dart';
import 'package:src/models/media/movie.dart';
import 'package:src/models/media/media.dart';
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

  Future<MediaVideoMovieSuperEntity> findMediaVideoMovieByPhoto(
      String photo) async {
    final media = await serviceLocator<MediaDao>().findMediaByPhoto(photo);
    final videoStream = serviceLocator<VideoDao>().findVideoById(media!.id ?? 0);
    Video? firstNonNullVideo =
        await videoStream.firstWhere((video) => video != null);
    Video video = firstNonNullVideo!;
    final movieStream = serviceLocator<MovieDao>().findMovieById(video.id);
    Movie? firstNonNullMovie =
        await movieStream.firstWhere((movie) => movie != null);
    Movie movie = firstNonNullMovie!;

    return MediaVideoMovieSuperEntity.fromMediaAndVideoAndMovie(
        media, video, movie);
  }

  Future<List<MediaVideoMovieSuperEntity>> findAllMediaVideoMovie() {
    return serviceLocator<MovieDao>().findAllMovie().then((movieList) async {
      List<MediaVideoMovieSuperEntity> mediaVideoMovieSuperEntities = [];

      for (var movie in movieList) {
        final videoStream = serviceLocator<VideoDao>().findVideoById(movie.id);
        Video? firstNonNullVideo =
            await videoStream.firstWhere((video) => video != null);
        Video video = firstNonNullVideo!;

        final mediaStream = serviceLocator<MediaDao>().findMediaById(movie.id);
        Media? firstNonNullMedia =
            await mediaStream.firstWhere((media) => media != null);
        Media media = firstNonNullMedia!;

        mediaVideoMovieSuperEntities.add(
            MediaVideoMovieSuperEntity.fromMediaAndVideoAndMovie(
                media, video, movie));
      }

      return mediaVideoMovieSuperEntities;
    });
  }

  Future<int> insertMediaVideoMovieSuperEntity(
    MediaVideoMovieSuperEntity mediaVideoMovieSuperEntity,
  ) async {
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

  Future<void> insertMediaVideoMovieSuperEntities(
    List<MediaVideoMovieSuperEntity> mediaVideoMovieSuperEntities,
  ) async {
    for (var mediaVideoMovieSuperEntity in mediaVideoMovieSuperEntities) {
      await insertMediaVideoMovieSuperEntity(mediaVideoMovieSuperEntity);
    }
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
