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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: grayButton),
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
            backgroundColor: grayButton,
            selectedItemColor: mainPurple,
            unselectedItemColor: Colors.white,
            iconSize: 27,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "Calendar",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                      color: mainPurple,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: const Icon(Icons.add, color: Colors.white, size: 25),
                ),
                label: "Add",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: "Dashboard",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
            currentIndex: widget.selectedIndex,
            onTap: widget.onItemTapped,
          )),
    );
  }
}
