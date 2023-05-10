import 'package:src/models/user.dart';

class AuthenticationService {
  static final AuthenticationService _singleton =
      AuthenticationService._internal();

  factory AuthenticationService() {
    return _singleton;
  }

  AuthenticationService._internal();

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

  int getLoggedInUserId() {
    return isUserLoggedIn() ? loggedUser!.id ?? 0 : 0;
  }
}

final authenticationService = AuthenticationService();
