@echo
title Pre build
call flutter gen-l10n
call flutter pub run build_runner build --delete-conflicting-outputs