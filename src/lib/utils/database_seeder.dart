import 'package:get_it/get_it.dart';
import 'package:src/daos/user_dao.dart';

import 'package:src/utils/mock_data/imports.dart';

Future<void> seedDatabase(GetIt serviceLocator) async {
  serviceLocator<UserDao>().insertUsers(mockUsers);
}
