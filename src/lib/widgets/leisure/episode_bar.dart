import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:src/daos/media/media_video_episode_super_dao.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/gamification/game_logic.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/pages/leisure/add_episode_note_form.dart';

class EpisodeBar extends StatefulWidget {
  MediaVideoEpisodeSuperEntity episode;
  final String code;
  final void Function(MediaVideoEpisodeSuperEntity) replace;

  EpisodeBar({
    Key? key,
    required int season,
    required this.episode,
    required this.replace,
  })  : code =
            'S${season.toString().padLeft(2, '0')}E${episode.number.toString().padLeft(2, '0')}',
        super(key: key);

  @override
  State<EpisodeBar> createState() => _EpisodeBarState();
}

class _EpisodeBarState extends State<EpisodeBar> {
  //late MediaVideoEpisodeSuperEntity episodeDB;
  //bool ready = false;

  @override
  initState() {
    //episodeDB = widget.episode;
   /* if (episode.id == widget.episode.id) {
      ready = true;
    }*/
    super.initState();
  }

  bool watched() {
    return widget.episode.status == Status.done ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('EpisodeBar: build');
      //print(episode.status);
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
                      MediaVideoEpisodeSuperEntity newEpisode = widget.episode
                          .copyWith(favorite: !widget.episode.favorite);

                      await serviceLocator<MediaVideoEpisodeSuperDao>()
                          .updateMediaVideoEpisodeSuperEntity(newEpisode);

                      bool badge = await insertLogAndCheckStreak();
                      if (badge) {
                        //show badge
                        callBadgeWidget(); //streak
                      }
                      setState(() {
                        widget.episode = newEpisode;
                        widget.replace(newEpisode);
                      });
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(45, 45)),
                      backgroundColor: MaterialStateProperty.all(
                          widget.episode.favorite ? leisureColor : Colors.white),
                      foregroundColor: MaterialStateProperty.all(
                          widget.episode.favorite ? Colors.white : leisureColor),
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                    ),
                    child: const Icon(Icons.favorite_rounded)),
                ElevatedButton(
                    onPressed: () async {
                      MediaVideoEpisodeSuperEntity newEpisode =
                          widget.episode.copyWith(
                              status: widget.episode.status == Status.done
                                  ? Status.nothing
                                  : Status.done);

                      await serviceLocator<MediaVideoEpisodeSuperDao>()
                          .updateMediaVideoEpisodeSuperEntity(newEpisode);

                      bool badge = await insertLogAndCheckStreak();
                      if (badge) {
                        //show badge
                        callBadgeWidget(); //streak
                      }
                      setState(() {
                        widget.episode = newEpisode;
                        widget.replace(newEpisode);
                      });
                    },
                    onLongPress: () async {
                      MediaVideoEpisodeSuperEntity newEpisode = widget.episode
                          .copyWith(
                              status: widget.episode.status == Status.done
                                  ? Status.nothing
                                  : Status.done);

                      await serviceLocator<MediaVideoEpisodeSuperDao>()
                          .updateMediaVideoEpisodeSuperEntity(newEpisode);

                      bool badge = await insertLogAndCheckStreak();
                      if (badge) {
                        //show badge
                        callBadgeWidget(); //streak
                      }
                      setState(() {
                        widget.episode = newEpisode;
                        widget.replace(newEpisode);
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
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: AddEpisodeNoteForm(
                                      code: widget.code,
                                      episode: widget.episode,
                                      refreshStatus: () {
                                        Navigator.pop(context);
                                      }),
                                ));
                      }
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(45, 45)),
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

  callBadgeWidget() {
    unlockBadgeForUser(3, context); //streak
  }
}
