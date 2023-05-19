import 'package:src/models/user.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'dart:typed_data';

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

  // Cache user logged in / Update user logged in in cache
  Future<bool> cacheLoggedInUser() async {
    if (!isUserLoggedIn()) return false;

    await DefaultCacheManager().putFile("user_logged_in",
        Uint8List.fromList(loggedUser!.id.toString().codeUnits));
    return true;
  }

  // Get user logged in from cache
  Future<int?> getCachedLoggedInUser() async {
    File file = await DefaultCacheManager().getSingleFile("user_logged_in");
    String content = await file.readAsString();
    return (content.isEmpty) ? null : int.parse(content);
  }

  // Remove user logged in from cache
  Future<void> removeCachedLoggedInUser() async {
    await DefaultCacheManager().removeFile("user_logged_in");
  }
}

final authenticationService = AuthenticationService();
