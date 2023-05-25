import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class BadgeFact extends StatefulWidget {
  final String fact;

  const BadgeFact({Key? key, required this.fact}) : super(key: key);

  @override
  State<BadgeFact> createState() => _BadgeFactState();
}

class _BadgeFactState extends State<BadgeFact> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 105,
        margin: const EdgeInsets.only(top: 25, right: 36, left: 36),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: grayButton,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(5, 8), // changes position of shadow
            ),
          ],
        ),
        child: Wrap(
          children: [
            Row(
              children: [
                Text(AppLocalizations.of(context).did_you_know,
                    style: const TextStyle(
                        fontSize: 16,
                        color: grayText,
                        fontWeight: FontWeight.w400))
              ],
            ),
            const Divider(color: Colors.transparent, height: 1),
            Row(
              children: [
                Expanded(
                    child: Text(widget.fact,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w400)))
              ],
            )
          ],
        ));
  }
}
