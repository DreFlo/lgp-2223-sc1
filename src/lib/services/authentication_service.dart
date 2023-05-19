import 'package:src/models/user.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AuthenticationService {
  static final AuthenticationService _singleton =
      AuthenticationService._internal();

  factory AuthenticationService() {
    return _singleton;
  }

  AuthenticationService._internal();

  User? loggedUser;

  Future<void> setLoggedInUser(User user, {bool cache = true}) async {
    loggedUser = user;
    if (cache) await cacheLoggedInUser();
  }

  bool isUserLoggedIn() {
    return loggedUser != null;
  }

  User? getLoggedInUser() {
    return loggedUser;
  }

  int getLoggedInUserId() {
    return isUserLoggedIn() ? loggedUser!.id ?? 0 : 0;
  }

  void logoutUser({bool cache = true}) async {
    loggedUser = null;
    if (cache) await removeCachedLoggedInUser();
  }

  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final String path = await _localPath;
    return File('$path/user_logged_in.txt');
  }

  // Cache user logged in / Update user logged in in cache
  Future<bool> cacheLoggedInUser() async {
    if (!isUserLoggedIn()) return false;

    final File file = await _localFile;
    int id = loggedUser!.id ?? -1;
    file.writeAsString('$id');
    return true;
  }

  // Get user logged in from cache
  Future<int?> getCachedLoggedInUser() async {
    try {
      final File file = await _localFile;
      if (!(await file.exists())) return null;

      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return null;
    }
  }

  // Remove user logged in from cache
  Future<void> removeCachedLoggedInUser() async {
    try {
      await (await _localFile).delete();
    } catch (e) {
      return;
    }
  }
}

final authenticationService = AuthenticationService();
