import 'package:floor/floor.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'institution',
)
class Institution {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String picture;

  final InstitutionType type;

  final String acronym;

  Institution(
      {this.id,
      required this.name,
      required this.picture,
      required this.type,
      required this.acronym});
}
