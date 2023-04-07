import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
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
