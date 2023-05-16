import 'dart:io';

import 'package:flutter/material.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/pages/gamification/progress_bar_sheet.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/models/user.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String imagePath = serviceLocator<AuthenticationService>().isUserLoggedIn()
      ? serviceLocator<AuthenticationService>().getLoggedInUser()!.imagePath
      : 'assets/images/no_image.jpg';

  void updateImagePath(String newPath) {
    setState(() {
      imagePath = newPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color(0xFF22252D),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                builder: (context) => Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 50),
                      child: ProgressBarSheet(
                        user: serviceLocator<AuthenticationService>()
                                .isUserLoggedIn()
                            ? serviceLocator<AuthenticationService>()
                                .getLoggedInUser()!
                            : User(
                                name: '',
                                email: '',
                                password: '',
                                xp: 0,
                                level: 0,
                                imagePath: 'assets/images/no_image.jpg'),
                        updateImagePath: updateImagePath,
                      ),
                    ));
          },
          child: getUserAvatar(),
        )
      ],
    );
  }

  Widget getUserAvatar() {
    ImageProvider imageProvider;

    if (imagePath == 'assets/images/no_image.jpg') {
      imageProvider = AssetImage(imagePath);
    } else {
      imageProvider = Image.file(File(imagePath), fit: BoxFit.cover).image;
    }

    return (CircleAvatar(
      radius: 30,
      backgroundColor: grayButton,
      backgroundImage: imageProvider,
    ));
  }
}
