import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/user.dart';
import 'package:src/daos/user_dao.dart';

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
                          //While authentication isn't done, make sure to seed the DB before running this
                          final userStream = serviceLocator<UserDao>().findUserById(
                              1); //hardcoded id but should be authenticated user's id
                          User? firstNonNullUser = await userStream
                              .firstWhere((user) => user != null);
                          User user = firstNonNullUser!;

                          //update user
                          User userNew = User(
                              id: user.id,
                              userName: user.userName,
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

/* "You’ve completed 122 task across 7 projects! 
Your media catalog has 34 entries and 
you love 52% of what you have there!",
*/

//Plan:
//1. Get number of tasks completed from DB
//2. See which tasks belonged to a project
//3. Get number of different projects
//4. Get number of media entries
//5. See how many of them were favorited
