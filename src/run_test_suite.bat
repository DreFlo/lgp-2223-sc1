@echo OFF
title Test Suite
echo Get packages
call flutter pub get
echo Generate l10n package
call flutter gen-l10n
echo Generate environment variables
call flutter pub run build_runner build --delete-conflicting-outputs
echo Run static code analysis
call flutter analyze
echo Check formatting
call dart format --output=none .
echo Run unit tests
call flutter test --coverage --no-pub
