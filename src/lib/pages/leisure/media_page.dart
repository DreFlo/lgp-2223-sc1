import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:like_button/like_button.dart';
import 'package:src/widgets/leisure/leisure_tag.dart';
import 'package:src/utils/enums.dart';

class MediaPage extends StatefulWidget {
  final String title, synopsis, type;
  final bool isFavorite;
  final Status status;
  final List<dynamic> cast;
  final List<int?> length;
  final String image;
  final List<String> leisureTags;
  final Function(bool) toggleFavorite;

  const MediaPage(
      {Key? key,
      required this.title,
      required this.synopsis,
      required this.type,
      required this.cast, //for books, it's the author
      required this.length,
      required this.isFavorite,
      required this.image,
      required this.leisureTags,
      required this.toggleFavorite,
      this.status = Status.nothing})
      : super(key: key);

  @override
  MediaPageState createState() => MediaPageState();
}

class MediaPageState extends State<MediaPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  String getLength(context) {
    if (widget.type == "TV Show") {
      if (widget.length[2] == null) {
        if (widget.length[0]! > 1) {
          return widget.length[0].toString() +
              AppLocalizations.of(context).seasons +
              widget.length[1].toString() +
              AppLocalizations.of(context).episodes_no_duration;
        } else {
          return widget.length[0].toString() +
              AppLocalizations.of(context).season +
              widget.length[1].toString() +
              AppLocalizations.of(context).episodes_no_duration;
        }
      }
      return widget.length[0].toString() +
          AppLocalizations.of(context).seasons +
          widget.length[1].toString() +
          AppLocalizations.of(context).episodes +
          widget.length[2].toString() +
          AppLocalizations.of(context).minutes_each;
    } else if (widget.type == "Book") {
      return widget.length[0].toString() + AppLocalizations.of(context).pages;
    } else {
      return widget.length[0].toString() + AppLocalizations.of(context).minutes;
    }
  }

  showSmallCastList(context) {
    List<dynamic> firstTen;
    if (widget.cast.length >= 10) {
      firstTen = widget.cast.sublist(0, 10);
    } else if (widget.cast.isNotEmpty) {
      firstTen = widget.cast;
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

  showImage(String type) {
    if (type == 'Book') {
      return Image.network(
        widget.image,
        fit: BoxFit.fitWidth,
      );
    } else {
      return Image.network(
        'https://image.tmdb.org/t/p/w500${widget.image}',
        fit: BoxFit.fitWidth,
      );
    }
  }

  double countWords() {
    double wordCount = 0;
    for (String str in widget.leisureTags) {
      List<String> wordsList = str.split(" ");
      for (String letter in wordsList) {
        wordCount += letter.length;
      }
    }
    return wordCount;
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
                          widget.type.toUpperCase(),
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
                      child: showImage(widget.type),
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
                          widget.title.toUpperCase(),
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
                          isLiked: _isFavorite,
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
      const SizedBox(height: 20),
      Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 1.75 * countWords(),
                child: Wrap(
                    spacing: 7.6,
                    alignment: WrapAlignment.start,
                    runSpacing: 7.5,
                    children: [
                      for (var i = 0; i < widget.leisureTags.length; i++)
                        LeisureTag(text: widget.leisureTags[i])
                    ])),
          ])),
      const SizedBox(height: 15),
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
                widget.synopsis,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodySmall,
              )),
        ),
      ]),
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
          child: showSmallCastList(context),
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
