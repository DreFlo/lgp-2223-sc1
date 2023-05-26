import 'package:src/models/user.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/utils/service_locator.dart';

User getUser() {
  User user = serviceLocator<AuthenticationService>().isUserLoggedIn()
      ? serviceLocator<AuthenticationService>().getLoggedInUser()!
      : User(
          name: '',
          email: '',
          password: '',
          xp: 0,
          level: 0,
          imagePath: 'assets/images/no_image.jpg');
  return user;
}
