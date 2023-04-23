#!/bin/sh
echo Clean
flutter clean
echo Get packages
flutter pub get
echo Generate l10n package
flutter gen-l10n
echo Generate build files
flutter pub run build_runner build --delete-conflicting-outputs
echo Run static code analysis
flutter analyze
echo Check formatting
dart format --output=none .
echo Run unit and widget tests
flutter test --coverage --no-pub