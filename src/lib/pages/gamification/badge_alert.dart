import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/gamification/badges_page.dart';

import 'package:src/themes/colors.dart';
import 'package:src/widgets/gamification/badge_widget.dart';

class BadgeAlert extends StatefulWidget {
  final BadgeWidget badge;

  const BadgeAlert(
      {Key? key,
      required this.badge})
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
        const Divider(color: Colors.transparent),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          widget.badge
        ]),
        const Divider(height: 2.5, color: Colors.transparent),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            widget.badge.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            widget.badge.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          )
        ]),
        const Divider(height: 10, color: Colors.transparent),
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
            showModalBottomSheet(
              backgroundColor: modalLightBackground,
              context: context,
              builder: (builder) => const BadgesPage());
          },

          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
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
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
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
