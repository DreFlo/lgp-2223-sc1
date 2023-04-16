import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'leisure_tag.dart';

class ReviewNoteBar extends StatefulWidget {
  final Reaction reaction;
  final String? text;

  const ReviewNoteBar({Key? key, required this.reaction, required this.text})
      : super(key: key);

  @override
  State<ReviewNoteBar> createState() => _ReviewNoteBarState();
}

class _ReviewNoteBarState extends State<ReviewNoteBar> {
  getEmoji() {
    switch (widget.reaction) {
      case Reaction.hate:
        return "${Emojis.confoundedFace} HATE IT";
      case Reaction.dislike:
        return "${Emojis.pensiveFace} DISLIKE IT";
      case Reaction.neutral:
        return "${Emojis.neutralFace} DON'T KNOW HOW TO FEEL...";
      case Reaction.like:
        return "${Emojis.smilingFace} LIKE IT";
      case Reaction.love:
        return "${Emojis.smilingCatWithHeartEyes} LOVE IT!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: lightGray),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getEmoji(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              LeisureTag(
                  text: AppLocalizations.of(context).your_review.toUpperCase(),
                  backgroundColor: leisureColor)
            ]),
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Flexible(
                child: Text(widget.text!,
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)))
          ])
        ]));
  }
}
