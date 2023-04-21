import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Implement Login page

    return SizedBox(
        child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Login",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.left),
              Text(
                  "No need to be shy... we don’t bite! \nUnless you into that.",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.left),
              const TextField(
                  decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'E-mail',
              )),
              const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password',
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10))))),
                child: const Text('Sign In'),
                onPressed: () {
                  print("Pressed signin btn!");
                },
              )
            ])));
  }
}
