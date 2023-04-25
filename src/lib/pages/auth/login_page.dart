import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:src/pages/auth/password_recov_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();

  String email = '';
  String password = '';

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
              Text("Sign In",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.left),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.025)),
              Text(
                  "No need to be shy... we don't bite! \nUnless you into that.",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.left),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.05)),
              TextField(
                controller: firstController,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'E-MAIL',
                  labelStyle: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF5E6272),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  contentPadding: EdgeInsets.only(bottom: 2.5),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.025)),
              TextField(
                  controller: secondController,
                  style: Theme.of(context).textTheme.bodySmall,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'PASSWORD',
                    labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xFF5E6272),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    contentPadding: EdgeInsets.only(bottom: 2.5),
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
                          backgroundColor: Color(0xFF22252D),
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
                                            child: PasswordRecovPage()),
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
                    child: Text("Forgot password?",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          email = firstController.text;
                          password = secondController.text;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  // Retrieve the text by using the
                                  // TextEditingController.
                                  content: Text(
                                      "Email: $email \nPassword: $password",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium));
                            },
                          );

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
                      child: Text("Sign In",
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ],
                )
              ]),
            ])));
  }
}
