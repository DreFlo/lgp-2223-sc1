import 'package:floor/floor.dart';

@Entity(
  tableName: 'user',
)
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'user_name')
  final String userName;

  final String password;

  final int xp;

  final int level;

  @ColumnInfo(name: 'image_path')
  final String imagePath;

  User(
      {this.id,
      required this.userName,
      required this.password,
      required this.xp,
      required this.level,
      required this.imagePath});
}
