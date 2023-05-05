import 'package:src/models/user.dart';

class AuthenticationDao {
  static final AuthenticationDao _singleton = AuthenticationDao._internal();

  factory AuthenticationDao() {
    return _singleton;
  }

  AuthenticationDao._internal();

  User? loggedUser;

  void setLoggedInUser(User user) {
    loggedUser = user;
  }

  User? getLoggedInUser() {
    return loggedUser;
  }

  bool isUserLoggedIn() {
    return loggedUser != null;
  }

  void logoutUser() {
    loggedUser = null;
  }
}

final authenticationDao = AuthenticationDao();
