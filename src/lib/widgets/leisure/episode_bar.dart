import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/pages/leisure/add_episode_note_form.dart';

class EpisodeBar extends StatefulWidget {
  final String code, title;
  final bool favorite, watched;

  const EpisodeBar(
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
  late bool favorite, watched;

  @override
  initState() {
    favorite = widget.favorite;
    watched = widget.watched;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: lightGray),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      ? '${widget.title.substring(0, 20)}...'
                      : widget.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal))
            ])
          ]),
          Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    favorite = !favorite;
                    setState(() {});

                    //TODO: Add functionality for favoriting episode.
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(45, 45)),
                    backgroundColor: MaterialStateProperty.all(
                        favorite ? leisureColor : Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                        favorite ? Colors.white : leisureColor),
                    shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder()),
                  ),
                  child: const Icon(Icons.favorite_rounded)),
              ElevatedButton(
                  onPressed: () {
                    watched = !watched;
                    setState(() {});

                    //TODO: Add functionality for watching episode.
                  },
                  onLongPress: () {
                    watched = !watched;
                    setState(() {});
                    //TODO: Add functionality for watching episode.

                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: const Color(0xFF22252D),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.0)),
                        ),
                        builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Stack(children: [
                              AddEpisodeNoteForm(code: widget.code),
                            ])));
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(45, 45)),
                    backgroundColor: MaterialStateProperty.all(
                        watched ? leisureColor : Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                        watched ? Colors.white : leisureColor),
                    shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder()),
                  ),
                  child: const Icon(Icons.remove_red_eye_outlined))
            ]),
          ]),
        ]));
  }
}
