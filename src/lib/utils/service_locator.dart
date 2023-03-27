import 'package:get_it/get_it.dart';
import 'package:src/database.dart';

final GetIt serviceLocator = GetIt.instance;

/// Setup the GetIt service locator
/// Used to register singleton variables
/// Add any singleton variables here
void setup() {
  serviceLocator.registerSingletonAsync<AppDatabase>(() async =>
      await $FloorAppDatabase.databaseBuilder('wokka_database.db').build());
}

void setupUnitTest() {
  serviceLocator.registerSingletonAsync<AppDatabase>(() async =>
      await $FloorAppDatabase.inMemoryDatabaseBuilder().build());
}
