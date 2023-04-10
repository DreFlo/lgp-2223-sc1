import 'package:src/daos/timeslot/timeslot_dao.dart';
import 'package:src/daos/timeslot/student_timeslot_dao.dart';
import 'package:src/models/timeslot/timeslot_student_timeslot_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class TimeslotStudentTimeslotSuperDao {
  static final TimeslotStudentTimeslotSuperDao _singleton =
      TimeslotStudentTimeslotSuperDao._internal();

  factory TimeslotStudentTimeslotSuperDao() {
    return _singleton;
  }

  TimeslotStudentTimeslotSuperDao._internal();

  Future<int> insertTimeslotStudentTimeslotSuperEntity(
    TimeslotStudentTimeslotSuperEntity timeslotStudentTimeslotSuperEntity,
  ) async {
    if (timeslotStudentTimeslotSuperEntity.id != null) {
      throw DatabaseOperationWithId(
          "Id can't be set for insert for TimeslotStudentTimeslotSuperEntity");
    }

    final timeslot = timeslotStudentTimeslotSuperEntity.toTimeslot();

    int timeslotId =
        await serviceLocator<TimeslotDao>().insertTimeslot(timeslot);

    final timeslotStudentTimeslotSuperEntityWithId =
        timeslotStudentTimeslotSuperEntity.copyWith(id: timeslotId);

    final studentTimeslot =
        timeslotStudentTimeslotSuperEntityWithId.toStudentTimeslot();

    await serviceLocator<StudentTimeslotDao>()
        .insertStudentTimeslot(studentTimeslot);

    return timeslotId;
  }

  Future<void> updateTimeslotStudentTimeslotSuperEntity(
    TimeslotStudentTimeslotSuperEntity timeslotStudentTimeslotSuperEntity,
  ) async {
    if (timeslotStudentTimeslotSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update for TimeslotStudentTimeslotSuperEntity");
    }

    final timeslot = timeslotStudentTimeslotSuperEntity.toTimeslot();

    await serviceLocator<TimeslotDao>().updateTimeslot(timeslot);

    final studentTimeslot =
        timeslotStudentTimeslotSuperEntity.toStudentTimeslot();

    await serviceLocator<StudentTimeslotDao>()
        .updateStudentTimeslot(studentTimeslot);
  }

  Future<void> deleteTimeslotStudentTimeslotSuperEntity(
    TimeslotStudentTimeslotSuperEntity timeslotStudentTimeslotSuperEntity,
  ) async {
    if (timeslotStudentTimeslotSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for delete for TimeslotStudentTimeslotSuperEntity");
    }

    final studentTimeslot =
        timeslotStudentTimeslotSuperEntity.toStudentTimeslot();

    await serviceLocator<StudentTimeslotDao>()
        .deleteStudentTimeslot(studentTimeslot);

    final timeslot = timeslotStudentTimeslotSuperEntity.toTimeslot();

    await serviceLocator<TimeslotDao>().deleteTimeslot(timeslot);
  }
}

final timeslotStudentTimeslotSuperDao = TimeslotStudentTimeslotSuperDao();