import 'package:flutter/material.dart';

class SearchMedia extends StatefulWidget {
  const SearchMedia({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchMedia> createState() => _SearchMediaState();
}

class _SearchMediaState extends State<SearchMedia>
    with SingleTickerProviderStateMixin {
  late TabController tabController ;
  //late TabController mediaTypeTabController;

  @override
  void initState() {
    tabController  = TabController(length: 2, vsync: this);
    //mediaTypeTabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController .dispose();
   // mediaTypeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10 * fem, 50 * fem, 0, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Media',
                  style: TextStyle(
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
          ),
          Padding(padding: EdgeInsets.only(top: 22*fem),
          child:
          TabBar(
            controller: tabController ,
            tabs: [
              Tab(
                text: 'My Media',
              ),
              Tab(
                text: 'Discover',
              ),
            ],
          )),
          /*Expanded(
            child: TabBarView(
              controller: myMediaTabController,
              children: [
                // My Media TabBarView
                Container(
                  child: Center(
                    child: Text('My Media'),
                  ),
                ),
                // Discover TabBarView
                Container(
                  child: Center(
                    child: Text('Discover'),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: mediaTypeTabController,
            tabs: [
              Tab(
                text: 'Movies',
              ),
              Tab(
                text: 'TV Shows',
              ),
              Tab(
                text: 'Books',
              ),
            ],
          ),*/

        ],
      ),
    );
  }
}
