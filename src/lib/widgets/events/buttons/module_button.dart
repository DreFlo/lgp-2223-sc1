import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class ModuleButton extends StatefulWidget {
  final GlobalKey buttonKey;
  final Color moduleColor;
  final Function setModuleColor;
  final Function clearActivities;

  const ModuleButton({Key? key,
    required this.buttonKey,
    required this.moduleColor,
    required this.setModuleColor,
    required this.clearActivities
  }) : super(key: key);

  @override
  State<ModuleButton> createState() => _ModuleButtonState();
}

class _ModuleButtonState extends State<ModuleButton> {
  @override
  initState() {
    super.initState();
  }

  List<PopupMenuItem> getModuleColorsMenuItems() {
    List<PopupMenuItem> modulesMenuItems = [];

    modulesMenuItems.add(PopupMenuItem(
        value: studentColor,
        child: Text(
          AppLocalizations.of(context).student,
          style: Theme.of(context).textTheme.bodyMedium,
        )));

    modulesMenuItems.add(PopupMenuItem(
      value: leisureColor,
      child: Text(
        AppLocalizations.of(context).leisure,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ));

    return modulesMenuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        child: AspectRatio(
            aspectRatio: 1,
            child: Transform.rotate(
                angle: -math.pi / 4,
                child: ElevatedButton(
                  key: widget.buttonKey,
                  style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    alignment: const Alignment(0, 0),
                    backgroundColor: MaterialStateProperty.all(widget.moduleColor),
                  ),
                  onPressed: () {
                    final RenderBox button = widget.buttonKey.currentContext!
                        .findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;
                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(Offset.zero, ancestor: overlay),
                        button.localToGlobal(
                            button.size.bottomRight(Offset.zero),
                            ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );
                    showMenu(
                      context: context,
                      position: position,
                      color: const Color(0xFF17181C),
                      items: getModuleColorsMenuItems(),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          if (value != widget.moduleColor) {
                            widget.setModuleColor(value);
                            widget.clearActivities();
                          }
                        });
                      }
                    });
                  }, child: null,
                ))));
  }
}
