import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:src/models/badges.dart';

class BadgeWidget extends StatefulWidget {
  final Badges badge;

  const BadgeWidget({Key? key, required this.badge}) : super(key: key);

  @override
  State<BadgeWidget> createState() => _BadgeWidgetState();
}

class _BadgeWidgetState extends State<BadgeWidget>
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
    return Wrap(alignment: WrapAlignment.center, children: [
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
          child: Icon(eval(widget.badge.icon), size: 50, color: Colors.white)),
    ]);
  }
}
