import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/themes/colors.dart';

class MyHorizontalScrollView extends StatefulWidget {
  final int nItems;
  final int selectedIndex;
  final Function(int) setSelectedIndex;

  const MyHorizontalScrollView(
      {Key? key,
      required this.selectedIndex,
      required this.setSelectedIndex,
      required this.nItems})
      : super(key: key);

  @override
  State<MyHorizontalScrollView> createState() => _MyHorizontalScrollViewState();
}

class _MyHorizontalScrollViewState extends State<MyHorizontalScrollView> {
  final ScrollController _scrollController = ScrollController();

  void _onItemTap(int index) {
    setState(() {
      widget.setSelectedIndex(index);
    });
    _scrollToItem(index);
  }

  void _scrollToItem(int index) {
    double itemWidth = MediaQuery.of(context).size.width / 2.5;
    double itemOffset = index * itemWidth;
    double screenWidth = MediaQuery.of(context).size.width;
    double scrollOffset = itemOffset - screenWidth / 2 + (itemWidth / 2);
    _scrollController.animateTo(scrollOffset,
        duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  Widget buildSelectedItem(int index, String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget buildUnselectedItem(int index, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium),
    );
  }

  Widget buildItem(int index, String name, Color color, bool isSelected) {
    return GestureDetector(
        onTap: () => _onItemTap(index),
        child: isSelected
            ? buildSelectedItem(index, name, color)
            : buildUnselectedItem(index, name));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> items = {
      '${AppLocalizations.of(context).all_label} (${widget.nItems})':
          primaryColor,
      AppLocalizations.of(context).student: studentColor,
      AppLocalizations.of(context).leisure: leisureColor,
      AppLocalizations.of(context).fitness: fitnessColor,
      AppLocalizations.of(context).personal: personalColor
    };

    return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 33, top: 26, bottom: 20),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                buildItem(i, items.keys.elementAt(i), items.values.elementAt(i),
                    i == widget.selectedIndex),
            ],
          ),
        ));
  }
}
