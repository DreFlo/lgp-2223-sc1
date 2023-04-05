import 'package:flutter/material.dart';

class SearchMedia extends StatefulWidget {
  const SearchMedia({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchMedia> createState() => _SearchMediaState();
}

class _SearchMediaState extends State<SearchMedia>
    with SingleTickerProviderStateMixin  {
  late TabController tabController ;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      body: 
          Padding(padding: EdgeInsets.only(top: 22*fem),
          child:
          TabBar(
            controller: tabController ,
            tabs: [
              Tab(
                text: 'Movies',
              ),
              Tab(
                text: 'Tv Shows',
              ),
              Tab(
                text: 'Books',
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
          */


      );
  }
}
