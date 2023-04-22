import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Implement Login page

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
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  onPressed: () {
                    print("Pressed signin btn!");
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            // Retrieve the text by using the
                            // TextEditingController.
                            content: Text(
                                "Email: ${firstController.text} \nPassword: ${secondController.text}",
                                style:
                                    Theme.of(context).textTheme.labelMedium));
                      },
                    );
                    // setState(() {
                    //   //TODO: Add effect of pressing the button
                    // });
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
              ]),
            ])));
  }
}
