import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class PasswordRecovPage extends StatelessWidget {
  PasswordRecovPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sometimes... \nthings just happen!",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.025)),
          Text("Don't worry, let's get you back up and running.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.left),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05)),
          TextField(
            style: Theme.of(context).textTheme.bodySmall,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'YOUR E-MAIL',
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
                        // content: Text(
                        //     "Email: ${firstController.text} \nPassword: ${secondController.text}",
                        //     style: Theme.of(context).textTheme.labelMedium)
                        content: Text('hello world!',
                            style: Theme.of(context).textTheme.labelMedium));
                  },
                );
                // setState(() {
                //   //TODO: Add effect of pressing the button
                // });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.50, 55),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text("Send Recovery Link",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ]),
        ],
      ),
    ));
  }
}
