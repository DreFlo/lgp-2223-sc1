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

Before running you should generate the l10n packages:

```shell
flutter gen-l10n
```

Create a .env file according to the .env.example and generate the env.g.dart file

```shell
flutter pub run build_runner build
```

There are two configured flavours for the app: __premium__ and __free__.

To run manually:

```shell
flutter run --flavor <flavorName> -t lib/main_<flavorName>.dart
```

There already run configurations set up for __Android Studio__ and __VSCode__.

For Android Studio and VSCode to function you should make sure you have installed the correct plugins. The Flutter and Dart SDKs should be configured in the IDEs. 

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
flutter pub run build_runner build
```

#### Release

To create a release:

- Update the CHANGELOG file accordingly
- Update app version in pubspec.yaml
- Push a tag with a name that matches ```release/v*```

The release artifacts are built automatically.

Only create a release from main.
