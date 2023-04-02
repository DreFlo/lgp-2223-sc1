import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/SeasonTag.dart';
import 'package:src/widgets/EpisodeBar.dart';

import '../../widgets/EpisodeNoteBar.dart';

class EpisodesNotesSheet extends StatefulWidget {
  Map<String, String> notes;
  Map<int, Map<int, String>> episodes;
  TabController? controller;
  int selectedTab = 0;

  EpisodesNotesSheet(
      {Key? key, required this.notes, required this.episodes, this.controller})
      : super(key: key);

  @override
  State<EpisodesNotesSheet> createState() => _EpisodesNotesSheetState();
}

class _EpisodesNotesSheetState extends State<EpisodesNotesSheet>
    with TickerProviderStateMixin {
  initState() {
    widget.controller = TabController(
        length: widget.episodes.length + 1, vsync: this, initialIndex: 0);

    widget.controller?.addListener(() {
      setState(() {
        widget.selectedTab = widget.controller!.index;
      });
    });
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
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 32),
      ));
      episodes.add(SizedBox(height: 125));
    }

    return episodes;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();

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
                color: Color(0xFF414554),
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
          controller: widget.controller),
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
          child: Column(children: getNotes(widget.selectedTab))),
      const SizedBox(height: 50)
    ]);
  }
}
