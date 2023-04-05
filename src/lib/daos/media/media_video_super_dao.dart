import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/video_dao.dart';
import 'package:src/models/media/media_video_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

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
      throw DatabaseOperationWithId(
          "Id can't be passed to insert for MediaVideoSuperEntity");
    }

    final media = mediaVideoSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaVideoSuperEntityWithId =
        mediaVideoSuperEntity.copyWith(id: mediaId);

    final video = mediaVideoSuperEntityWithId.toVideo();

    await serviceLocator<VideoDao>().insertVideo(video);

    return mediaId;
  }

  Future<void> updateMediaVideoSuperEntity(
    MediaVideoSuperEntity mediaVideoSuperEntity,
  ) async {
    if (mediaVideoSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete in MediaVideoSuperEntity");
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
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete in MediaVideoSuperEntity");
    }

    final media = mediaVideoSuperEntity.toMedia();

    await serviceLocator<MediaDao>().deleteMedia(media);
  }
}

final mediaVideoSuperDao = MediaVideoSuperDao();
