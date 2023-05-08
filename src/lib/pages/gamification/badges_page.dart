import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

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
    for (int i = 0; i < 10; i++) {
      badges.add(
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF414554),
          ),
        ),
      );
    }
    return badges;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: modalLightBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Wrap(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).badges,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Flexible(
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: getBadges(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
