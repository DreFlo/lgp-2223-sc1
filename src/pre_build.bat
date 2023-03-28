@echo OFF
title Pre build
call flutter clean
call flutter pub get
call flutter gen-l10n
call flutter pub run build_runner build --delete-conflicting-outputs