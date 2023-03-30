import 'package:floor/floor.dart';

@Entity(
  tableName: 'user',
)
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String userName;

  final String password;

  final int xp;

  User(
      {this.id,
      required this.userName,
      required this.password,
      required this.xp});
}
