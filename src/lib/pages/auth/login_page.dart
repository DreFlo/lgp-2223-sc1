import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:src/pages/auth/password_recov_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();

  String _email = "";
  String _password = "";

  String _emailErrText = "";
  String _passwordErrText = "";

  @override
  void dispose() {
    // Clean up the controllers
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context).login_title,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.left),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.025)),
              Text(
                  AppLocalizations.of(context).login_subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.left),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.05)),
              TextField(
                controller: firstController,
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: (value) => {_emailErrText = ""},
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'E-MAIL',
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
                      bottom: MediaQuery.of(context).size.height * 0.025)),
              TextField(
                  controller: secondController,
                  style: Theme.of(context).textTheme.bodySmall,
                  onChanged: (value) => {_passwordErrText = ""},
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'PASSWORD',
                    labelStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xFF5E6272),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    contentPadding: const EdgeInsets.only(bottom: 2.5),
                    errorText: _passwordErrText != "" ? _passwordErrText : null,
                    errorStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: leisureColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.05)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: const Color(0xFF22252D),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.0)),
                          ),
                          builder: (context) => DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.85,
                              minChildSize: 0.35,
                              maxChildSize: 0.95,
                              builder: (context, scrollController) => Stack(
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        SingleChildScrollView(
                                            controller: scrollController,
                                            child: const PasswordRecovPage()),
                                      ])));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.45, 55),
                      backgroundColor: grayButton,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(
                              color: primaryColor, width: 2.0)),
                    ),
                    child: Text(AppLocalizations.of(context).login_forgot_pass_btn,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          String inputEmail = firstController.text;
                          String inputPassword = secondController.text;

                          RegExp emailRE = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                          if (!emailRE.hasMatch(inputEmail)) {
                            _emailErrText = AppLocalizations.of(context).error_input_email;
                          } else {
                            _email = inputEmail;
                          }

                          if (inputPassword.length < 8) {
                            _passwordErrText = AppLocalizations.of(context).error_input_password;
                          } else {
                            _password = inputPassword; 
                          }

                          if (_emailErrText == "" && _passwordErrText == "") {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    // Retrieve the text by using the
                                    // TextEditingController.
                                    content: Text(
                                        "Email: $_email \nPassword: $_password",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium));
                              },
                            );
                          }

                          // TODO(auth): Add database connection here to check email and password
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.35, 55),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context).login_submit_btn,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ],
                )
              ]),
            ])));
  }
}
