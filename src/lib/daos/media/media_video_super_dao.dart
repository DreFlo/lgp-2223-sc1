import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/media/media_video_super_entity.dart';
import 'package:src/utils/service_locator.dart';

// SuperDAO is the most important part
// It's a DAO that uses other DAOs to insert/update/delete super entities
// as their entities in the database
// This DAO is ignored by Floor
class MediaVideoSuperDao {
  // SuperDAOs are singletons so they can be accessed from exactly the same way
  // as regular DAOs and provide an abstraction layer
  static final MediaVideoSuperDao _singleton = MediaVideoSuperDao._internal();

  factory MediaVideoSuperDao() {
    return _singleton;
  }

  MediaVideoSuperDao._internal();

  Future<int> insertMediaVideoSuperEntity(
    MediaVideoSuperEntity mediaVideoSuperEntity,
  ) async {
    if (mediaVideoSuperEntity.id != null) {
      // TODO Maybe throw an exception
      // Id is useful in the super entity, but can't be used in insert
      return -1;
    }

    final media = mediaVideoSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaVideoSuperEntityWithId = mediaVideoSuperEntity.copyWith(id: mediaId);

    final video = mediaVideoSuperEntityWithId.toVideo();

    await serviceLocator<VideoDao>().insertVideo(video);

    return mediaId;
  }

  Future<void> updateMediaVideoSuperEntity(
    MediaVideoSuperEntity mediaVideoSuperEntity,
  ) async {
    if (mediaVideoSuperEntity.id == null) {
      // TODO Maybe throw an exception
      return;
    }

    final media = mediaVideoSuperEntity.toMedia();

    await serviceLocator<MediaDao>().updateMedia(media);

    final video = mediaVideoSuperEntity.toVideo();

    await serviceLocator<VideoDao>().updateVideo(video);
  }

  Future<void> deleteMediaVideoSuperEntity(
    MediaVideoSuperEntity mediaVideoSuperEntity,
  ) async {
    if (mediaVideoSuperEntity.id == null) {
      // TODO Maybe throw an exception
      return;
    }

    final media = mediaVideoSuperEntity.toMedia();

    await serviceLocator<MediaDao>().deleteMedia(media);

    final video = mediaVideoSuperEntity.toVideo();

    await serviceLocator<VideoDao>().deleteVideo(video);
  }
}

final mediaVideoSuperDao = MediaVideoSuperDao();
