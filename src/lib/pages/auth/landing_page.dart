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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding( padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.25)),
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
          Padding( padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2)),
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
              print("Pressed Sign Up!");
              Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpPage()));
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
