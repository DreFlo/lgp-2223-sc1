import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/constants.dart';

import 'package:src/themes/colors.dart';

class GainedXPToast extends StatefulWidget {
  final int value;
  final int level;
  final int points;
  final int levelXP = 100;

  const GainedXPToast(
      {    Key? key,
      required this.value,
      required this.level,
      required this.points}): super(key: key);

  @override
  State<GainedXPToast> createState() => _GainedXPToastState();
}

class _GainedXPToastState extends State<GainedXPToast>
    with TickerProviderStateMixin {
  late int progress;
  late AnimationController controller;
  late AnimationController opacityController;
  late Animation<double> animation;
  late Animation<double> opacityAnimation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);

    animation = Tween<double>(
            begin: widget.value.toDouble(),
            end: (widget.value + widget.points).toDouble())
        .animate(controller)
      ..addListener(() {
        setState(() {
          progress = animation.value.toInt();
        });
      });

    opacityController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);

    opacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(opacityController)
          ..addListener(() {
            setState(() {
              progress = opacityAnimation.value.toInt();
            });
          });

    Future.delayed(const Duration(seconds: 1), () {
      controller.forward();
    });

    opacityController.forward();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 100,
      decoration: BoxDecoration(
        color: toastBackground,
        boxShadow: const [BoxShadow(color: shadowColorLight, blurRadius: 10)],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                    width: 50,
                    child: Image(
                        image: AssetImage('assets/images/excited_emil.png')))
              ],
            )),
        const SizedBox(width: 30),
        Flexible(
            flex: 8,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(children: [
                Text(
                  AppLocalizations.of(context).gained_xp,
                  key: const Key("gained_xp_toast_text"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                      Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: LinearProgressIndicator(
                                        value: animation.value / widget.levelXP,
                                        backgroundColor:
                                            const Color(0xFF414554),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                primaryColor)))),
                            Positioned(
                              left: 10,
                              child: Text(
                                  "${AppLocalizations.of(context).level} ${widget.level}"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )
                          ]),
                      Positioned(
                          right: 10,
                          child: FadeTransition(
                              opacity: opacityAnimation,
                              child: Text("+ ${widget.points}".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ))))
                    ])),
              ]),
            ]))
      ]),
    );
  }
}
