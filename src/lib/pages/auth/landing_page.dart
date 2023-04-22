import 'package:flutter/material.dart';
import 'package:src/pages/auth/login_page.dart';
import 'package:src/pages/auth/signup_page.dart';
import 'package:src/themes/colors.dart';

class LandingPage extends StatelessWidget {
  int _pageCount = 0;

  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Implement landing page

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Wokka Icon!",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          //TODO: Finish the horizontal list view to be closer to mockup and to have dot indicators
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Text(
                  "Caroussel of phrases 1!",
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Caroussel of phrases 2!",
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Caroussel of phrases 3!",
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(0, 46, 42, 78)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))))),
            child: const Text('Sign Up'),
            onPressed: () {
              print("Pressed Sign Up!");
              showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Color(0xFF22252D),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.75,
                          minChildSize: 0.35,
                          maxChildSize: 0.95,
                          builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.topCenter,
                                  children: [
                                    SingleChildScrollView(
                                        controller: scrollController,
                                        child: SignUpPage()),
                                  ])));
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(0, 33, 8, 201)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))))),
            child: const Text('Login'),
            onPressed: () {
              print("Pressed LogIn!");
              Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));
            },
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0x2E2A4E)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))))),
              child: const Text('Google'),
              onPressed: () {
                print("Pressed Google Button!");
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0x2E2A4E)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))))),
              child: const Text('Facebook'),
              onPressed: () {
                print("Pressed FacebookButton!");
              },
            ),
          ]),
        ],
      ),
    );
  }
}
