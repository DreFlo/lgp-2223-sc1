import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/badges_dao.dart';
import 'package:src/models/badges.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/gamification/badge_page_widget.dart';

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

  Future<List<Widget>> getBadges() async {
    List<Badges> badges = await serviceLocator<BadgesDao>().findAllBadges();
    List<Widget> badgesWidgets = [];

    for (int i = 0; i < badges.length; i++) {
      bool hasBadge = await checkUserHasBadge(badges[i].id!);
      badgesWidgets.add(BadgePageWidget(
        badge: badges[i],
        onBadgePage: true,
        isUnlocked: hasBadge,
      ));
    }

    return badgesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
        future: getBadges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: modalLightBackground,
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Wrap(spacing: 10, children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
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
                        children: snapshot.data!,
                      ),
                      const SizedBox(height: 40),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context).more_to_come,
                                style: const TextStyle(
                                    color: grayText,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14))
                          ]),
                      const SizedBox(height: 100),
                    ])));
          }
        });
  }
}
