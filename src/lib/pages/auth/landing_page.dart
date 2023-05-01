import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:src/pages/auth/login_page.dart';
import 'package:src/pages/auth/signup_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _pageCount = 0;

  List<Widget> getCarouselChildren() {
    List<Widget> result = [];

    result.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).land_title_1,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        Text(
          AppLocalizations.of(context).land_subtitle_1,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.start,
        ),
      ],
    ));

    result.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).land_title_2,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        Text(
          AppLocalizations.of(context).land_subtitle_2,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.start,
        ),
      ],
    ));

    result.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).land_title_3,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        Text(
          AppLocalizations.of(context).land_subtitle_3,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.start,
        ),
      ],
    ));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.075)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.35,
            child: SvgPicture.asset('assets/icons/wokka_mascot.svg'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.90,
                  // Add dot indicator options
                  enableInfiniteScroll: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayInterval: const Duration(seconds: 6),
                  height: 145,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _pageCount = index;
                    });
                  },
                ),
                items: getCarouselChildren()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(_pageCount == 0 ? Icons.circle : Icons.circle_outlined,
                      color: _pageCount == 0 ? primaryColor : Colors.white,
                      size: 15.0),
                  Icon(_pageCount == 1 ? Icons.circle : Icons.circle_outlined,
                      color: _pageCount == 1 ? primaryColor : Colors.white,
                      size: 15.0),
                  Icon(_pageCount == 2 ? Icons.circle : Icons.circle_outlined,
                      color: _pageCount == 2 ? primaryColor : Colors.white,
                      size: 15.0),
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.035)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.75, 55),
              backgroundColor: grayButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: Text(AppLocalizations.of(context).sign_up,
                style: Theme.of(context).textTheme.labelLarge),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF22252D),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.0)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.75,
                      minChildSize: 0.75,
                      maxChildSize: 0.80,
                      builder: (context, scrollController) => Stack(
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                SingleChildScrollView(
                                    controller: scrollController,
                                    child: const SignUpPage()),
                              ])));
            },
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.75, 55),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            child: Text(AppLocalizations.of(context).login,
                style: Theme.of(context).textTheme.labelLarge),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF22252D),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.0)),
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
                                    child: const LoginPage()),
                              ])));
            },
          ),
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.35, 55),
                backgroundColor: grayButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: SizedBox(
                width: 35.0,
                height: 35.0,
                child: SvgPicture.asset('assets/images/google_logo.svg'),
              ),
              onPressed: () {
                //print("Pressed Google Button!");

                //TODO: Connection with google (MVP?)
              },
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.35, 55),
                backgroundColor: grayButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Icon(Icons.facebook,
                  size: 40.0, color: Color(0xFF246BFD)),
              onPressed: () {
                //("Pressed FacebookButton!");

                //TODO: Connection with Facebook (MVP?)
              },
            ),
          ]),
        ],
      ),
    );
  }
}
