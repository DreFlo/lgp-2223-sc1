import 'package:flutter/material.dart';
import 'package:src/pages/home/my_horizontal_scrollview.dart';
import 'package:src/pages/home/my_profile_pic.dart';
import 'package:src/pages/home/my_task_listview.dart';
import 'package:src/pages/home/my_welcome_message.dart';
import 'package:src/themes/colors.dart';

import 'my_badge_placeholder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String name = "Joaquim Almeida"; // TODO Get name from database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 36, top: 36),
            child: MyProfilePic()
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 36, top: 100),
                  child: MyWelcomeMessage(name: name)),
              const MyBadgePlaceholder(),
              MyHorizontalScrollView(
                selectedIndex: _selectedIndex,
                setSelectedIndex: (int index) =>
                    setState(() => _selectedIndex = index),
              ),
              const SizedBox(
                height: 207,
                child: MyTaskListView(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
