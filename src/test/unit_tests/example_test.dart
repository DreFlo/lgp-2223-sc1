import 'package:flutter_test/flutter_test.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/database.dart';
import 'package:src/models/person.dart';
import 'package:src/utils/service_locator.dart';

import '../utils/service_locator_test_util.dart';

void main() {
  setUp(() async {
    setupServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator<AppDatabase>().close();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      List<Person> persons = await serviceLocator<PersonDao>().findAllPersons();

      expect(persons.length, 0);

      await serviceLocator<PersonDao>().insertPerson(Person(name: 'Emil'));

      persons = await serviceLocator<PersonDao>().findAllPersons();

      expect(persons.length, 1);
    });
  });
}
