// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/leisure/review_note_bar.dart';
import 'package:src/widgets/leisure/season_tag.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/models/media/review.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';

import '../../widgets/leisure/episode_note_bar.dart';

class EpisodesNotesSheet extends StatefulWidget {
  final List<NoteEpisodeNoteSuperEntity?>? notes;
  final Review? review;
  final List<MediaVideoEpisodeSuperEntity> episodes;
  final List<Season> seasons;

  const EpisodesNotesSheet(
      {Key? key, this.notes, required this.episodes, required this.seasons, this.review})
      : super(key: key);

  @override
  State<EpisodesNotesSheet> createState() => _EpisodesNotesSheetState();
}

class _EpisodesNotesSheetState extends State<EpisodesNotesSheet>
    with TickerProviderStateMixin {
  TabController? controller;
  int selectedTab = 0;

  @override
  initState() {
    controller = TabController(
        length: widget.seasons.length + 1, vsync: this, initialIndex: 0);

    controller?.addListener(() {
      setState(() {
        selectedTab = controller!.index;
      });
    });

    super.initState();
  }

  List<Widget> getSeasons() {
    List<Widget> seasons = [];
    seasons.add(
      Tab(child: SeasonTag(text: AppLocalizations.of(context).all_label)),
    );

    String seasonNumber = "";
    for (int i = 0; i <= widget.seasons.length - 1; i++) {
      seasonNumber = widget.seasons[i].number.toString();
      seasons.add(
        Tab(
            child: SeasonTag(
                text:
                    "${AppLocalizations.of(context).season_label} $seasonNumber")),
      );
    }
    return seasons;
  }

  List<Widget> getNotes(int tab) {
    switch (tab) {
      case 0:
        return getAllNotes();
      default:
        return getSeasonNotes(tab);
    }
  }

  List<Widget> getAllNotes() {
    List<Widget> episodes = [];

    if (widget.review != null) {
      episodes.add(ReviewNoteBar(
        reaction: widget.review!.emoji,
        text: widget.review!.review,
      ));

      episodes.add(const SizedBox(height: 15));
    }

    if (widget.notes != null) {
      for (var range in widget.notes!) {
        episodes.add(EpisodeNoteBar(
          code: range!.title,
          text: range.content,
        ));

        episodes.add(const SizedBox(height: 15));
      }
    }

    return episodes;
  }

  List<Widget> getSeasonNotes(int season) {
    //TODO: Better the algorithm out.

    List<Widget> episodes = [];

    if (widget.notes != null) {
      for (var range in widget.notes!) {
        var seasonCode = "S${season.toString().padLeft(2, "0")}";
        if (range!.title.contains(seasonCode)) {
          episodes.add(EpisodeNoteBar(
            code: range.title,
            text: range.content,
          ));

          episodes.add(const SizedBox(height: 15));
        }
      }
    }

    if (episodes.isEmpty) {
      episodes.add(Text(
        AppLocalizations.of(context).no_notes_label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 32),
      ));
      episodes.add(const SizedBox(height: 125));
    }

    return episodes;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Container(
              width: 115,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF414554),
              ),
            ))
      ]),
      TabBar(
          padding: const EdgeInsets.only(left: 18, right: 18),
          isScrollable: true,
          labelColor: leisureColor,
          unselectedLabelColor: Colors.white,
          splashBorderRadius: const BorderRadius.all(Radius.circular(10)),
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            // Use the default focused overlay color
            return states.contains(MaterialState.focused)
                ? null
                : Colors.transparent;
          }),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.only(top: 5, bottom: 5),
          labelPadding: const EdgeInsets.only(left: 10, right: 10),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: leisureColor,
          ),
          tabs: getSeasons(),
          controller: controller),
      const SizedBox(height: 10),
      Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              AppLocalizations.of(context).notes,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(children: getNotes(selectedTab))),
      const SizedBox(height: 50)
    ]);
  }
}
