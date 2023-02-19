@echo
title Test Suite
echo Get packages
call flutter pub get
echo Generate l10n package
call flutter gen-l10n
echo Run static code analysis
call flutter analyze
echo Check formatting
call flutter format --dry-run .
echo Run unit tests
call flutter test
