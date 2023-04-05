import 'package:flutter/material.dart';
import 'Media.dart';

class SeeAll extends StatelessWidget {
  final List media;

  const SeeAll({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
        body: /*Container(
      child: Column(
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
                  'All Media',
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
          ),*/
           Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20 * fem),
                        child:
         GridView.count(
  crossAxisCount: 3,
  childAspectRatio: 0.7,
  //padding: EdgeInsets.all(16.0), // add 16 pixels of padding around the grid
  mainAxisSpacing: 22.0*fem, // add 16 pixels of spacing between rows
  crossAxisSpacing: 10.0*fem, // add 16 pixels of spacing between columns
  children: List.generate(media.length, (index) {
    return Media(image: media[index]['poster_path']);
  }),
))
    )
        /*]
        )
        )
        )*/;
  }
}
