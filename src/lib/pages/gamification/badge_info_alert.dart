import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/models/badges.dart';

import 'package:src/themes/colors.dart';
import 'package:src/widgets/gamification/badge_widget.dart';

class BadgeInfoAlert extends StatefulWidget {
  final Badges badge;

  const BadgeInfoAlert({Key? key, required this.badge}) : super(key: key);

  @override
  State<BadgeInfoAlert> createState() => _BadgeInfoAlertState();
}

class _BadgeInfoAlertState extends State<BadgeInfoAlert>
    with TickerProviderStateMixin {
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
      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      actionsPadding: const EdgeInsets.symmetric(vertical: 10),
      content: Wrap(alignment: WrapAlignment.center, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [BadgeWidget(badge: widget.badge)]),
        const Divider(height: 2.5, color: Colors.transparent),
        (widget.badge.name.split('\n').length > 1
            ? Wrap(alignment: WrapAlignment.center, spacing: -1, children: [
                Text(
                  widget.badge.name.split('\n')[0],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.badge.name.split('\n')[1],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600),
                ),
                const Divider(height: 10, color: Colors.transparent),
              ])
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(child:
                Text(
                  widget.badge.name.split('\n')[0],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ))
              ])),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: 
          Text(
            widget.badge.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 16,
                fontWeight: FontWeight.normal)),
          )
        ]),
        const Divider(height: 20, color: Colors.transparent),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            AppLocalizations.of(context).quokka_fact,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: grayText, fontSize: 12, fontWeight: FontWeight.normal),
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Text(widget.badge.fact,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
          )
        ]),
      ]),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red[600]),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)))),
          ),
          child: Text(AppLocalizations.of(context).close,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        )
      ],
    );
  }
}
