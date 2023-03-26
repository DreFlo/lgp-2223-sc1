import 'package:floor/floor.dart';
import 'package:src/models/institution.dart';

@dao
abstract class InstitutionDao {
  @Query('SELECT * FROM institution')
  Future<List<Institution>> findAllInstitutions();

  @Query('SELECT * FROM institution WHERE id = :id')
  Stream<Institution?> findInstitutionById(int id);

  @insert
  Future<void> insertInstitution(Institution institution);

  @insert
  Future<void> insertInstitutions(List<Institution> institutions);
}
