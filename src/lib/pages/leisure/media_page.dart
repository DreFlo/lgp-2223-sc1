// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:like_button/like_button.dart';
import '../../widgets/leisure/leisure_tag.dart';
import 'package:src/utils/enums.dart';

class MediaPage extends StatelessWidget {
  final String title, synopsis, type;
  final bool isFavorite;
  final Status status;
  final List<String> cast;
  final Map<String, String> notes;
  final List<int> length;

  const MediaPage(
      {Key? key,
      required this.title,
      required this.synopsis,
      required this.type,
      required this.cast,
      required this.length,
      required this.notes,
      required this.isFavorite,
      this.status = Status.nothing})
      : super(key: key);

  String getLength(context) {
    if (type == "TV Show") {
      return length[0].toString() +
          AppLocalizations.of(context).seasons +
          length[1].toString() +
          AppLocalizations.of(context).episodes +
          length[2].toString() +
          AppLocalizations.of(context).minutes_each;
    } else if (type == "Book") {
      return length[0].toString() + AppLocalizations.of(context).pages;
    } else {
      return length[0].toString() + AppLocalizations.of(context).minutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: [
      Row(children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Stack(
                clipBehavior: Clip.antiAlias,
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Positioned(
                      top: 20,
                      child: Container(
                        width: 115,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF414554),
                        ),
                        child: Text(
                          type.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.01, 0.5, 0.9],
                          colors: [
                            Color(0xFF22252D),
                            Colors.transparent,
                            Color(0xFF22252D)
                          ],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstOut,
                      child: Image.asset(
                        'assets/images/poster.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ]),
            Row(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Stack(clipBehavior: Clip.none, children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Text(
                          title.toUpperCase(),
                          softWrap: true,
                          textWidthBasis: TextWidthBasis.longestLine,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                          maxLines: 5,
                        )),
                    Positioned(
                        top: 15,
                        left: MediaQuery.of(context).size.width * 0.80,
                        child: LikeButton(
                          size: 40,
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite_rounded,
                              color: isLiked ? leisureColor : Colors.grey,
                              size: 40,
                            );
                          },
                          circleColor: const CircleColor(
                              start: Colors.white, end: leisureColor),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: leisureColor,
                            dotSecondaryColor: leisureColor,
                          ),
                          isLiked: isFavorite,
                          onTap: (isLiked) {
                            return Future.delayed(
                                const Duration(milliseconds: 1), () {
                              isLiked = !isLiked;
                              return isLiked;
                            });
                          },
                        ))
                  ]))
            ]),
          ],
        )
      ]),
      const SizedBox(height: 20),
      Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                child: Wrap(
                    spacing: 7.6,
                    alignment: WrapAlignment.start,
                    runSpacing: 7.5,
                    children: const [
                      LeisureTag(text: "85% love it"),
                      LeisureTag(text: "Fantasy"),
                      LeisureTag(text: "2015"),
                      LeisureTag(text: "Right up your alley!")
                    ])),
          ])),
      const SizedBox(height: 35),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).synopsis,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Flexible(
        child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Text(
              synopsis,
              softWrap: true,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodySmall,
            )),
      ),
      const SizedBox(height: 35),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).cast,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Row(children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Row(children: [
            Text(
              cast.join("\n"),
              softWrap: true,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ]),
        ),
      ]),
      const SizedBox(height: 35),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).length,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Row(children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Row(children: [
            Text(
              getLength(context),
              softWrap: true,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ]),
        ),
      ]),
      const SizedBox(height: 100)
    ]);
  }
}