import 'package:src/utils/service_locator.dart';

Future<void> resetAndSeedDatabase() async {
  await serviceLocator.reset();
  await setup(deleteDB: true, seedDB: true);
}
