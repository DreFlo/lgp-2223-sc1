# Wan-of-a-Kind

A new Flutter project.

## Development Resources

### Standard Flutter Help Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Project Specific Help

#### Internationalization

To support app text appearing in system language follow the following steps:

- Add a new key, value pair to the __lib/l10n/app_en.arb__ file like ```"helloWorld" : "Hello, World!"``` (the ```"@helloWorld"``` is a docstring for the function)
- To support other languages add the same key in **lib/l10n/app_[language code].arb**
- Generate the package files by running ```flutter gen-l10n```
- To use it in the app import ```'package:flutter_gen/gen_l10n/app_localizations.dart'``` and use the keys like ```AppLocalizations.of(context).helloWorld```
- More functionality like plurals, placeholders (i.e. for names) is outlined [here](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

**WARNING: You need to run ```flutter gen-l10n``` to generate the localization package for the app to work. If you've already done this and the app works but Android Studio indicates the package URI doesn't exist ignore it**

#### Testing

There are scripts that run the entire test suite: ```run_test_suite.sh``` and ```run_test_suite.bat```
