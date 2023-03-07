#!/bin/sh
echo Get packages
flutter pub get
echo Generate l10n package
flutter gen-l10n
echo Generate environment variables
flutter pub run build_runner build --delete-conflicting-outputs
echo Run static code analysis
flutter analyze
echo Check formatting
dart format --output=none .
echo Run unit tests
flutter test --coverage --no-pub