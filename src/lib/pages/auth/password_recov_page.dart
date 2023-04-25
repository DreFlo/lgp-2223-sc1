import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordRecovPage extends StatefulWidget {
  PasswordRecovPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecovPage> createState() => _PasswordRecovPageState();
}

class _PasswordRecovPageState extends State<PasswordRecovPage> {
  TextEditingController inputController = TextEditingController();

  String _email = "";
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
            onChanged: (value) => {_emailErrText = ""},
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: AppLocalizations.of(context).your_input + AppLocalizations.of(context).input_email,
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
              onPressed: () {
                setState(() {
                  String inputEmail = inputController.text;

                  RegExp emailRE = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                  if (!emailRE.hasMatch(inputEmail)) {
                    _emailErrText = AppLocalizations.of(context).error_input_email;
                  } else {
                    _email = inputEmail;
                  }

                  if (_emailErrText == "") {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            // Retrieve the text by using the
                            // TextEditingController.
                            content: Text("Email: $_email",
                                style:
                                    Theme.of(context).textTheme.labelMedium));
                      },
                    );
                  }

                  // TODO(auth): Add database connection here to check if email exists
                  // TODO(auth): Create request to send email (MVP?)
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
}
