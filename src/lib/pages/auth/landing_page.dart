import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:src/pages/auth/login_page.dart';
import 'package:src/pages/auth/signup_page.dart';
import 'package:src/themes/colors.dart';

class LandingPage extends StatelessWidget {
  int _pageCount = 0;

  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding( padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.35,
            child: SvgPicture.asset('assets/icons/wokka_mascot.svg'),
          ),
          //TODO: Change this to Stateful Widget and add dots
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
          Padding( padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.75, 55),
                      backgroundColor: grayButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
            child: Text("Sign Up",
                        style: Theme.of(context).textTheme.labelLarge),
            onPressed: () {
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
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.75, 55),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
            child: Text("Login",
                        style: Theme.of(context).textTheme.labelLarge),
            onPressed: () {
              print("Pressed LogIn!");
              Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));
            },
          ),
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.35, 55),
                      backgroundColor: grayButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
            child: const Icon(Icons.g_mobiledata_rounded, size: 50.0, color: personalColor), //TODO: Get Google Icon and colors
              onPressed: () {
                print("Pressed Google Button!");

                //TODO: Connection with google
              },
            ),
          const SizedBox(width: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.35, 55),
                      backgroundColor: grayButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
            child: const Icon(Icons.facebook, size: 40.0, color: fitnessColor), //TODO: Get Facebook Color
              onPressed: () {
                print("Pressed FacebookButton!");

                //TODO: Connection with Facebook
              },
            ),
          ]),
        ],
      ),
    );
  }
}
