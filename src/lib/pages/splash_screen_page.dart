import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   "SPLASH SCREEN",
          //   style: Theme.of(context).textTheme.titleLarge,
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
            child: SvgPicture.asset('assets/icons/wokka_mascot.svg'),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.015)),
          SvgPicture.asset('assets/icons/wokka_title.svg')
        ],
      ),
    );
  }
}
