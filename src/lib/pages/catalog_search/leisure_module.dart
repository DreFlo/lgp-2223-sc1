import 'package:flutter/material.dart';
import 'package:src/pages/catalog_search/leisure_module/search.dart';
import 'package:src/pages/catalog_search/leisure_module/catalog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:src/pages/catalog_search/search_bar.dart';

class LeisureModule extends StatefulWidget {
  const LeisureModule({Key? key}) : super(key: key);

  @override
  State<LeisureModule> createState() => _LeisureModuleState();
}

class _LeisureModuleState extends State<LeisureModule>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
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
                  AppLocalizations.of(context).media,
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
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TabBar(
                controller: tabController,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context).my_media,
                  ),
                  Tab(
                    text: AppLocalizations.of(context).discover,
                  ),
                ],
              )),
          const SizedBox(height: 15),
          SearchBar(onSearch: onSearch),
          const SizedBox(height: 15),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // My Media TabBarView
                Catalog(search: searchText),
                // Discover TabBarView
                SearchMedia(search: searchText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
