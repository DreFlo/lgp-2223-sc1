import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/daos/notes/note_episode_note_super_dao.dart';
import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/models/notes/note_episode_note_super_entity.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';

class AddEpisodeNoteForm extends StatefulWidget {
  final String code;
  final MediaVideoEpisodeSuperEntity episode;
  final VoidCallback? refreshStatus;

  const AddEpisodeNoteForm(
      {Key? key,
      required this.code,
      required this.episode,
      required this.refreshStatus})
      : super(key: key);

  @override
  State<AddEpisodeNoteForm> createState() => _AddEpisodeNoteFormState();
}

class _AddEpisodeNoteFormState extends State<AddEpisodeNoteForm> {
  final TextEditingController _controller = TextEditingController();

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
      Container(
          padding: const EdgeInsets.only(left: 18),
          child: Column(children: [
            Text(AppLocalizations.of(context).add_note_callout,
                softWrap: true,
                textWidthBasis: TextWidthBasis.longestLine,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left),
            const SizedBox(height: 10),
          ])),
      Padding(
          padding: const EdgeInsets.only(left: 18),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 200,
              child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: darkTextField,
                    helperStyle: Theme.of(context).textTheme.labelSmall,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )))),
      Padding(
          padding: const EdgeInsets.only(left: 18, top: 30),
          child: ElevatedButton(
              onPressed: () async {
                NoteEpisodeNoteSuperEntity note = NoteEpisodeNoteSuperEntity(
                    title: widget.code,
                    content: _controller.text,
                    date: DateTime.now(),
                    episodeId: widget.episode.id!);

                await serviceLocator<NoteEpisodeNoteSuperDao>()
                    .insertNoteEpisodeNoteSuperEntity(note);

                if (widget.refreshStatus != null) {
                  widget.refreshStatus!();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.90, 55),
                backgroundColor: leisureColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(AppLocalizations.of(context).save,
                  style: Theme.of(context).textTheme.headlineSmall))),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [SizedBox(height: 100)])
    ]);
  }
}
