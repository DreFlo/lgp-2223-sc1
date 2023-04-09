 // ignore: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:src/app.dart';
import 'package:src/flavors.dart';
import 'package:src/utils/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.premium;
  const testingDB = bool.fromEnvironment('DELETE_DB');
  await setup(testing: testingDB);
  runApp(const App());
}
