import 'package:flutter/material.dart';
import 'package:src/app.dart';
import 'package:src/flavors.dart';
import 'package:src/notifications/local_notifications_service.dart';
import 'package:src/utils/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.free;
  const deleteDB = bool.fromEnvironment('DELETE_DB');
  const seedDB = bool.fromEnvironment('SEED_DB');
  await setup(deleteDB: deleteDB, seedDB: seedDB);
  await LocalNotificationService.initialize();
  runApp(const App());
}
