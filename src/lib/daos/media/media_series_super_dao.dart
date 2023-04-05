import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/utils/service_locator.dart';

class MediaSeriesSuperDao {
  static final MediaSeriesSuperDao _singleton = MediaSeriesSuperDao._internal();

  factory MediaSeriesSuperDao() {
    return _singleton;
  }

  MediaSeriesSuperDao._internal();

  Future<int> insertMediaSeriesSuperEntity(
      MediaSeriesSuperEntity mediaSeriesSuperEntity) async {
    if (mediaSeriesSuperEntity.id != null) {
      // TODO Maybe throw an exception
      // Id is useful in the super entity, but can't be used in insert
      return -1;
    }

    final media = mediaSeriesSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaSeriesSuperEntityWithId =
        mediaSeriesSuperEntity.copyWith(id: mediaId);

    final series = mediaSeriesSuperEntityWithId.toSeries();

    await serviceLocator<SeriesDao>().insertSerie(series);

    return mediaId;
  }

  Future<void> updateMediaSeriesSuperEntity(
      MediaSeriesSuperEntity mediaSeriesSuperEntity) async {
    if (mediaSeriesSuperEntity.id == null) {
      // TODO Maybe throw an exception
      return;
    }

    final media = mediaSeriesSuperEntity.toMedia();

    await serviceLocator<MediaDao>().updateMedia(media);

    final series = mediaSeriesSuperEntity.toSeries();

    await serviceLocator<SeriesDao>().updateSerie(series);
  }

  Future<void> deleteMediaSeriesSuperEntity(
      MediaSeriesSuperEntity mediaSeriesSuperEntity) async {
    if (mediaSeriesSuperEntity.id == null) {
      // TODO Maybe throw an exception
      return;
    }

    final media = mediaSeriesSuperEntity.toMedia();

    await serviceLocator<MediaDao>().deleteMedia(media);
  }
}

final mediaSeriesSuperDao = MediaSeriesSuperDao();
