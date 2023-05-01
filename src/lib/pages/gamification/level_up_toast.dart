import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/constants.dart';

import 'package:src/themes/colors.dart';

class LevelUpToast extends StatefulWidget {
  final int oldLevel;
  final int newLevel;

  const LevelUpToast({super.key, required this.oldLevel, required this.newLevel});

  @override
  State<LevelUpToast> createState() => _LevelUpToastState();
}

class _LevelUpToastState extends State<LevelUpToast>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  late AnimationController colorController;
  late Animation<Color> purpleRed;

  late AnimationController colorController2;
  late Animation<Color> redGreen;

  late AnimationController colorController3;
  late Animation<Color> greenYellow;

  late AnimationController colorController4;
  late Animation<Color> yellowBlue;

  late AnimationController colorController5;
  late Animation<Color> bluePurple;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    colorController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    colorController2 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    colorController3 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    colorController4 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    colorController5 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    animation = Tween<double>(begin: 0, end: 100).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    purpleRed = Tween<Color>(begin: primaryColor, end: leisureColor)
        .animate(colorController)
      ..addListener(() {
        setState(() {});
      });

    redGreen = Tween<Color>(begin: leisureColor, end: personalColor)
        .animate(colorController2)
      ..addListener(() {
        setState(() {});
      });

    greenYellow = Tween<Color>(begin: personalColor, end: studentColor)
        .animate(colorController3)
      ..addListener(() {
        setState(() {});
      });

    yellowBlue = Tween<Color>(begin: studentColor, end: fitnessColor)
        .animate(colorController4)
      ..addListener(() {
        setState(() {});
      });

    bluePurple = Tween<Color>(begin: fitnessColor, end: primaryColor)
        .animate(colorController5)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(const Duration(milliseconds: 500), () {
      controller.forward();
    });

    colorController.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      colorController2.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      colorController3.forward();
    });

    Future.delayed(const Duration(milliseconds: 3500), () {
      colorController4.forward();
    });

    Future.delayed(const Duration(milliseconds: 4000), () {
      colorController5.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    colorController.dispose();
    colorController2.dispose();
    colorController3.dispose();
    colorController4.dispose();
    colorController5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 125,
      decoration: BoxDecoration(
        color: toastBackground,
        boxShadow: const [BoxShadow(color: shadowColorLight, blurRadius: 10)],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(children: [
            Text(
              AppLocalizations.of(context).level_up.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Text(
              "${AppLocalizations.of(context).level_up_2}${widget.newLevel}${AppLocalizations.of(context).level_up_3}",
              style: const TextStyle(
                color: grayBackground,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            )
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child:
                    Stack(alignment: AlignmentDirectional.centerEnd, children: [
              Stack(alignment: AlignmentDirectional.centerStart, children: [
                Container(
                    height: 25,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                            value: animation.value / 100,
                            backgroundColor: const Color(0xFF414554),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                primaryColor)))),
                Positioned(
                  left: 10,
                  child: Text(
                      "${AppLocalizations.of(context).level} ${widget.oldLevel}"
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                )
              ]),
            ])),
          ]),
        ]))
      ]),
    );
  }
}
