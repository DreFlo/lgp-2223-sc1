import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/animation_test/main.dart';
import 'package:src/daos/person_dao.dart';
import 'package:src/models/person.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:like_button/like_button.dart';

import '../../widgets/leisure_tag.dart';

class MyMediaPage extends StatelessWidget {
  final String title, synopsis, type;
  final bool isFavorite;
  final List<String> tags, notes, data;

  const MyMediaPage(
      {Key? key,
      required this.title,
      required this.synopsis,
      required this.tags,
      required this.notes,
      required this.data,
      required this.type,
      required this.isFavorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
      height: 1500,
      child: Column(children: [
        Row(children: [
          Stack(children: [
                  Positioned(
                      top: 20,
                      child: Container(
                        width: 115,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF414554),
                        ),
                        child: Text(
                          this.type.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
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
                
            Positioned(
                child: Row(children: [
                  Container(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Text(
                                  this.title.toUpperCase(),
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
                                      Icons.favorite,
                                      color:
                                          isLiked ? leisureColor : Colors.grey,
                                      size: 40,
                                    );
                                  },
                                  circleColor: CircleColor(
                                      start: Colors.white, end: leisureColor),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor: leisureColor,
                                    dotSecondaryColor: leisureColor,
                                  ),
                                  isLiked: this.isFavorite,
                                  onTap: (isLiked) {
                                    return Future.delayed(
                                        Duration(milliseconds: 1), () {
                                      isLiked = !isLiked;
                                      return isLiked;
                                    });
                                  },
                                ))
                          ],
                        )),
                  )
                ]))
          ])
        ]),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 50,
                  child: Wrap(
                      spacing: 7.6,
                      alignment: WrapAlignment.start,
                      runSpacing: 7.5,
                      children: [
                        LeisureTag(text: "85% love it"),
                        LeisureTag(text: "Fantasy"),
                        LeisureTag(text: "2015"),
                        LeisureTag(text: "Right up your alley!")
                      ])),
            ])),
        SizedBox(height: 35),
        Row(children: [
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context).synopsis,
                style: Theme.of(context).textTheme.displayMedium,
              ))
        ]),
        SizedBox(height: 5),
        Row(children: [
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text(
                this.synopsis,
                style: Theme.of(context).textTheme.bodySmall,
              ))
        ]),
      ]),
    );
  }
}
