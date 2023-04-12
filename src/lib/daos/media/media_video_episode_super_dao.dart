import 'package:src/daos/media/episode_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/media/video.dart';
import 'package:src/models/media/media.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class MediaVideoEpisodeSuperDao {
  static final MediaVideoEpisodeSuperDao _singleton =
      MediaVideoEpisodeSuperDao._internal();

  factory MediaVideoEpisodeSuperDao() {
    return _singleton;
  }

  MediaVideoEpisodeSuperDao._internal();

  Future<List<MediaVideoEpisodeSuperEntity>> findAllMediaVideoMovie() {
    return serviceLocator<EpisodeDao>().findAllEpisode().then((episodeList) async {
      List<MediaVideoEpisodeSuperEntity> mediaVideoEpisodeSuperEntities = [];

      for (var episode in episodeList) {
        final videoStream = serviceLocator<VideoDao>().findVideoById(episode.id);
        Video? firstNonNullVideo =
            await videoStream.firstWhere((video) => video != null);
        Video video = firstNonNullVideo!;

        final mediaStream = serviceLocator<MediaDao>().findMediaById(episode.id);
        Media? firstNonNullMedia =
            await mediaStream.firstWhere((media) => media != null);
        Media media = firstNonNullMedia!;

        mediaVideoEpisodeSuperEntities.add(
            MediaVideoEpisodeSuperEntity.fromMediaAndVideoAndEpisode(
                media, video, episode));
      }

      return mediaVideoEpisodeSuperEntities;
    });
  }

  Future<int> insertMediaVideoEpisodeSuperEntity(
    MediaVideoEpisodeSuperEntity mediaVideoEpisodeSuperEntity,
  ) async {
    final media = mediaVideoEpisodeSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaVideoSuperEntityWithId =
        mediaVideoEpisodeSuperEntity.copyWith(id: mediaId);

    final video = mediaVideoSuperEntityWithId.toVideo();

    await serviceLocator<VideoDao>().insertVideo(video);

    final episode = mediaVideoSuperEntityWithId.toEpisode();

    await serviceLocator<EpisodeDao>().insertEpisode(episode);

    return mediaId;
  }

  Future<void> insertMediaVideoEpisodeSuperEntities(
    List<MediaVideoEpisodeSuperEntity> mediaVideoEpisodeSuperEntities,
  ) async {
    for (var mediaVideoEpisodeSuperEntity in mediaVideoEpisodeSuperEntities) {
      await insertMediaVideoEpisodeSuperEntity(mediaVideoEpisodeSuperEntity);
    }
  }

  Future<void> updateMediaVideoEpisodeSuperEntity(
    MediaVideoEpisodeSuperEntity mediaVideoEpisodeSuperEntity,
  ) async {
    if (mediaVideoEpisodeSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete in MediaVideoEpisodeSuperEntity");
    }

    final media = mediaVideoEpisodeSuperEntity.toMedia();

    await serviceLocator<MediaDao>().updateMedia(media);

    final video = mediaVideoEpisodeSuperEntity.toVideo();

    await serviceLocator<VideoDao>().updateVideo(video);

    final episode = mediaVideoEpisodeSuperEntity.toEpisode();

    await serviceLocator<EpisodeDao>().updateEpisode(episode);
  }

  Future<void> deleteMediaVideoEpisodeSuperEntity(
    MediaVideoEpisodeSuperEntity mediaVideoEpisodeSuperEntity,
  ) async {
    if (mediaVideoEpisodeSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete in MediaVideoEpisodeSuperEntity");
    }

    final episode = mediaVideoEpisodeSuperEntity.toEpisode();

    await serviceLocator<EpisodeDao>().deleteEpisode(episode);

    final video = mediaVideoEpisodeSuperEntity.toVideo();

    await serviceLocator<VideoDao>().deleteVideo(video);

    final media = mediaVideoEpisodeSuperEntity.toMedia();

    await serviceLocator<MediaDao>().deleteMedia(media);
  }
}

final mediaVideoEpisodeSuperDao = MediaVideoEpisodeSuperDao();
