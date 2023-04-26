import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/leisure/review_note_bar.dart';
import 'package:src/widgets/leisure/season_tag.dart';

import 'package:src/widgets/leisure/episode_note_bar.dart';

class EpisodesNotesSheet extends StatefulWidget {
  final Map<String, String> notes;
  final Map<Reaction, String>? review;
  final Map<int, Map<dynamic, dynamic>> episodes;

  const EpisodesNotesSheet(
      {Key? key, required this.notes, required this.episodes, this.review})
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
        length: widget.episodes.length + 1, vsync: this, initialIndex: 0);

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

    for (int i = 1; i <= widget.episodes.length; i++) {
      seasons.add(
        Tab(
            child: SeasonTag(
                text: "${AppLocalizations.of(context).season_label} $i")),
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
        reaction: widget.review!.keys.first,
        text: widget.review![widget.review!.keys.first],
      ));

      episodes.add(const SizedBox(height: 15));
    }

    for (var code in widget.notes.keys) {
      episodes.add(EpisodeNoteBar(
        code: code,
        text: widget.notes[code]!,
      ));

      episodes.add(const SizedBox(height: 15));
    }

    return episodes;
  }

  List<Widget> getSeasonNotes(int season) {
    //TODO: Better the algorithm out.

    List<Widget> episodes = [];

    for (var code in widget.notes.keys) {
      var seasonCode = "S${season.toString().padLeft(2, "0")}";
      if (code.contains(seasonCode)) {
        episodes.add(EpisodeNoteBar(
          code: code,
          text: widget.notes[code]!,
        ));

        episodes.add(const SizedBox(height: 15));
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
