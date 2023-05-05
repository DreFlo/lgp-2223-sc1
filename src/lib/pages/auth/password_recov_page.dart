import 'package:flutter/material.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/models/user.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/service_locator.dart';

class PasswordRecovPage extends StatefulWidget {
  const PasswordRecovPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecovPage> createState() => _PasswordRecovPageState();
}

class _PasswordRecovPageState extends State<PasswordRecovPage> {
  TextEditingController inputController = TextEditingController();

  String _emailErrText = "";

  @override
  void dispose() {
    // Clean up the controller
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).password_recov_title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.025)),
          Text(AppLocalizations.of(context).password_recov_subtitle,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.left),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05)),
          TextField(
            controller: inputController,
            style: Theme.of(context).textTheme.bodySmall,
            onChanged: (value) => {setState(() => _emailErrText = "")},
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: AppLocalizations.of(context).your_input +
                  AppLocalizations.of(context).input_email,
              labelStyle: const TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xFF5E6272),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              contentPadding: const EdgeInsets.only(bottom: 2.5),
              errorText: _emailErrText != "" ? _emailErrText : null,
              errorStyle: const TextStyle(
                  fontFamily: "Poppins",
                  color: leisureColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton(
              onPressed: () async {
                onRecoverPasswordPressed().then((password) => {
                      if (password != null)
                        {
                          recoverCallback(
                              context, inputController.text, password)
                        }
                    });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.50, 55),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(AppLocalizations.of(context).password_recov_btn,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ]),
        ],
      ),
    ));
  }

  Future<String?> onRecoverPasswordPressed() async {
    String email = inputController.text;

    // Check if email is valid
    RegExp emailRE = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (!emailRE.hasMatch(email)) {
      setState(() {
        _emailErrText = AppLocalizations.of(context).error_input_email;
      });
      return null;
    }

    // Check if email is in use
    User? user = await serviceLocator<UserDao>().findUserByEmail(email);
    if (user == null) {
      setState(() {
        _emailErrText = AppLocalizations.of(context).error_input_email;
      });
      return null;
    }

    return user.password;
  }

  void recoverCallback(BuildContext context, String email, String password) {
    Navigator.of(context).pop();

    // TODO(auth): for MVP purposes, we will just show the password in an alert dialog
    // In the future, we will send an email to the user to reset their password
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Email: $email \nPassword: $password",
              style: Theme.of(context).textTheme.labelMedium),
        );
      },
    );
  }
}
