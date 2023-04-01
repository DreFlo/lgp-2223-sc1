import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/SeasonTag.dart';
import 'package:src/widgets/EpisodeBar.dart';

class MarkEpisodesSheet extends StatefulWidget {
  Map<int, Map<int, String>> episodes;
  int selectedSeason;
  TabController? controller;

  MarkEpisodesSheet(
      {Key? key,
      required this.episodes,
      this.selectedSeason = 1,
      this.controller})
      : super(key: key);

  @override
  State<MarkEpisodesSheet> createState() => _MarkEpisodesSheetState();
}

class _MarkEpisodesSheetState extends State<MarkEpisodesSheet>
    with TickerProviderStateMixin {


  initState() {
    widget.controller = TabController(
        length: widget.episodes.length,
        vsync: this,
        initialIndex: widget.selectedSeason - 1);

    widget.controller?.addListener(() {
      setState(() {
        widget.selectedSeason = widget.controller!.index + 1;
      });
    });
  }

  List<Widget> getEpisodes() {
    List<Widget> episodes = [];

    for (int j = 1; j <= widget.episodes[widget.selectedSeason]!.length; j++) {
      episodes.add(EpisodeBar(
          code:
              "S${widget.selectedSeason.toString().padLeft(2, 0.toString())}E${j.toString().padLeft(2, 0.toString())}",
          title: widget.episodes[widget.selectedSeason]![j]!,
          favorite: false,
          watched: true
          ));

      episodes.add(const SizedBox(height: 15));
    }

    return episodes;
  }

  List<Widget> getSeasons() {
    List<Widget> seasons = [];
    for (int i = 1; i <= widget.episodes.length; i++) {
      seasons.add(
        Tab(
            child: SeasonTag(
                text: "${AppLocalizations.of(context).season_label} $i")),
      );
    }
    return seasons;
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
              AppLocalizations.of(context).episodes_label,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(children: getEpisodes())),
      const SizedBox(height: 50)
    ]);
  }
}
