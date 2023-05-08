import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:src/themes/colors.dart';

class BadgeAlert extends StatefulWidget {
  final String title;
  final String description;
  final List<String> colors;
  final String icon;

  const BadgeAlert(
      {Key? key,
      required this.title,
      required this.description,
      required this.colors,
      required this.icon})
      : super(key: key);

  @override
  State<BadgeAlert> createState() => _BadgeAlertState();
}

class _BadgeAlertState extends State<BadgeAlert> with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Color> getColors() {
    List<Color> colors = [];
    for (String color in widget.colors) {
      colors.add(Color(int.parse(color, radix: 16)));
    }
    return colors;
  }

  IconData eval(String icon) {
    if (icon == 'FontAwesome.fire') {
      return FontAwesome.fire;
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      backgroundColor: lightGray,
      contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      actionsPadding: const EdgeInsets.symmetric(vertical: 20),
      content: Wrap(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            AppLocalizations.of(context).won_badge,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )
        ]),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: getColors(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  color: Colors.white),
              child: Icon(eval(widget.icon), size: 50, color: Colors.white))
        ]),
        const Divider(height: 2.5),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            widget.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          )
        ]),
        const Divider(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context).won_badge_2,
                style: const TextStyle(
                    color: grayText,
                    fontSize: 16,
                    fontWeight: FontWeight.normal))
          ],
        )
      ]),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            //TODO: Open Badges Page
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
          child: Text(AppLocalizations.of(context).check_it_out,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red[600]),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)))),
          ),
          child: Text(AppLocalizations.of(context).maybe_later,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        )
      ],
    );
  }
}
