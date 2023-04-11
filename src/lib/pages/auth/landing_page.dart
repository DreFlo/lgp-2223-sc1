import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  int pageCount = 0;

  LandingPage({Key? key, required this.pageCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Implement landing page

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: [Text("Wokka Icon!", textAlign: TextAlign.center)],),
          Row(children: [Text("Caroussel of phrases!", textAlign: TextAlign.center)],),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(0, 46, 42, 78)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))))),
              child: const Text('Sign Up'),
              onPressed: () {
                print("Pressed Sign In!");
              },),
          ElevatedButton(
            style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(0, 33, 8, 201)),
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
              },),
          Row(children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color(0x2E2A4E)),
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
              },),
          ElevatedButton(
            style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color(0x2E2A4E)),
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
              },),
          ]),
        ],
      ),
    );
  }
}
