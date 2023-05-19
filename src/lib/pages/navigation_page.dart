import 'package:flutter/material.dart';
import 'package:src/pages/add_new_items_page.dart';
import 'package:src/pages/calendar_page.dart';
import 'package:src/pages/home_page.dart';
import 'package:src/pages/dashboard.dart';
import 'package:src/pages/my_home_page.dart';
import 'package:src/themes/colors.dart';
import 'package:src/widgets/bottom_navigation_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  bool _showAddNewItemsPage = false;
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
      
      setState(() {
        _showAddNewItemsPage = !_showAddNewItemsPage;
      });

      return;
    }
    setState(() {
      _showAddNewItemsPage = false; 
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  List<Widget> pages = const [
    MyHomePage(),
    CalendarPage(),
    Center(),
    Dashboard(),
    HomePage(title: "TODO"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBackground,
        body: Stack(
          children: [
          SizedBox.expand(
            child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: pages,
        )),
        if (_showAddNewItemsPage) const AddNewItemsPage(),
        ],
        ),
        bottomNavigationBar: MyBottomNavigationBar(
            selectedIndex: _currentIndex, onItemTapped: _onItemTapped, showingAddItemsPage: _showAddNewItemsPage,));
  }
}
