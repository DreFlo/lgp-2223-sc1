#!/bin/sh
echo Get packages
flutter pub get
echo Generate l10n package
flutter gen-l10n
echo Run static code analysis
flutter analyze
echo Check formatting
flutter format --dry-run .
echo Run unit tests
flutter test