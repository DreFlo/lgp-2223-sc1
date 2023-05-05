import 'package:src/models/user.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/utils/service_locator.dart';

//use this file temporarily to test the game logic -> we are going to get the only user in the DB and update their points/level

User user = User(
    id: 1,
    name: "test",
    email: "test@gmail.com",
    password: "test",
    xp: 0,
    level: 0,
    imagePath: '');

Future<User> getUser() async {
  user = await serviceLocator<UserDao>().findUserById(1).first ?? user;
  return user;
}

Future<void> updateUser(User user) async {
  //use this to update xp and level
  await serviceLocator<UserDao>().updateUser(user);
}
