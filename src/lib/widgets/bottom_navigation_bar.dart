import 'package:flutter/material.dart';
import 'package:src/themes/colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MyBottomNavigationBar(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  getAddIcon() {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: const Icon(Icons.add, size: 25),
    );
  }

  getIcon(String name) {
    switch (name) {
      case 'Home':
        return const Icon(Icons.home_filled);
      case 'Calendar':
        return const Icon(Icons.calendar_month);
      case 'Dashboard':
        return const Icon(Icons.dashboard_rounded);
      case 'Settings':
        return const Icon(Icons.settings);
      case 'Add':
        return getAddIcon();
      default:
        return const Icon(Icons.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90,
      padding: const EdgeInsets.only(left: 30, right: 30),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: bottomNavbar, spreadRadius: 5, blurRadius: 10),
          ]),
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: bottomNavbar,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.white,
            iconSize: 27,
            items: [
              BottomNavigationBarItem(icon: getIcon("Home"), label: 'Home'),
              BottomNavigationBarItem(
                  icon: getIcon("Calendar"), label: 'Calendar'),
              BottomNavigationBarItem(icon: getIcon("Add"), label: 'Add'),
              BottomNavigationBarItem(
                  icon: getIcon("Dashboard"), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: getIcon("Settings"), label: 'Settings'),
            ],
            currentIndex: widget.selectedIndex,
            onTap: widget.onItemTapped,
          )),
    );
  }
}
