import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/leisure/review_note_bar.dart';
import 'package:src/widgets/leisure/season_tag.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/models/media/review.dart';
import 'package:src/models/media/season.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';

import 'package:src/widgets/leisure/episode_note_bar.dart';

class EpisodesNotesSheet extends StatefulWidget {
  final int mediaId;

  const EpisodesNotesSheet({Key? key, required this.mediaId}) : super(key: key);

  @override
  State<EpisodesNotesSheet> createState() => _EpisodesNotesSheetState();
}

class _EpisodesNotesSheetState extends State<EpisodesNotesSheet>
    with TickerProviderStateMixin {
  late TabController controller;
  int selectedTab = 0;
  List<NoteEpisodeNoteSuperEntity?>? notes;
  Review? review;
  List<MediaVideoEpisodeSuperEntity> episodesDB = [];
  List<Season> seasonsDB = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 1, vsync: this);
    controller.addListener(() {
      setState(() {
        selectedTab = controller.index;
      });
    });
    fetchSeasons().then((_) {
      controller = TabController(
          length: seasonsDB.length + 1, vsync: this, initialIndex: 0);
      loadSeasonsEpisodesNotesAndReviews();
    });
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

  Future<List<NoteEpisodeNoteSuperEntity?>?> fetchNotes() async {
    notes = await loadEpisodeNotes(episodesDB);
    setState(() {
      notes = notes;
    });
    return notes;
  }

  Future<Review?>? fetchReviews() async {
    review = await loadReviews(widget.mediaId);
    setState(() {
      review = review;
    });
    return review;
  }

  void loadSeasonsEpisodesNotesAndReviews() async {
    episodesDB = await fetchEpisodes(seasonsDB);
    notes = await fetchNotes();
    review = await fetchReviews();
    setState(() {
      isDataLoaded = true;
    });
  }

  List<Widget> getSeasons() {
    List<Widget> seasons = [];
    seasons.add(
      Tab(child: SeasonTag(text: AppLocalizations.of(context).all_label)),
    );

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

  List<Widget> getNotes(int tab) {
    if (!isDataLoaded) {
      return const [CircularProgressIndicator()];
    }
    switch (tab) {
      case 0:
        return getAllNotes();
      default:
        return getSeasonNotes(tab);
    }
  }

  List<Widget> getAllNotes() {
    List<Widget> episodes = [];

    if (review != null) {
      episodes.add(ReviewNoteBar(
        reaction: review!.emoji,
        text: review!.review,
      ));

      episodes.add(const SizedBox(height: 15));
    }

    if (notes != null) {
      for (var range in notes!) {
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
    List<Widget> episodes = [];

    if (notes != null) {
      for (var range in notes!) {
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
    return Wrap(runSpacing: 10, children: [
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
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: TabBar(
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
              indicatorPadding: const EdgeInsets.only(top: 5, bottom: 5),
              labelPadding: const EdgeInsets.only(left: 10, right: 10),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: leisureColor,
              ),
              tabs: getSeasons(),
              controller: controller,
              onTap: (index) {
                setState(() {
                  selectedTab = index;
                });
              })),
      const SizedBox(height: 30),
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
          child: Column(children: getNotes(selectedTab)))
    ]);
  }
}
