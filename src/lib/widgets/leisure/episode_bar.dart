import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/service_locator.dart';
import '../../pages/leisure/add_episode_note_form.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';

class EpisodeBar extends StatefulWidget {
  final MediaVideoEpisodeSuperEntity episode;
  final String code;

  EpisodeBar({
    Key? key,
    required int season,
    required this.episode,
  })  : code =
            'S${season.toString().padLeft(2, '0')}E${episode.number.toString().padLeft(2, '0')}',
        super(key: key);

  @override
  State<EpisodeBar> createState() => _EpisodeBarState();
}

class _EpisodeBarState extends State<EpisodeBar> {
  late MediaVideoEpisodeSuperEntity episode;

  @override
  initState() {
    episode = widget.episode;
    super.initState();
  }

  bool watched() {
    return episode.status == Status.done ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('EpisodeBar: build');
      print(episode.status);
    }
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
                  onPressed: () async {
                    MediaVideoEpisodeSuperEntity newEpisode =
                        episode.copyWith(favorite: !episode.favorite);

                    await serviceLocator<MediaVideoEpisodeSuperDao>()
                        .updateMediaVideoEpisodeSuperEntity(newEpisode);
                    setState(() {
                      episode = newEpisode;
                    });
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(45, 45)),
                    backgroundColor: MaterialStateProperty.all(
                        episode.favorite ? leisureColor : Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                        episode.favorite ? Colors.white : leisureColor),
                    shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder()),
                  ),
                  child: const Icon(Icons.favorite_rounded)),
              ElevatedButton(
                  onPressed: () async {
                    MediaVideoEpisodeSuperEntity newEpisode = episode.copyWith(
                        status: episode.status == Status.done
                            ? Status.nothing
                            : Status.done);

                    await serviceLocator<MediaVideoEpisodeSuperDao>()
                        .updateMediaVideoEpisodeSuperEntity(newEpisode);
                    setState(() {
                      episode = newEpisode;
                    });
                  },
                  onLongPress: () async {
                    MediaVideoEpisodeSuperEntity newEpisode = episode.copyWith(
                        status: episode.status == Status.done
                            ? Status.nothing
                            : Status.done);

                    await serviceLocator<MediaVideoEpisodeSuperDao>()
                        .updateMediaVideoEpisodeSuperEntity(newEpisode);
                    setState(() {
                      episode = newEpisode;
                    });
                    if (context.mounted) {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: const Color(0xFF22252D),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.0)),
                          ),
                          builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Stack(children: [
                                AddEpisodeNoteForm(
                                  code: widget.code,
                                  episode: episode,
                                ),
                              ])));
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(45, 45)),
                    backgroundColor: MaterialStateProperty.all(
                        watched() ? leisureColor : Colors.white),
                    foregroundColor: MaterialStateProperty.all(
                        watched() ? Colors.white : leisureColor),
                    shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder()),
                  ),
                  child: const Icon(Icons.remove_red_eye_outlined))
            ]),
          ]),
        ]));
  }
}
