// ignore_for_file: file_names
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBar({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _searchTextController;
  
  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {
        // _searchText = _searchTextController.text;
      });
    });
  }

  

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return  Padding(
            padding: EdgeInsets.fromLTRB(10 * fem, 10 * fem, 0, 0),
            child: Center(
              child: Container(
                width: 327 * fem,
                height: 50 * fem,
                child: Center(
                  child: TextField(
                    controller: _searchTextController,
                    onSubmitted: (text) => widget.onSearch(text),
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xff5e6272),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      filled: true,
                      fillColor: const Color(0xffdadada),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
