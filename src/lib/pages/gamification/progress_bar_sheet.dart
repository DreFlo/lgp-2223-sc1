// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/themes/colors.dart';

class ProgressBarSheet extends StatefulWidget {
  final List<String> user;
  final String image;

  const ProgressBarSheet({Key? key, required this.user, required this.image})
      : super(key: key);

  @override
  State<ProgressBarSheet> createState() => _ProgressBarSheetState();
}

class _ProgressBarSheetState extends State<ProgressBarSheet> {
  late String image;

  @override
  initState() {
    image = widget.image;
    super.initState();
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
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        Image.file(File(image), fit: BoxFit.cover).image),
                Positioned(
                    top: 60,
                    left: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                          shape:
                              MaterialStateProperty.all(const CircleBorder()),
                        ),
                        child: const Icon(Icons.image_search_rounded, size: 15),
                        onPressed: () async {
                          XFile? pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            image = pickedFile!.path;
                          });
                        }))
              ],
            ),
          ])),
      const SizedBox(height: 7.5),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(widget.user[0],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
          ])),
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Level 1".toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(width: 15),
            Expanded(
                child: Container(
                    height: 25,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                            value: double.parse(widget.user[1]) / 100,
                            backgroundColor: const Color(0xFF414554),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                primaryColor))))),
            const SizedBox(width: 15),
            Text("Level 2".toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )),
          ])),
      const SizedBox(height: 25),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Text(
                  AppLocalizations.of(context).user_progress +
                      widget.user[0] +
                      AppLocalizations.of(context).user_progress_2,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            )
          ])),
      const SizedBox(height: 27.5),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Text(AppLocalizations.of(context).user_progress_3,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            )
          ])),
      const SizedBox(height: 25)
    ]);
  }
}
