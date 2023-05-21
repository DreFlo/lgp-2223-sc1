import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/leisure/finished_media_form.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/leisure/season_tag.dart';
import 'package:src/widgets/leisure/episode_bar.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/media/season.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:collection/collection.dart';
import 'package:src/utils/enums.dart';

class MarkEpisodesSheet extends StatefulWidget {
  final int mediaId;
  final VoidCallback? refreshStatus;

  const MarkEpisodesSheet({Key? key, required this.mediaId, this.refreshStatus})
      : super(key: key);

  @override
  State<MarkEpisodesSheet> createState() => _MarkEpisodesSheetState();
}

class _MarkEpisodesSheetState extends State<MarkEpisodesSheet>
    with TickerProviderStateMixin {
  int selectedSeason = 1;
  late TabController controller;

  List<MediaVideoEpisodeSuperEntity> episodesDB = [];
  List<Season> seasonsDB = [];

  @override
  initState() {
    super.initState();
    controller = TabController(length: 1, vsync: this);
    loadSeasonsAndEpisodes();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List<MediaVideoEpisodeSuperEntity>> fetchEpisodes(
      List<Season> seasons) async {
    episodesDB = await loadEpisodes(seasonsDB);
    setState(() {
      episodesDB = episodesDB;
    });
    return episodesDB;
  }

  Future<List<Season>> fetchSeasons() async {
    seasonsDB = await loadSeasons(widget.mediaId);
    setState(() {
      seasonsDB = seasonsDB;
    });
    return seasonsDB;
  }

  void loadSeasonsAndEpisodes() async {
    seasonsDB = await fetchSeasons();
    episodesDB = await fetchEpisodes(seasonsDB);

    selectedSeason = 1;

    controller = TabController(
      length: seasonsDB.length,
      vsync: this,
      initialIndex: selectedSeason - 1,
    );

    controller.addListener(() {
      setState(() {
        selectedSeason = controller.index + 1;
      });
    });
  }

  List<Widget> getEpisodes() {
    List<Widget> episodes = [];

    int? seasonId;
    if (seasonsDB.isNotEmpty) {
      Season? selectedSeasonObject = seasonsDB
          .firstWhereOrNull((season) => season.number == selectedSeason);
      if (selectedSeasonObject != null) {
        seasonId = selectedSeasonObject.id;
      }
    }
    for (int j = 0; j <= episodesDB.length - 1; j++) {
      if (episodesDB[j].seasonId == seasonId) {
        episodes.add(EpisodeBar(
          season: selectedSeason,
          episode: episodesDB[j],
        ));

        episodes.add(const SizedBox(height: 15));
      }
    }

    return episodes;
  }

  List<Widget> getSeasons() {
    List<Widget> seasons = [];
    String seasonNumber = "";
    for (int i = 0; i <= seasonsDB.length - 1; i++) {
      seasonNumber = seasonsDB[i].number.toString();
      seasons.add(
        Tab(
            child: SeasonTag(
                text:
                    "${AppLocalizations.of(context).season_label} $seasonNumber")),
      );
    }
    return seasons;
  }

  @override
  Widget build(BuildContext context) {
    if (seasonsDB.isEmpty || episodesDB.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
        child: Wrap(spacing: 10, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
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
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFF22252D),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                      ),
                      builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.9,
                          minChildSize: 0.9,
                          maxChildSize: 0.9,
                          builder: (context, scrollController) => Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom +
                                                50),
                                        child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: FinishedMediaForm(
                                                rating: Reaction.neutral,
                                                startDate: DateTime.now()
                                                    .toString()
                                                    .split(" ")[0],
                                                endDate: DateTime.now()
                                                    .toString()
                                                    .split(" ")[0],
                                                isFavorite: false,
                                                mediaId: widget.mediaId,
                                                refreshStatus: () {
                                                  widget.refreshStatus!();
                                                  Navigator.pop(context);
                                                }))),
                                  ])));
                },
                child: Text(
                  AppLocalizations.of(context).finished_book,
                  style: Theme.of(context).textTheme.displayMedium,
                )))
      ]),
      SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: 
        TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
            indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: leisureColor,
            ),
            tabs: getSeasons(),
            controller: controller)

      ),
      const SizedBox(height: 10),
      Row(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              AppLocalizations.of(context).episodes_label,
              style: Theme.of(context).textTheme.displayMedium,
            ))
      ]),
      const SizedBox(height: 7.5),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(children: getEpisodes())),
      const SizedBox(height: 50)
    ]));
  }
}
