# Wokka

A new Flutter project.

## Development Resources

### Standard Flutter Help Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on
mobile development, and a full API reference.

### Project Specific Help

#### Running

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

To access a table you need to use the DAO, example:

```dart
database.personDao.insertPerson(Person(name: "Emil"))
```

To access the database app wide see [Service Locator](#service-locator-getit)

For more info:
- [Floor Documentation](https://pub.dev/documentation/floor/latest/index.html)
- [Floor Github root](https://github.com/pinchbv/floor)
- [Floor examples](https://github.com/pinchbv/floor/tree/develop/example/lib)
- [More Floor examples](https://github.com/pinchbv/floor/tree/develop/floor/test/integration)

#### Service Locator (GetIt)

GetIt allows us to access the database as a Singleton app wide

To access the database import ```package:src/utils/service_locator.dart``` and:

```dart
serviceLocator<AppDatabase>()
```

You can use the database like so:

```dart
serviceLocator<AppDatabase>().personDao.insertPerson(Person(name: "Emil"))
```

If you want to add more services do so in the ```setup()``` function in ```utils/service_locator.dart```

[Documentation](https://pub.dev/documentation/get_it/latest/)

More info [here](https://pub.dev/packages/get_it)

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

#### Release

To create a release:

- Update the CHANGELOG file accordingly
- Update app version in pubspec.yaml
- Push a tag with a name that matches ```release/v*```

The release artifacts are built automatically.

Only create a release from main.
