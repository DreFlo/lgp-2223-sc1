import 'package:flutter/material.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/pages/gamification/progress_bar_sheet.dart';
import 'package:src/themes/colors.dart';
import 'package:src/utils/service_locator.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  List<String> user = ['John Smith', '11', '400'];

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
                          level: 2,
                          user: user,
                          image: 'assets/images/poster.jpg'),
                    ));
          },
          child: getUserAvatar(),
        )
      ],
    );
  }

  Widget getUserAvatar() {
    String imagePath = serviceLocator<AuthenticationService>().isUserLoggedIn()
        ? serviceLocator<AuthenticationService>().getLoggedInUser()!.imagePath
        : 'assets/images/no_image.jpg';

    return (CircleAvatar(
      radius: 30,
      backgroundColor: grayButton,
      backgroundImage: AssetImage(imagePath),
    ));
  }
}
