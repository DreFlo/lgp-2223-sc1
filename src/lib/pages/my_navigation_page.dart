import 'package:flutter/material.dart';
import 'package:src/pages/home/my_home_page.dart';
import 'package:src/widgets/my_bottom_navigation_bar.dart';
import 'package:src/themes/colors.dart';

class MyNavigationPage extends StatefulWidget {
  const MyNavigationPage({Key? key}) : super(key: key);

  @override
  State<MyNavigationPage> createState() => _MyNavigationPageState();
}

class _MyNavigationPageState extends State<MyNavigationPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  List<Widget> pages = const [
    MyHomePage(),
    Center(
      child: Text("Calendar"), //TODO
    ),
    Center(),
    Center(
      child: Text("Dashboard"), //TODO
    ),
    Center(
      child: Text("Settings"), //TODO
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBackground,
        body: SizedBox.expand(
            child: PageView(
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: pages,
        )),
        bottomNavigationBar: MyBottomNavigationBar(
            selectedIndex: _currentIndex, onItemTapped: _onItemTapped));
  }
}
