import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/gamification/badge_mocks.dart';
import 'package:src/widgets/gamification/badge_widget.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({Key? key}) : super(key: key);

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  late String image;

  @override
  initState() {
    super.initState();
  }

  List<Widget> getBadges() {
    List<Widget> badges = [];
    badges.add(BadgeWidget(
      title: badgeOne['title'].toString(),
      colors: badgeOneColors.split(','),
      description: badgeOne['description'].toString(),
      icon: badgeOne['icon'].toString(),
      fact: badgeOne['fact'].toString(),
      onBadgePage: true,
      showTitle: true,
      isUnlocked: false,
    ));

    badges.add(BadgeWidget(
      title: badgeTwo['title'].toString(),
      colors: badgeTwoColors.split(','),
      description: badgeTwo['description'].toString(),
      icon: badgeTwo['icon'].toString(),
      fact: badgeTwo['fact'].toString(),
      onBadgePage: true,
      showTitle: true,
      isUnlocked: false,
    ));

    badges.add(BadgeWidget(
      title: badgeThree['title'].toString(),
      colors: badgeThreeColors.split(','),
      description: badgeThree['description'].toString(),
      icon: badgeThree['icon'].toString(),
      fact: badgeThree['fact'].toString(),
      onBadgePage: true,
      showTitle: true,
      isUnlocked: true,
    ));

    return badges;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: modalLightBackground,
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Wrap(spacing: 10, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Container(
                      width: 115,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF414554),
                      ),
                    ))
              ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).badges,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 30),
              GridView.count(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 30,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: getBadges()),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(AppLocalizations.of(context).more_to_come,
                    style: const TextStyle(
                        color: grayText,
                        fontWeight: FontWeight.normal,
                        fontSize: 14))
              ]),
              const SizedBox(height: 100),
            ])));
  }
}
