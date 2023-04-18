import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/daos/timeslot/media_timeslot_dao.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class TimeslotMediaTimeslotSuperDao {
  static final TimeslotMediaTimeslotSuperDao _singleton =
      TimeslotMediaTimeslotSuperDao._internal();

  factory TimeslotMediaTimeslotSuperDao() {
    return _singleton;
  }

  TimeslotMediaTimeslotSuperDao._internal();

  Future<List<TimeslotMediaTimeslotSuperEntity>> findAllTimeslotMediaTimeslot() {
    return serviceLocator<MediaTimeslotDao>().findAllMediaTimeslots().then((mediaTimeslots) async {
      List<TimeslotMediaTimeslotSuperEntity> timeslotMediaTimeslotSuperEntities =
          [];
      
      for (var mediaTimeslot in mediaTimeslots) {
        final timeslot = await
            serviceLocator<TimeslotDao>().findTimeslotById(mediaTimeslot.id);
       
         if (timeslot != null) {
            final timeslotMediaTimeslotSuperEntity = TimeslotMediaTimeslotSuperEntity.fromTimeslotMediaTimeslotEntity(
          mediaTimeslot,
          timeslot,
        );
        timeslotMediaTimeslotSuperEntities.add(timeslotMediaTimeslotSuperEntity);
      }
    }

    return timeslotMediaTimeslotSuperEntities;
  });
}

  Future<int> insertTimeslotMediaTimeslotSuperEntity(
    TimeslotMediaTimeslotSuperEntity timeslotMediaTimeslotSuperEntity,
  ) async {
    final timeslot = timeslotMediaTimeslotSuperEntity.toTimeslot();

    int timeslotId =
        await serviceLocator<TimeslotDao>().insertTimeslot(timeslot);

    final timeslotMediaTimeslotSuperEntityWithId =
        timeslotMediaTimeslotSuperEntity.copyWith(id: timeslotId);

    final mediaTimeslot =
        timeslotMediaTimeslotSuperEntityWithId.toMediaTimeslot();

    await serviceLocator<MediaTimeslotDao>().insertMediaTimeslot(mediaTimeslot);

    return timeslotId;
  }

  Future<void> insertTimeslotMediaTimeslotSuperEntities(
    List<TimeslotMediaTimeslotSuperEntity> timeslotMediaTimeslotSuperEntities,
  ) async {
    for (var timeslotMediaTimeslotSuperEntity
        in timeslotMediaTimeslotSuperEntities) {
      await insertTimeslotMediaTimeslotSuperEntity(
          timeslotMediaTimeslotSuperEntity);
    }
  }

  Future<void> updateTimeslotMediaTimeslotSuperEntity(
    TimeslotMediaTimeslotSuperEntity timeslotMediaTimeslotSuperEntity,
  ) async {
    if (timeslotMediaTimeslotSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update for TimeslotMediaTimeslotSuperEntity");
    }

    final timeslot = timeslotMediaTimeslotSuperEntity.toTimeslot();

    await serviceLocator<TimeslotDao>().updateTimeslot(timeslot);

    final mediaTimeslot = timeslotMediaTimeslotSuperEntity.toMediaTimeslot();

    await serviceLocator<MediaTimeslotDao>().updateMediaTimeslot(mediaTimeslot);
  }

  Future<void> deleteTimeslotMediaTimeslotSuperEntity(
    TimeslotMediaTimeslotSuperEntity timeslotMediaTimeslotSuperEntity,
  ) async {
    if (timeslotMediaTimeslotSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete for TimeslotMediaTimeslotSuperEntity");
    }

    final timeslot = timeslotMediaTimeslotSuperEntity.toTimeslot();

    await serviceLocator<TimeslotDao>().deleteTimeslot(timeslot);

    final mediaTimeslot = timeslotMediaTimeslotSuperEntity.toMediaTimeslot();

    await serviceLocator<MediaTimeslotDao>().deleteMediaTimeslot(mediaTimeslot);
  }
}

final timeslotMediaTimeslotSuperDao = TimeslotMediaTimeslotSuperDao();
