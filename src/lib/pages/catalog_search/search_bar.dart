import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return Center(
      child: SizedBox(
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
              hintText: AppLocalizations.of(context).search,
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
          ),
        ),
      ),
    );
  }
}
