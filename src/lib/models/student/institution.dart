import 'package:floor/floor.dart';
import 'package:src/utils/enums.dart';
import 'package:src/models/user.dart';

@Entity(
  tableName: 'institution',
  foreignKeys: [
    ForeignKey(
        childColumns: ['user_id'],
        parentColumns: ['id'],
        entity: User,
        onDelete: ForeignKeyAction.cascade,
        onUpdate: ForeignKeyAction.restrict)
  ],
)
class Institution {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String picture;

  final InstitutionType type;

  final String acronym;

  @ColumnInfo(name: 'user_id')
  final int userId;

  Institution(
      {this.id,
      required this.name,
      required this.picture,
      required this.type,
      required this.acronym,
      required this.userId});
}
