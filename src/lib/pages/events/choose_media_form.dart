// ignore_for_file: file_names, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

import '../../widgets/events/choose_media_bar.dart';

class ChooseMedia {
  final int id;
  final String name;
  final String type;
  bool isSelected;

  ChooseMedia(
      {required this.id,
        required this.name,
        required this.type,
        required this.isSelected});
}

class ChooseMediaForm extends StatefulWidget {
  final List<ChooseMedia> media;
  final ScrollController scrollController;
  final Function(int, String, String) addActivityCallback;

  const ChooseMediaForm(
      {Key? key,
        required this.scrollController,
        required this.media,
        required this.addActivityCallback})
      : super(key: key);

  @override
  State<ChooseMediaForm> createState() => _ChooseMediaFormState();
}

class _ChooseMediaFormState extends State<ChooseMediaForm> {
  TextEditingController controller = TextEditingController();

  late List<ChooseMedia>? media;

  List<Widget> getmedia() {
    List<Widget> mediaList = [];

    for (int i = 0; i < media!.length; i++) {
      ChooseMedia mediaItem = media![i];
      mediaList.add(ChooseMediaBar(media: mediaItem));
      if (i != media!.length - 1) {
        mediaList.add(const SizedBox(height: 15));
      }
    }

    if (media == null || media!.isEmpty) {
      mediaList.add(Text(AppLocalizations.of(context).no_media,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal)));
    }

    return mediaList;
  }

  @override
  initState() {
    media = widget.media;
    media ??= [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Wrap(spacing: 10, children: [
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
            Row(children: [
              Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF17181C),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10)),
                  child: Wrap(children: [
                    Row(children: [
                      const Icon(Icons.live_tv_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context).choose_media,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ])
                  ]))
            ]),
            const SizedBox(height: 30),
            ...getmedia(),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  //TODO: Add selected media to event
                  for (ChooseMedia mediaItem in media!) {
                    if (mediaItem.isSelected) widget.addActivityCallback(mediaItem.id, mediaItem.name, mediaItem.type);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                  Size(MediaQuery.of(context).size.width * 0.95, 55),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(AppLocalizations.of(context).save,
                    style: Theme.of(context).textTheme.headlineSmall))
          ]),
        ));
  }
}
