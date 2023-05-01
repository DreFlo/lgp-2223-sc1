import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/models/media/media.dart';
import 'package:src/themes/colors.dart';
import 'package:like_button/like_button.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/leisure/leisure_tag.dart';

abstract class MediaPage<T extends Media> extends StatefulWidget {
  final T item;
  final Function(bool) toggleFavorite;

  const MediaPage({
    Key? key,
    required this.item,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  MediaPageState<T> createState();
}

abstract class MediaPageState<T extends Media> extends State<MediaPage<T>> {
  bool isFavorite = false;
  List<String> leisureTags = [];

  @override
  void initState() {
    super.initState();
    isFavorite = widget.item.favorite;
    leisureTags = getLeisureTags();
  }

  String getLength(context);

  List<String> getLeisureTags();

  showSmallCastList(context) {
    List<String> firstTen;
    List<String> widgetCast = widget.item.participants.split(', ');
    if (widgetCast.length >= 10) {
      firstTen = widgetCast.sublist(0, 10);
    } else if (widgetCast.isNotEmpty) {
      firstTen = widgetCast;
    } else {
      firstTen = [AppLocalizations.of(context).no_cast];
    }
    return Row(children: [
      Text(
        firstTen.join("\n"),
        softWrap: true,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodySmall,
      )
    ]);
  }

  Image showImage();

  double countWords() {
    double wordCount = 0;
    for (String str in leisureTags) {
      List<String> wordsList = str.split(" ");
      for (String letter in wordsList) {
        wordCount += letter.length;
      }
    }
    return wordCount;
  }

  String getType();

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
                          getType().toUpperCase(),
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
                      child: showImage(),
                    ),
                  ),
                ]),
            Row(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Stack(clipBehavior: Clip.none, children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Text(
                          widget.item.name.toUpperCase(),
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
                              //_toggleFavorite();
                              widget.toggleFavorite(isLiked);
                              return isLiked;
                            });
                          },
                        ))
                  ]))
            ]),
          ],
        )
      ]),
      const SizedBox(height: 7.5),
      ((leisureTags[0].contains(".") || leisureTags[0].contains(','))
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(children: [
                Text(leisureTags[0],
                    style: const TextStyle(
                        color: grayText,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic))
              ]))
          : const Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.5), child: Text(''))),
      const SizedBox(height: 15),
      Row(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Wrap(
                spacing: 6.5,
                alignment: WrapAlignment.center,
                runSpacing: 7.5,
                children: [
                  for (var i = 1; i < leisureTags.length; i++)
                    LeisureTag(text: leisureTags[i])
                ]))
      ]),
      const SizedBox(height: 30),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).synopsis,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Flex(direction: Axis.horizontal, children: [
        Flexible(
          child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Text(
                widget.item.description,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodySmall,
              )),
        ),
      ]),
      const SizedBox(height: 35),
      Row(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              (widget.item.type != MediaDBTypes.book
                  ? AppLocalizations.of(context).cast
                  : AppLocalizations.of(context).author),
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Row(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: showSmallCastList(context),
        ),
      ]),
      const SizedBox(height: 35),
      Row(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
