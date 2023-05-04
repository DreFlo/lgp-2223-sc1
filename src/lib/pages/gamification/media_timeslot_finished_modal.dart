import 'package:flutter/material.dart';
import 'package:src/models/timeslot/timeslot_media_timeslot_super_entity.dart';
import 'package:src/pages/gamification/no_progress_in_timeslot_modal.dart';
import 'package:src/pages/gamification/progress_in_timeslot_modal.dart';
import 'package:src/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/utils/enums.dart';
import 'package:src/widgets/leisure/timeslot_media_bar.dart';

import 'package:src/models/media/media.dart';

//This will be the modal that will appear when the user finishes a media timeslot
class MediaTimeslotFinishedModal extends StatefulWidget {
  final TimeslotMediaTimeslotSuperEntity timeslot;
  final List<Media> medias;

  const MediaTimeslotFinishedModal(
      {Key? key, required this.timeslot, required this.medias})
      : super(key: key);

  @override
  State<MediaTimeslotFinishedModal> createState() =>
      _MediaTimeslotFinishedModalState();
}

class _MediaTimeslotFinishedModalState
    extends State<MediaTimeslotFinishedModal> {
  late List<TimeslotMediaBar> mediaState;

  List<Widget> getMedia() {
    mediaState = [];

    List<Widget> medias = [];

    for (int i = 0; i < widget.medias.length; i++) {
      var media = TimeslotMediaBar(media: widget.medias[i]);

      medias.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [media],
        ),
      );

      mediaState.add(media);

      if (i != widget.medias.length - 1) medias.add(const SizedBox(height: 10));
    }

    return medias;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppLocalizations.of(context).event_finished_1,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                widget.timeslot.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: leisureColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppLocalizations.of(context).event_finished_2,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            AppLocalizations.of(context).event_finished_3,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          )
        ]),
        const SizedBox(height: 30),
        SizedBox(
            height: 300,
            child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView(shrinkWrap: true, children: getMedia()))),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50))),
            onPressed: () {
              List<Media> mediasDone = [];
              int mediaAlredyDone = 0;
              for (TimeslotMediaBar m in mediaState) {
                if (m.taskStatus) {
                  mediasDone.add(m.media);
                }
                if (m.media.status == Status.done) {
                  mediaAlredyDone++;
                }
              }

              if (mediasDone.isEmpty && mediaAlredyDone == 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          backgroundColor: modalBackground,
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: NoProgressInTimeslotModal(
                            mediasDone: mediasDone,
                            mediaTimeslot: widget.timeslot,
                          )));
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          backgroundColor: modalLightBackground,
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ProgressInTimeslotModal(
                            modules: const [
                              Module.student,
                              Module.fitness,
                              Module.personal,
                              Module.leisure
                            ],
                            taskCount: widget.medias.length,
                            finishedTaskCount:
                                mediasDone.length + mediaAlredyDone,
                            mediasDone: mediasDone,
                            mediaTimeslot: widget.timeslot,
                          )));
                });
              }
            },
            child: Text(AppLocalizations.of(context).confirm,
                style: Theme.of(context).textTheme.headlineSmall),
          )),
        ]),
      ]),
    );
  }
}
