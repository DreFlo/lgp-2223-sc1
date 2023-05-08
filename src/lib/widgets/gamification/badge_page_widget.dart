import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:src/models/badges.dart';
import 'package:src/pages/gamification/badge_info_alert.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/widgets/gamification/badge_widget.dart';

class BadgePageWidget extends StatefulWidget {
  final Badges badge;
  final bool isUnlocked;
  final bool showTitle;
  final bool onBadgePage;

  const BadgePageWidget(
      {Key? key,
      required this.badge,
      this.onBadgePage = false,
      this.isUnlocked = true,
      this.showTitle = false})
      : super(key: key);

  @override
  State<BadgePageWidget> createState() => _BadgePageWidgetState();
}

class _BadgePageWidgetState extends State<BadgePageWidget>
    with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
  }

  List<Color> getColors() {
    List<String> colorsBadge = widget.badge.colors.split(',');
    List<Color> colors = [];
    for (String color in colorsBadge) {
      colors.add(Color(int.parse(color, radix: 16)));
    }
    return colors;
  }

  IconData eval(String icon) {
    if (icon == 'FontAwesome.fire') {
      return FontAwesome.fire;
    } else if (icon == 'FontAwesome.face_flushed') {
      return FontAwesome.face_flushed;
    } else if (icon == 'FontAwesome.face_grin_hearts') {
      return FontAwesome.face_grin_hearts;
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (!widget.onBadgePage) {
            return;
          }

          //Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) => BadgeInfoAlert(badge: widget.badge));
        },
        child: Wrap(alignment: WrapAlignment.center, children: [
          widget.isUnlocked
              ? Container(
                  height: (widget.onBadgePage ? 50 : 100),
                  width: (widget.onBadgePage ? 50 : 100),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: getColors(),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                      color: Colors.white),
                  child: Icon(eval(widget.badge.icon),
                      size: (widget.onBadgePage ? 25 : 50),
                      color: Colors.white))
              : Container(
                  height: (widget.onBadgePage ? 50 : 100),
                  width: (widget.onBadgePage ? 50 : 100),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.blueGrey[700]!,
                        Colors.blueGrey[900]!
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                      color: Colors.white),
                  child: Opacity(
                      opacity: 0.45,
                      child: ShaderMask(
                          shaderCallback: (Rect bounds) => const LinearGradient(
                                  colors: [grayText, Colors.blueGrey])
                              .createShader(bounds),
                          child: Icon(eval(widget.badge.icon),
                              size: (widget.onBadgePage ? 25 : 50),
                              color: Colors.white)))),
          const Divider(height: 10, color: Colors.transparent),
          (widget.onBadgePage
              ? (widget.isUnlocked
                  ? Row(children: [
                      Expanded(
                          child: Text(widget.badge.name.split('\n')[0],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)))
                    ])
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(AppLocalizations.of(context).badge_to_unlock,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, color: grayText))
                    ]))
              : const SizedBox()),
        ]));
  }
}
