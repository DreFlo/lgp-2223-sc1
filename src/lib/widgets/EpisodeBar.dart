import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class EpisodeBar extends StatefulWidget {
  final String code, title;
  bool favorite, watched;

  EpisodeBar(
      {Key? key,
      required this.code,
      required this.title,
      required this.favorite,
      required this.watched})
      : super(key: key);

  @override
  State<EpisodeBar> createState() => _EpisodeBarState();
}

class _EpisodeBarState extends State<EpisodeBar> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: lightGray),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(widget.code,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600))
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(
                          widget.title.length > 20
                              ? widget.title.substring(0, 20) + '...'
                              : widget.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal))
                    ])
                  ]),
          Column(children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    widget.favorite = !widget.favorite;
                    setState(() {});

                    //TODO: Add functionality for favoriting episode.
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(45, 45)),
                    backgroundColor: MaterialStateProperty.all(
                        widget.favorite ? leisureColor : Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                        widget.favorite ? Colors.white : leisureColor),
                    shape:
                        MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                  ),
                  child: Icon(Icons.favorite_rounded)),
              ElevatedButton(
                  onPressed: () {
                    widget.watched = !widget.watched;
                    setState(() {});

                    //TODO: Add functionality for watching episode.
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(45, 45)),
                    backgroundColor: MaterialStateProperty.all(
                        widget.watched ? leisureColor : Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                        widget.watched ? Colors.white : leisureColor),
                    shape:
                        MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                  ),
                  child: Icon(Icons.remove_red_eye_outlined))
            ]),
            ]),
        ]));
  }
}
