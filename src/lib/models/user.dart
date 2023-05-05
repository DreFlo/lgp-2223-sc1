import 'package:floor/floor.dart';

@Entity(
  tableName: 'user',
)
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String email;

  final String password;

  final int xp;

  final int level;

  @ColumnInfo(name: 'image_path')
  final String imagePath;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.xp,
      required this.level,
      required this.imagePath});
}
