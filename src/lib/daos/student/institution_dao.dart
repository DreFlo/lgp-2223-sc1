import 'package:floor/floor.dart';
import 'package:src/models/student/institution.dart';

@dao
abstract class InstitutionDao {
  @Query('SELECT * FROM institution')
  Future<List<Institution>> findAllInstitutions();

  @Query('SELECT * FROM institution WHERE id = :id')
  Stream<Institution?> findInstitutionById(int id);

  @insert
  Future<int> insertInstitution(Institution institution);

  @insert
  Future<void> insertInstitutions(List<Institution> institutions);

  @update
  Future<void> updateInstitution(Institution institution);

  @update
  Future<void> updateInstitutions(List<Institution> institutions);

  @delete
  Future<void> deleteInstitution(Institution institution);
}
