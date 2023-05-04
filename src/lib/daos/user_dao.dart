import 'package:floor/floor.dart';
import 'package:src/models/user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM user')
  Future<List<User>> findAllUsers();

  @Query('SELECT * FROM user WHERE id = :id')
  Stream<User?> findUserById(int id);

  @Query('SELECT * FROM user WHERE email = :email')
  Stream<User?> findUserByEmail(String email);

  @Query('SELECT * FROM user WHERE email = :email AND password = :password')
  Stream<User?> findUserByEmailAndPassword(String email, String password);

  @insert
  Future<int> insertUser(User user);

  @insert
  Future<List<int>> insertUsers(List<User> users);

  @update
  Future<void> updateUser(User user);

  @update
  Future<void> updateUsers(List<User> users);

  @delete
  Future<void> deleteUser(User user);
}
