import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:src/pages/navigation_page.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/pages/auth/landing_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    serviceLocator<AuthenticationService>().isUserLoggedIn()
                        ? const NavigationPage()
                        : const LandingPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.20,
                height: MediaQuery.of(context).size.height * 0.175,
                child: SvgPicture.asset('assets/icons/wokka_mascot.svg'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.06,
                child: SvgPicture.asset('assets/icons/wokka_title.svg'),
              ),
            ]),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.05),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            height: MediaQuery.of(context).size.height * 0.03,
            child: SvgPicture.asset('assets/icons/company_logo.svg'),
          ),
        )
      ])
    ]);
  }
}
