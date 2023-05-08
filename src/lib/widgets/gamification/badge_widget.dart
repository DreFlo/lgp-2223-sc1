import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BadgeWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<String> colors;
  final String icon;
  final bool isUnlocked;
  final bool showTitle;

  const BadgeWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.colors,
      required this.icon,
      this.isUnlocked = true,
      this.showTitle = false})
      : super(key: key);

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
    return Column(children: [
      widget.isUnlocked ? Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: getColors(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
              color: Colors.white),
          child: Icon(eval(widget.icon), size: 25, color: Colors.white)) :
      Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blueGrey[700]!, Colors.blueGrey[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
              color: Colors.white),
          child: Opacity(opacity: 0.45,
          child: ShaderMask(shaderCallback: (Rect bounds) => const LinearGradient(colors: [grayText, Colors.blueGrey]).createShader(bounds),
          child: Icon(eval(widget.icon), size: 25, color: Colors.white)))),
      const Divider(height: 10, color: Colors.transparent),
      widget.showTitle && widget.isUnlocked
          ? Row(children: [Expanded(child: Text(widget.title.split('\n')[0], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)))])
          : Row(children: [Expanded(child: Text(AppLocalizations.of(context).badge_to_unlock, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, color: grayText)))]),
    ]);
  }
}
