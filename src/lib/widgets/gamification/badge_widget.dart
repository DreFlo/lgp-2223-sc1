import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';


class BadgeWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<String> colors;
  final String icon;
  final bool isUnlocked;

  const BadgeWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.colors,
      required this.icon,
      this.isUnlocked = true})
      : super(key: key);

  @override
  State<BadgeWidget> createState() => _BadgeWidgetState();
}

class _BadgeWidgetState extends State<BadgeWidget> with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
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
    } else if (icon == 'FontAwesome.face_flushed') {
      return FontAwesome.face_flushed;
    } else if (icon == 'FontAwesome.face_grin_hearts') {
      return FontAwesome.face_grin_hearts;
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: getColors(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            shape: BoxShape.circle,
            color: Colors.white),
        child: Icon(eval(widget.icon), size: 50, color: Colors.white));
  }
}
