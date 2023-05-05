import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/user.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/student/task_dao.dart';

class ProgressBarSheet extends StatefulWidget {
  final List<String> user;
  final String image;
  final int level;

  const ProgressBarSheet(
      {Key? key, required this.user, required this.image, required this.level})
      : super(key: key);

  @override
  State<ProgressBarSheet> createState() => _ProgressBarSheetState();
}

class _ProgressBarSheetState extends State<ProgressBarSheet> {
  late String image;
  int numberMedia = 0;
  int percentageFavoriteMedia = 0;
  int completedTasks = 0;
  int projects = 0;
  bool isReady = false;

  @override
  initState() {
    image = widget.image;
    super.initState();
    loadNumbers();
  }

  void loadNumbers() async {
    numberMedia = await serviceLocator<MediaDao>().countAllMedia() ?? 0;
    int count = await serviceLocator<MediaDao>().countFavoriteMedia(true) ?? 0;
    percentageFavoriteMedia = (count / numberMedia * 100).round();

    completedTasks =
        await serviceLocator<TaskDao>().countFinishedTasks(true) ?? 0;
    projects =
        await serviceLocator<TaskDao>().countFinishedTaskGroups(true) ?? 0;
    setState(() {
      numberMedia = numberMedia;
      percentageFavoriteMedia = percentageFavoriteMedia;
      completedTasks = completedTasks;
      projects = projects;
      isReady = true;
    });
  }

  String getText(context) {
    //Should we count episodes as media entries or not?
    if (!isReady) {
      return "";
    }
    String text = AppLocalizations.of(context).user_progress_3;
    text += completedTasks.toString();

    if (projects >= 1) {
      if (completedTasks <= 1) {
        text += AppLocalizations.of(context).user_progress_task;
        text += AppLocalizations.of(context).user_progress_across;
      } else {
        text += AppLocalizations.of(context).user_progress_tasks;
        text += AppLocalizations.of(context).user_progress_across;
      }

      text += projects.toString();

      if (projects == 1) {
        text += AppLocalizations.of(context).user_progress_project;
      } else {
        text += AppLocalizations.of(context).user_progress_projects;
      }
    } else {
      //no project
      if (completedTasks <= 1) {
        text += AppLocalizations.of(context).user_progress_task_no_project;
      } else {
        text += AppLocalizations.of(context).user_progress_tasks_no_project;
      }
    }

    text += AppLocalizations.of(context).user_progress_media_catalog;
    text += numberMedia.toString();

    if (percentageFavoriteMedia > 0) {
      if (numberMedia <= 1) {
        text += AppLocalizations.of(context).user_progress_media_catalog_1;
      } else {
        text += AppLocalizations.of(context).user_progress_media_catalog_2;
      }
      text += percentageFavoriteMedia.toString();
      text += AppLocalizations.of(context).user_progress_media_catalog_3;
    } else {
      if (numberMedia <= 1) {
        text +=
            AppLocalizations.of(context).user_progress_media_catalog_1_no_love;
      } else {
        text +=
            AppLocalizations.of(context).user_progress_media_catalog_2_no_love;
      }
    }

    return text;
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
                          //While authentication isn't done, make sure to seed the DB before running this
                          final userStream = serviceLocator<UserDao>().findUserById(
                              1); //hardcoded id but should be authenticated user's id
                          User? firstNonNullUser = await userStream
                              .firstWhere((user) => user != null);
                          User user = firstNonNullUser!;

                          //update user
                          User userNew = User(
                              id: user.id,
                              name: user.name,
                              email: user.email,
                              password: user.password,
                              xp: user.xp,
                              level: user.level,
                              imagePath: pickedFile!.path);
                          await serviceLocator<UserDao>().updateUser(userNew);

                          setState(() {
                            image = pickedFile.path;
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
            Text(
                "${AppLocalizations.of(context).level.toUpperCase()} ${widget.level}",
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
            Text(
                "${AppLocalizations.of(context).level.toUpperCase()} ${widget.level + 1}"
                    .toUpperCase(),
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
              child: Text(getText(context),
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
