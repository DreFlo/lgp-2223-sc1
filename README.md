# SC1 - Wan of a Kind

## Wokka 

Wokka is an innovative mobile app designed to help young people manage their time more efficiently. With this unique app, you can track your progress in your daily tasks and stay on top of your goals in all aspects of your life. But as work isn’t everything, Wokka offers you everything you need to track your media obsession in your deserved downtime. 

One of the key features of Wokka is its gamification component. We know that staying motivated and on track can be challenging, which is why we’ve built an experience points system to help keep you motivated. Earn points for completing tasks, events, or for using the app’s pomodoro timer. There might be some surprises for very committed users.  

So that users can have an excellent experience, Wokka has a clean and intuitive interface which makes it easy to navigate and use. 

### How to contribute  

Need to have a knowledge of Flutter, Dart, Floor and Github Actions.

Possible to fork this repository and continue working.

### How to run

Create a .env file according to the .env.example file (API keys in discord #environment-variables)

Before running you should run the ```pre_build.sh/pre_build.bat`` script, or alternatively:

You should generate the l10n packages:

```shell
flutter gen-l10n
```

And generate the env.g.dart file

```shell
flutter pub run build_runner build --delete-conflicting-outputs 
```

There are two configured flavours for the app: __premium__ and __free__.

To run manually:

```shell
flutter run --flavor <flavorName> -t lib/main_<flavorName>.dart
```

There already run configurations set up for __Android Studio__ and __VSCode__.

For Android Studio and VSCode to function you should make sure you have installed the correct plugins. The Flutter and Dart SDKs should be configured in the IDEs.

To develop the app in your phone with:
- Enable "Developer Options" on your phone
- In the developer options menu enable "USB debugging"
- In the same menu, in "Select USB configuration" choose "Picture Transfer Protocol (PTP)" or equivalent
- Connect your phone to the PC, there should be an alert on your phone asking whether to trust the PC for debugging, choose "Yes"
- Your phone should be available in the Android Studio devices list you can select it
- To run in your device manually:

Find your device name (2nd column):

```shell
flutter devices
```

Run:

```shell
flutter run --flavor <flavorName> -t lib/main_<flavorName>.dart -d <deviceName>
```

#### Database

Add new tables to the database or edit existing ones by writing models.
DAOs control access to the database and handle the object relational mismatch.

To generate ```database.g.dart``` (required after editing):

```shell
flutter packages pub run build_runner build
```
For more info:
- [Floor Documentation](https://pub.dev/documentation/floor/latest/index.html)
- [Floor Github root](https://github.com/pinchbv/floor)
- [Floor examples](https://github.com/pinchbv/floor/tree/develop/example/lib)
- [More Floor examples](https://github.com/pinchbv/floor/tree/develop/floor/test/integration)

_IMPORTANT: If you need to delete the database that is in your device add the following command to the run command:_ 
```shell
--dart-define="DELETE_DB=true"
```
So the full run command should be:
```shell
flutter run --flavor <flavorName> -t lib/main_<flavorName>.dart --dart-define="DELETE_DB=true"
```

_To seed the database:_
```shell
flutter run --flavor <flavorName> -t lib/main_<flavorName>.dart --dart-define="SEED_DB=true"
```

#### Service Locator (GetIt)

GetIt allows us to access the database as a Singleton app wide

To access the database import ```package:src/utils/service_locator.dart``` and:

```dart
serviceLocator<AppDatabase>()
```
#### Internationalization

To support app text appearing in system language follow the following steps:

- Add a new key, value pair to the __lib/l10n/app_en.arb__ file
  like ```"helloWorld" : "Hello, World!"``` (the ```"@helloWorld"``` is a docstring for the
  function)
- To support other languages add the same key in **lib/l10n/app_[language code].arb**
- Generate the package files by running ```flutter gen-l10n```
- To use it in the app import ```'package:flutter_gen/gen_l10n/app_localizations.dart'``` and use
  the keys like ```AppLocalizations.of(context).helloWorld```
- More functionality like plurals, placeholders (i.e. for names) is
  outlined [here](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

**WARNING: You need to run ```flutter gen-l10n``` to generate the localization package for the app
to work. If you've already done this and the app works but Android Studio indicates the package URI
doesn't exist ignore it**

#### Testing

There are scripts that run the entire test suite: ```run_test_suite.sh```
and ```run_test_suite.bat```

When creating tests on the widgets (database functionality not relevant), you should place the following code in the setUp() function for the tests:

```dart
setupMockServiceLocatorUnitTests();
await serviceLocator.allReady();
```

And in the tearDown() function:

```dart
await serviceLocator.reset();
```

To mock a DAO you may then do something like this in the test:

```dart
final mockPersonDao = serviceLocator.get<PersonDao>();
when(mockPersonDao.findAllPersons()).thenAnswer((_) async => []);
```

In order to use mocks for the models, you need to add to the GenerateNiceMocks in the model_mock_utils.dart file, like this:
```dart
MockSpec<Model>()
```
And you will be able to use it as:
```dart
MockModel()
```

If you actually want to test database functionality (do not do this in widget tests) you can place the following code in your setUp() function:

```dart
setupServiceLocatorUnitTests();
await serviceLocator.allReady();
```

__INTEGRATION TESTS__

```shell
flutter test integration_test/<flavorName> --flavor <flavorName>
```

__UNIT AND WIDGET TESTS__

```shell
flutter test
```

#### Icons

To change the app icons:

- move the image files to ```assets/icons```
- change the ```image_path``` values in the ```flutter_launcher_icons-[flavor].yaml``` files
- run ```flutter pub run flutter_launcher_icons```

More info can be found [here](https://pub.dev/packages/flutter_launcher_icons)

#### Flavors

To use conditional logic according to the app flavor:

- import the ```lib/flavors.dart``` file
- The class ```F``` has static members ```appFlavour``` and ```name``` that indicate the app flavour
- You can also add statics methods to the class to implement app-wide flavor-specific logic

More info can be found [here](https://pub.dev/packages/flutter_flavorizr)

#### Environment variables

To add new environment variables add them to your .env file (Also add the variable name to the .env.example so other people know the format).
Add the new key to ```lib/env/env.dart``` (follow the example of the ons already there).
Run:

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```

Also add the new variables to the github actions .yml in the "Generate environment variables" step (if they are secrets use the Github Secrets functionality)

#### TMDB API

Documentation [here](https://developers.themoviedb.org/3/getting-started)

Using the dart package tmdb_api 2.1.4 [here](https://pub.dev/packages/tmdb_api)

More information about the possible calls in the API Calls markdown [here](api_calls.md)

#### Google Books API

Documentation [here](https://developers.google.com/books/docs/viewer/developers_guide?hl=en)

Limits: 1k queries per day; 100 queries per minute per user.

Using the dart package books_finder 4.3.0 [here](https://pub.dev/packages/books_finder)

More information about the possible calls in the API Calls markdown [here](api_calls.md)

