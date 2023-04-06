import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class MyProfilePic extends StatefulWidget {
  const MyProfilePic({Key? key}) : super(key: key);

  @override
  State<MyProfilePic> createState() => _MyProfilePicState();
}

class _MyProfilePicState extends State<MyProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            // TODO Handle the tap on the profile picture
          },
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: grayButton,
            // TODO Get profile pic - backgroundImage: AssetImage(path),
          ),
        )
      ],
    );
  }
}
