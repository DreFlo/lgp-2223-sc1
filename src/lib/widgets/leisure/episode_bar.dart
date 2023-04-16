import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import '../../pages/leisure/add_episode_note_form.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';

class EpisodeBar extends StatefulWidget {
  final MediaVideoEpisodeSuperEntity episode;
  final String code;
  final bool favorite, watched;

  EpisodeBar({
    Key? key,
    required int season,
    required this.episode,
  })  : code =
            'S${season.toString().padLeft(2, '0')}E${episode.number.toString().padLeft(2, '0')}',
        favorite = episode.favorite,
        watched = episode.status == Status.done ? true : false,
        super(key: key);

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
                  widget.episode.name.length > 20
                      ? '${widget.episode.name.substring(0, 20)}...'
                      : widget.episode.name,
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
