import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/pages/auth/landing_page.dart';
import 'package:src/pages/gamification/badges_page.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/user.dart';
import 'package:src/daos/user_dao.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/student/task_dao.dart';
import 'package:src/utils/gamification/levels.dart';

class ProgressBarSheet extends StatefulWidget {
  final User user;
  final void Function(String)? updateImagePath;

  const ProgressBarSheet({Key? key, required this.user, this.updateImagePath})
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
    if (widget.user.imagePath == '') {
      image = 'assets/images/no_image.jpg';
    } else {
      image = widget.user.imagePath;
    }
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

  ImageProvider getImageProvider() {
    ImageProvider imageProvider;

    if (image == 'assets/images/no_image.jpg') {
      imageProvider = AssetImage(image);
    } else {
      imageProvider = Image.file(File(image), fit: BoxFit.cover).image;
    }

    return imageProvider;
  }

  void logoutUser() async {
    serviceLocator<AuthenticationService>().logoutUser();
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LandingPage()));
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
                CircleAvatar(radius: 50, backgroundImage: getImageProvider()),
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
                          if (pickedFile != null) {
                            widget.updateImagePath!(pickedFile.path);
                            //update user
                            User userNew = User(
                                id: widget.user.id,
                                name: widget.user.name,
                                email: widget.user.email,
                                password: widget.user.password,
                                xp: widget.user.xp,
                                level: widget.user.level,
                                imagePath: pickedFile.path);
                            await serviceLocator<UserDao>().updateUser(userNew);
                            serviceLocator<AuthenticationService>()
                                .setLoggedInUser(userNew);

                            setState(() {
                              image = pickedFile.path;
                            });
                          }
                        }))
              ],
            ),
          ])),
      const SizedBox(height: 7.5),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(widget.user.name,
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
                "${AppLocalizations.of(context).level.toUpperCase()} ${widget.user.level}",
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
                            value:
                                (widget.user.xp - levels[widget.user.level]!) /
                                    (levels[widget.user.level + 1]! -
                                        levels[widget.user.level]!),
                            backgroundColor: const Color(0xFF414554),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                primaryColor))))),
            const SizedBox(width: 15),
            Text(
                "${AppLocalizations.of(context).level.toUpperCase()} ${widget.user.level + 1}"
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
                      widget.user.name +
                      AppLocalizations.of(context).user_progress_2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            )
          ])),
      const SizedBox(height: 27.5),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Text(getText(context),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  )),
            )
          ])),
      const SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.19,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15)),
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColor),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))))),
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30.0)),
                                  ),
                                  isScrollControlled: true,
                                  backgroundColor: modalBackground,
                                  context: context,
                                  builder: (builder) => const BadgesPage());
                            },
                            child: Text(AppLocalizations.of(context).badges,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)))),
                  ],
                ),
                const Divider(
                  height: 25,
                  thickness: 1.5,
                  color: grayText,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.40, 45),
                          backgroundColor: const Color(0xFF402A34),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(
                                  color: leisureColor, width: 2.0)),
                        ),
                        onPressed: logoutUser,
                        child: const Text("Logout")),
                  ],
                )
              ],
            ))),
      ),
      const SizedBox(height: 5)
    ]);
  }
}
