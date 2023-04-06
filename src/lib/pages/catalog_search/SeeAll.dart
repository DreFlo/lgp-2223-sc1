// ignore_for_file: file_names,  sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/SearchBar.dart';
import 'ListMedia.dart';

class SeeAll extends StatefulWidget {
  final List media;
  final String title;

  const SeeAll({Key? key, required this.title, required this.media})
      : super(key: key);

  @override
  SeeAllState createState() => SeeAllState();
}

class SeeAllState extends State<SeeAll> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String searchText = '';
  void onSearch(String text) {
    setState(() {
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: const Color(0xFF181A20),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF5E6272), width: 0.5)),
                    child: IconButton(
                      splashRadius: 0.1,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_rounded),
                      iconSize: 15,
                      color: const Color(0xFF5E6272),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBar(onSearch: onSearch),
          Expanded(
            child: ListMedia(title: widget.title, media: widget.media),
          )
        ],
      ),
    );
  }
}
