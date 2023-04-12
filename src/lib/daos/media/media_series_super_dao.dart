import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/series_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class MediaSeriesSuperDao {
  static final MediaSeriesSuperDao _singleton = MediaSeriesSuperDao._internal();

  factory MediaSeriesSuperDao() {
    return _singleton;
  }

  MediaSeriesSuperDao._internal();

  Future<List<MediaSeriesSuperEntity>> findAllMediaSeries() {
    return serviceLocator<SeriesDao>().findAllSeries().then((seriesList) async {
      List<MediaSeriesSuperEntity> mediaSeriesSuperEntities = [];

      for (var series in seriesList) {
        final mediaStream = serviceLocator<MediaDao>().findMediaById(series.id);
        Media? firstNonNullMedia =
            await mediaStream.firstWhere((media) => media != null);
        Media media = firstNonNullMedia!;

        mediaSeriesSuperEntities
            .add(MediaSeriesSuperEntity.fromMediaAndSeries(media, series));
      }

      return mediaSeriesSuperEntities;
    });
  }

  Future<int> insertMediaSeriesSuperEntity(
      MediaSeriesSuperEntity mediaSeriesSuperEntity) async {
    final media = mediaSeriesSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaSeriesSuperEntityWithId =
        mediaSeriesSuperEntity.copyWith(id: mediaId);

    final series = mediaSeriesSuperEntityWithId.toSeries();

    await serviceLocator<SeriesDao>().insertSerie(series);

    return mediaId;
  }

  Future<void> insertMediaSeriesSuperEntities(
      List<MediaSeriesSuperEntity> mediaSeriesSuperEntities) async {
    for (var mediaSeriesSuperEntity in mediaSeriesSuperEntities) {
      await insertMediaSeriesSuperEntity(mediaSeriesSuperEntity);
    }
  }

  Future<void> updateMediaSeriesSuperEntity(
      MediaSeriesSuperEntity mediaSeriesSuperEntity) async {
    if (mediaSeriesSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update in MediaSeriesSuperEntity");
    }

    final media = mediaSeriesSuperEntity.toMedia();

    await serviceLocator<MediaDao>().updateMedia(media);

    final series = mediaSeriesSuperEntity.toSeries();

    await serviceLocator<SeriesDao>().updateSerie(series);
  }

  Future<void> deleteMediaSeriesSuperEntity(
      MediaSeriesSuperEntity mediaSeriesSuperEntity) async {
    if (mediaSeriesSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete in MediaSeriesSuperEntity");
    }

    final media = mediaSeriesSuperEntity.toMedia();

    await serviceLocator<MediaDao>().deleteMedia(media);
  }
}

final mediaSeriesSuperDao = MediaSeriesSuperDao();
