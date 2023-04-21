import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Implement Login page

    return Container(
        padding: const EdgeInsets.only(top: 15),
        child: Column(children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "No need to be shy... we don’t bite! \nUnless you into that.",
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            )
          ])
        ]));
  }
}
